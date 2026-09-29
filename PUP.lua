-------------------------------------------------------------------------------------------------------------------
-- PUP.lua - Mote-Include 対応 / フラッシュバルブ45秒復元・引き戻しタイマー維持完全版
-------------------------------------------------------------------------------------------------------------------

function get_sets()
    mote_include_version = 2
    include('Mote-Include.lua')
    set_language('japanese')
end

function job_setup()
    state.IdleMode:options('Normal', 'Tate')
    state.OffenseMode:options('Normal', 'Tate', 'Cut', 'hontai')
    state.WeaponskillMode:options('Normal', 'SubtleBlow')
    state.MainWeapons = M{'オータス', 'ニャフロンアダーガ', '乾坤圏', 'ミッドナイト', 'ウルスラグナ', 'サクパタフィスト'}
    state.RangeWeapons = M{'Ｐ．ストリンガー+1'}
end

-------------------------------------------------------------------
-- 内部制御変数
-------------------------------------------------------------------
local strobe_time = 0
local strobe_recast = 0
local strobe_equipped_time = 0

local flashbulb_time = 0
local flashbulb_recast = 0
local flashbulb_equipped_time = 0

local is_strobe_equipped = false
local is_flashbulb_equipped = false
local is_ws_equipped = false
local last_check = 0

-------------------------------------------------------------------
-- アタッチメント装着判定ヘルパー関数
-------------------------------------------------------------------
local function has_strobe_attachment()
    if not pet.isvalid or not pet.attachments then return false end
    return (pet.attachments.strobe or pet.attachments['strobe II'] or pet.attachments['ストロボ'] or pet.attachments['ストロボII']) and true or false
end

local function has_flashbulb_attachment()
    if not pet.isvalid or not pet.attachments then return false end
    return (pet.attachments.flashbulb or pet.attachments['フラッシュバルブ']) and true or false
end

-------------------------------------------------------------------
-- Mote-libs 標準ペットミッドキャスト（技・アビリティ発動時）
-------------------------------------------------------------------
function job_pet_midcast(spell, action, spellMap, eventArgs)
    if not spell then return end

    -- ① 挑発（ストロボ）発動時
    if spell.english == 'Provoke' or spell.japanese == '挑発' or spell.name == 'Strobe' then
        if sets.midcast and sets.midcast.Pet and sets.midcast.Pet['Provoke'] then
            equip(sets.midcast.Pet['Provoke'])
            eventArgs.handled = true
        end

    -- ② フラッシュバルブ発動時
    elseif spell.english == 'Flashbulb' or spell.japanese == 'フラッシュバルブ' then
        if sets.midcast and sets.midcast.Pet and sets.midcast.Pet['Flashbulb'] then
            equip(sets.midcast.Pet['Flashbulb'])
            eventArgs.handled = true
        end

    -- ③ マトンのウェポンスキル（WS）発動時
    elseif spell.type == 'PuppetWS' then
        is_strobe_equipped = false
        is_flashbulb_equipped = false
        is_ws_equipped = true
        if sets.midcast and sets.midcast.Pet then
            if sets.midcast.Pet[spell.japanese] or sets.midcast.Pet[spell.english] then
                equip(sets.midcast.Pet[spell.japanese] or sets.midcast.Pet[spell.english])
                eventArgs.handled = true
            elseif sets.midcast.Pet.WeaponSkill then
                equip(sets.midcast.Pet.WeaponSkill)
                eventArgs.handled = true
            end
        end
    end
end

-------------------------------------------------------------------
-- タイマーリセット＆通常装備復帰の共通処理
-------------------------------------------------------------------
local function reset_strobe_timer()
    strobe_time = os.time()
    strobe_recast = 30
    is_strobe_equipped = false
    strobe_equipped_time = 0
    if handle_equipping_gear then handle_equipping_gear(player.status) end
end

local function reset_flashbulb_timer()
    flashbulb_time = os.time()
    flashbulb_recast = 45
    is_flashbulb_equipped = false
    flashbulb_equipped_time = 0
    if handle_equipping_gear then handle_equipping_gear(player.status) end
end

-------------------------------------------------------------------
-- ペットアクション完了時
-------------------------------------------------------------------
function job_pet_aftercast(spell, action, spellMap, eventArgs)
    is_ws_equipped = false
    if spell then
        if spell.english == 'Provoke' or spell.japanese == '挑発' or spell.name == 'Strobe' then
            reset_strobe_timer()
        elseif spell.english == 'Flashbulb' or spell.japanese == 'フラッシュバルブ' or spell.name == 'Flashbulb' then
            reset_flashbulb_timer()
        end
    end
    if handle_equipping_gear then
        handle_equipping_gear(player.status)
    end
end

