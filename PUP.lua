-------------------------------------------------------------------------------------------------------------------
-- PUP.lua - Mote-Include 対応 / 引き戻しタイマー維持・優先度完全制御 ＋ TP1000即撃ち自動実行 v2.1
-------------------------------------------------------------------------------------------------------------------

function get_sets()
    mote_include_version = 2
    include('Mote-Include.lua')
    set_language('japanese')

    -- 装備定義ファイルの読み込み
    include('PUP_gear.lua')
end

function job_setup()
    state.IdleMode:options('Normal', 'Tate', 'cut2')
    state.OffenseMode:options('Normal', 'Tate', 'Cut', 'hontai')
    state.WeaponskillMode:options('Normal', 'SubtleBlow')
    state.MainWeapons = M{'オータス', 'ニャフロンアダーガ', '乾坤圏', 'ミッドナイト', 'シュコアトル', 'ウルスラグナ', 'サクパタフィスト'}
    state.RangeWeapons = M{'Ｐ．ストリンガー+1'}

    -- 毎秒の監視処理を「gs c pup_tick」で受け取る。
    -- job_self_command は user-globals.lua で定義済みなので、上書きせずに前段へ差し込む。
    local base_self_command = job_self_command
    job_self_command = function(cmdParams, eventArgs)
        if cmdParams[1] == 'pup_tick' then
            pup_tick()
            eventArgs.handled = true
        elseif base_self_command then
            base_self_command(cmdParams, eventArgs)
        end
    end

    -- 装備セット初期化（PUP_gear.lua）
    if init_gear_sets then init_gear_sets() end
end

-------------------------------------------------------------------
-- 定数
-------------------------------------------------------------------
local STROBE_RECAST = 30         -- ストロボ（挑発）の再使用間隔 (秒)
local FLASHBULB_RECAST = 45      -- フラッシュバルブの再使用間隔 (秒)
local PRE_EQUIP_SEC = 2          -- 再使用まで残りこの秒数以下で事前着替え
local PRE_EQUIP_TIMEOUT = 10     -- 事前着替えから発動しないまま、この秒数で諦める
local PET_WS_TP = 930            -- マトンWS用装備へ事前着替えするマトンTP

-- オートマトンの技ID (res/monster_abilities.lua)。行動パケット(カテゴリ11)の param と比べる
local ABIL_PROVOKE = 1945
local ABIL_FLASHBULB = 1947

-- バフID (res/buffs.lua)
local BUFF_FIRE_MANEUVER = 300
local BUFF_LIGHT_MANEUVER = 306

-------------------------------------------------------------------
-- 内部制御変数
-------------------------------------------------------------------
local strobe_time = 0            -- 最後にストロボ（挑発）が出た時刻。0 = 未発動
local flashbulb_time = 0         -- 最後にフラッシュバルブが出た時刻。0 = 未発動

-- 今着ているマトン用装備: nil(通常) / 'strobe' / 'flashbulb' / 'ws'
local pet_gear = nil
local pet_gear_since = 0

-------------------------------------------------------------------
-- 判定ヘルパー
-------------------------------------------------------------------
local function has_attachment(...)
    if not pet.isvalid or not pet.attachments then return false end
    for _, name in ipairs({...}) do
        if pet.attachments[name] then return true end
    end
    return false
end

local function recast_left(fired_time, recast, now)
    if fired_time == 0 then return 0 end
    return math.max(0, recast - (now - fired_time))
end

local function pet_set(name)
    return sets.midcast and sets.midcast.Pet and sets.midcast.Pet[name]
end

-- マトン用装備を着る。set が無ければ何もしない
local function wear_pet_gear(mode, set, now)
    pet_gear = mode
    pet_gear_since = now
    if set then equip(set) end
end

-- 通常装備に戻す
local function restore_gear()
    pet_gear = nil
    pet_gear_since = 0
    handle_equipping_gear(player.status)
end

