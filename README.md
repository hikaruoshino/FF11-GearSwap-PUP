# FF11 GearSwap - PUP.lua (Puppetmaster / からくり士)

A custom **GearSwap (Mote-libs based)** user script for Puppetmaster (PUP) in Final Fantasy XI (FFXI).  
FF11の Windower アドオン「GearSwap（Mote-libsベース）」向けからくり士用自動着替えスクリプトです。

Designed to handle **Strobe (Provoke) / Flashbulb enmity pre-swapping** and **TP WeaponSkill pre-swapping** with precise timing, attachment detection, and real-time timer tracking.  
盾マトン運用時の**ストロボ（挑発）/ フラッシュバルブの敵対心装備事前換装**、および**TP蓄積時のWS事前換装**を正確かつスムーズに制御します。

---

## 🚀 Key Features / 主な機能と特長

1. **Automatic Attachment Detection / アタッチメント自動判定**
   - Pre-swapping logic triggers **only when Strobe (I/II) or Flashbulb attachments are equipped**.
   - No unnecessary gear swaps when using Sharpshot (Ranged) or Mage frames without enmity attachments.
   - オートマトンに「ストロボ（I/II）」または「フラッシュバルブ」が装着されている場合のみ事前着替えが作動します（未装着時は不要な着替えを行いません）。

2. **Real-Time Independent Cooldown Tracking (Deploy/Retreat Support) / リアルタイムタイマー管理（引き戻し動作対応）**
   - Tracks **Strobe (30s)** and **Flashbulb (45s)** recasts independently using real-world time.
   - Retains accurate cooldowns even when disengaging or pulling the Automaton back (`Deploy` / `Retreat` repositioning).
   - 挑発（30秒）・フラッシュバルブ（45秒）のリキャストを地球時間で独立管理。戦闘中にマトンを手元へ引き戻しても（Deploy/Retreat）、裏で正確に秒数を計算し続けます。

3. **Precise Enmity Pre-Swapping (2s Before Recast) / 敵対心事前換装（2秒前換装）**
   - Automatically equips Enmity gear (`sets.midcast.Pet['Provoke']` / `['Flashbulb']`) **2 seconds before** Strobe (Fire Maneuver active) or Flashbulb (Light Maneuver active).
   - Instantly reverts to normal/engaged gear upon action completion (packet/log detection).
   - Includes a 10s safety reset fallback to account for Automaton AI decision latency (4–5s lag).
   - 火マニューバ点灯時の「挑発」、光マニューバ点灯時の「フラッシュバルブ」の発動2秒前に自動で敵対心装備へ差し替わります。マトンAIの行動ラグ（4～5秒）に対応した10秒安全制御を搭載。

4. **TP >= 930 WeaponSkill Pre-Swapping & Priority Control / TP930以上でのWS事前換装と優先度制御**
   - Automatically pre-swaps to Automaton WS gear (`sets.midcast.Pet.WeaponSkill`) once Automaton TP reaches **930 or higher**.
   - **Priority Override**: If Strobe or Flashbulb becomes ready while TP is >= 930, **Enmity gear takes absolute priority** over WS gear so Provoke is never missed.
   - マトンのTPが930に達した時点でWS用装備へ移行します。TPが930以上溜まっていても、挑発のリキャストが来た場合は**アビリティ（敵対装備）を最優先**して着用します。

5. **First-Engagement Immediate Swapping / 初回交戦時（リキャスト0秒時）の即時換装**
   - Triggers enmity pre-swapping instantly on the very first engage if Fire/Light maneuvers are active, ensuring maximum initial hate generation.
   - 火/光マニューバが入った状態で敵にマトンをぶつけた最初の1発目から、逃さず敵対心装備に着替えてアビリティを発動します。

---

## 📁 Requirements & Directory Structure / 前提条件と配置場所

- **Environment**: Windower 4 + GearSwap
- **Dependency**: Mote-libs (`Mote-Include.lua`)
- **File Location**:
  - `Windower4/addons/GearSwap/data/YOUR_CHARACTER_NAME_PUP.lua`
  - OR `Windower4/addons/GearSwap/data/PUP.lua`

---

## ⚙️ Gear Set Definitions / 装備セット定義

Define the following sets in your `PUP_gear.lua` or inside `get_sets()` in `PUP.lua`:  
本スクリプト動作のため、以下の名称で装備セットを定義してください（英語名・日本語名双方の装備名に対応しています）。

- **Provoke / Strobe Set** (`sets.midcast.Pet['Provoke']`): Enmity+ gear (e.g., Heyoka set / ヘヨカ装備)
- **Flashbulb Set** (`sets.midcast.Pet['Flashbulb']`): Enmity+ / Magic Accuracy gear
- **Automaton WS Set** (`sets.midcast.Pet.WeaponSkill`): Pet WS damage gear (e.g., Tali'ah, Mpaca, Pitre / タリア・ムパカ等)

### Example Code (`PUP_gear.lua`):

```lua
-- Provoke / Strobe Gear (Enmity+)
sets.midcast.Pet['Provoke'] = {
    head="Heyoka Cap +1",        -- ヘヨカキャップ+1
    body="Heyoka Harness +1",    -- ヘヨカハーネス+1
    hands="Heyoka Mittens +1",   -- ヘヨカミトン+1
    legs="Heyoka Subligar +1",   -- ヘヨカサブリガ+1
    feet="Heyoka Leggings +1",   -- ヘヨカレギンス+1
    left_ear="Rimeice Earring",  -- ライムアイスピアス
    right_ear="Domesticator's Earring", -- ドメスティカピアス
}

-- Flashbulb Gear (Enmity+ / M.Acc)
sets.midcast.Pet['Flashbulb'] = {
    head="Heyoka Cap +1",
    body="Heyoka Harness +1",
    hands="Heyoka Mittens +1",
    legs="Heyoka Subligar +1",
    feet="Heyoka Leggings +1",
    left_ear="Rimeice Earring",
    right_ear="Domesticator's Earring",
}

-- Automaton WeaponSkill Gear
sets.midcast.Pet.WeaponSkill = {
    head="Tali'ah Turban +2",    -- タリアターバン+2
    body="Pitre Tobe +3",         -- ＰＩトベ+3
    hands="Mpaca's Gloves",      -- ムパカグローブ
    legs="Tali'ah Seraweels +2", -- タリアサラウィル+2
    feet="Mpaca's Boots",        -- ムパカブーツ
    neck="Empath Necklace",      -- エンパスネックレス
    waist="Incarnant Sash",      -- インカーネトサッシュ
    left_ear="Burana Earring",   -- ブラーナピアス
    right_ear="Karagoz Earring +1", -- カラゴズピアス+1
    left_ring="Paluq Ring",      -- パルーグリング
    right_ring="Overbearing Ring", -- オーバーベアリング
    back="Visucius's Mantle",    -- ビスシアスマント
}
```

---

## 📜 License & Disclaimer / ライセンス・免責事項

- **License**: MIT License (Feel free to use, modify, and distribute / 改変・再配布自由)
- **Disclaimer**: Use at your own risk. (利用は自己責任でお願いいたします)