-------------------------------------------------------------------
-- 毎秒監視＆リアルタイムタイマー計算 (prerender)
-------------------------------------------------------------------
windower.register_event('prerender', function()
    local now = os.time()
    if now == last_check then return end
    last_check = now

    -- 【タイマー計算】マトンが存在していれば引き戻し中に関わらず地球時間で独立カウント（フラッシュバルブ: 45秒）
    if pet.isvalid then
        if strobe_time > 0 then
            local elapsed = now - strobe_time
            strobe_recast = (elapsed < 30) and (30 - elapsed) or 0
        else
            strobe_recast = 0
        end

        if flashbulb_time > 0 then
            local elapsed = now - flashbulb_time
            flashbulb_recast = (elapsed < 45) and (45 - elapsed) or 0
        else
            flashbulb_recast = 0
        end
    else
        -- マトン非存在（消滅）時のみタイマー・フラグを全初期化
        strobe_time = 0
        strobe_recast = 0
        strobe_equipped_time = 0
        flashbulb_time = 0
        flashbulb_recast = 0
        flashbulb_equipped_time = 0
        is_strobe_equipped = false
        is_flashbulb_equipped = false
        is_ws_equipped = false
        return
    end

    -- 【着替え判定】マトンが戦闘（Engaged）状態の場合のみ着替え制御を行う
    if pet.status == 'Engaged' then
        local has_fire = (buffactive['Fire Maneuver'] or buffactive['ファイアマニューバ'] or buffactive['火マニューバ'])
        local has_light = (buffactive['Light Maneuver'] or buffactive['ライトマニューバ'] or buffactive['光マニューバ'])

        -- 事前着替え判定（リキャスト2秒以下、または0秒＝即発動可能）
        local strobe_due = has_strobe_attachment() and has_fire and strobe_recast <= 2
        local flashbulb_due = has_flashbulb_attachment() and has_light and flashbulb_recast <= 2

        -- 安全ガード：10秒以上発動しない場合は自動リセット
        if is_strobe_equipped and strobe_equipped_time > 0 and (now - strobe_equipped_time >= 10) then
            reset_strobe_timer()
            strobe_due = false
        end
        if is_flashbulb_equipped and flashbulb_equipped_time > 0 and (now - flashbulb_equipped_time >= 10) then
            reset_flashbulb_timer()
            flashbulb_due = false
        end

        -- 【優先度 1】 ストロボ事前着替え
        if strobe_due then
            if not is_strobe_equipped then
                is_strobe_equipped = true
                is_flashbulb_equipped = false
                is_ws_equipped = false
                strobe_equipped_time = now
                if sets.midcast and sets.midcast.Pet and sets.midcast.Pet['Provoke'] then
                    equip(sets.midcast.Pet['Provoke'])
                end
            end

        -- 【優先度 2】 フラッシュバルブ事前着替え
        elseif flashbulb_due then
            if not is_flashbulb_equipped then
                is_strobe_equipped = false
                is_flashbulb_equipped = true
                is_ws_equipped = false
                flashbulb_equipped_time = now
                if sets.midcast and sets.midcast.Pet and sets.midcast.Pet['Flashbulb'] then
                    equip(sets.midcast.Pet['Flashbulb'])
                end
            end

        -- 【優先度 3】 マトンTP930以上到達時のWS事前着替え
        elseif pet.tp >= 930 then
            if not is_ws_equipped then
                is_ws_equipped = true
                is_strobe_equipped = false
                is_flashbulb_equipped = false
                if sets.midcast and sets.midcast.Pet and sets.midcast.Pet.WeaponSkill then
                    equip(sets.midcast.Pet.WeaponSkill)
                end
            end

        -- 【優先度 4】 通常装備への復帰
        else
            if is_strobe_equipped or is_flashbulb_equipped or is_ws_equipped then
                is_strobe_equipped = false
                is_flashbulb_equipped = false
                is_ws_equipped = false
                strobe_equipped_time = 0
                flashbulb_equipped_time = 0
                if handle_equipping_gear then handle_equipping_gear(player.status) end
            end
        end
    else
        -- マトンがEngaged以外（引き戻し時）は着替えフラグのみ解除して通常/待機装備へ復帰（タイマー自体は維持）
        if is_strobe_equipped or is_flashbulb_equipped or is_ws_equipped then
            is_strobe_equipped = false
            is_flashbulb_equipped = false
            is_ws_equipped = false
            strobe_equipped_time = 0
            flashbulb_equipped_time = 0
            if handle_equipping_gear then handle_equipping_gear(player.status) end
        end
    end
end)

-------------------------------------------------------------------
-- パケット／テキスト受信時のタイマーリセット処理
-------------------------------------------------------------------
windower.register_event('action', function(act)
    if pet.isvalid and act and act.actor_id == pet.id then
        if act.category == 6 or act.category == 11 or act.category == 13 then
            if is_strobe_equipped or (has_strobe_attachment() and strobe_recast <= 2) then
                reset_strobe_timer()
            elseif is_flashbulb_equipped or (has_flashbulb_attachment() and flashbulb_recast <= 2) then
                reset_flashbulb_timer()
            end
        end
    end
end)

windower.register_event('incoming text', function(original, modified, mode)
    if not original or type(original) ~= 'string' or not pet.isvalid then return end
    if pet.name and string.find(original, pet.name) then
        if string.find(original, "Provoke") or string.find(original, "挑発") or string.find(original, "Strobe") then
            reset_strobe_timer()
        elseif string.find(original, "Flashbulb") or string.find(original, "フラッシュバルブ") then
            reset_flashbulb_timer()
        end
    end
    return modified, mode
end)