-------------------------------------------------------------------
-- Mote-libs 標準ペットミッドキャスト（技・アビリティ発動時）
-------------------------------------------------------------------
function job_pet_midcast(spell, action, spellMap, eventArgs)
    if not spell then return end

    if spell.english == 'Provoke' then
        local set = pet_set('Provoke')
        if set then
            equip(set)
            eventArgs.handled = true
        end

    elseif spell.english == 'Flashbulb' then
        local set = pet_set('Flashbulb')
        if set then
            equip(set)
            eventArgs.handled = true
        end

    -- マトンのWS（連携属性を持つ技）
    elseif spell.skillchain_a then
        pet_gear = 'ws'
        local set = pet_set(spell.japanese) or pet_set(spell.english) or pet_set('WeaponSkill')
        if set then
            equip(set)
            eventArgs.handled = true
        end
    end
end

-------------------------------------------------------------------
-- ペットアクション完了時（装備の戻しは Mote 標準処理が行う）
-------------------------------------------------------------------
function job_pet_aftercast(spell, action, spellMap, eventArgs)
    pet_gear = nil
    pet_gear_since = 0
end

-------------------------------------------------------------------
-- マトン用装備の事前着替え
-------------------------------------------------------------------
local function update_pet_gear(now)
    if not pet.isvalid then
        -- マトン消滅時はタイマーを初期化し、着ていたマトン用装備も戻す
        strobe_time = 0
        flashbulb_time = 0
        if pet_gear then restore_gear() end
        return
    end

    -- 本体・マトンの行動中は着替えない（行動用の装備を崩さないため）
    if midaction() or pet_midaction() then return end

    -- 事前着替えしたのに発動しない場合は、発動したものとみなして諦める
    if pet_gear == 'strobe' and now - pet_gear_since >= PRE_EQUIP_TIMEOUT then
        strobe_time = now
    elseif pet_gear == 'flashbulb' and now - pet_gear_since >= PRE_EQUIP_TIMEOUT then
        flashbulb_time = now
    end

    -- 今着るべきマトン用装備を決める（上ほど優先）
    local want = nil
    if pet.status == 'Engaged' then
        if has_attachment('ストロボ', 'ストロボII') and buffactive[BUFF_FIRE_MANEUVER]
                and recast_left(strobe_time, STROBE_RECAST, now) <= PRE_EQUIP_SEC then
            want = 'strobe'
        elseif has_attachment('フラッシュバルブ') and buffactive[BUFF_LIGHT_MANEUVER]
                and recast_left(flashbulb_time, FLASHBULB_RECAST, now) <= PRE_EQUIP_SEC then
            want = 'flashbulb'
        elseif (pet.tp or 0) >= PET_WS_TP then
            want = 'ws'
        end
    end

    if want == pet_gear then return end

    if want == 'strobe' then
        wear_pet_gear('strobe', pet_set('Provoke'), now)
    elseif want == 'flashbulb' then
        wear_pet_gear('flashbulb', pet_set('Flashbulb'), now)
    elseif want == 'ws' then
        wear_pet_gear('ws', pet_set('WeaponSkill'), now)
    else
        restore_gear()
    end
end

-------------------------------------------------------------------
-- 毎秒の処理（gs c pup_tick から呼ばれる）
-------------------------------------------------------------------
function pup_tick()
    local now = os.time()
    update_pet_gear(now)
end

-------------------------------------------------------------------
-- イベント
-- GearSwap の register_event は呼ばれるたびに装備処理を挟むため、毎フレーム・
-- 全行動パケットで動くものは raw_register_event で受けて、必要なときだけ処理する
-------------------------------------------------------------------
local last_tick = 0
windower.raw_register_event('prerender', function()
    local now = os.time()
    if now == last_tick then return end
    last_tick = now
    send_command('gs c pup_tick')
end)

-- マトンのストロボ（挑発）・フラッシュバルブを技IDで検出してタイマーを更新する。
-- 装備の戻しは次の pup_tick が行う
windower.raw_register_event('action', function(act)
    if act.category ~= 11 then return end
    if act.param ~= ABIL_PROVOKE and act.param ~= ABIL_FLASHBULB then return end

    local my_pet = windower.ffxi.get_mob_by_target('pet')
    if not my_pet or act.actor_id ~= my_pet.id then return end

    if act.param == ABIL_PROVOKE then
        strobe_time = os.time()
    else
        flashbulb_time = os.time()
    end
end)
