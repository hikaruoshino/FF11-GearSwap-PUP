function init_weaponns()
    send_command('gs c set MainWeapons '..windower.to_shift_jis('オータス'))
end


function init_gear_sets()
    -- ロックスタイル番号
    lockstyleset = 182

    -- 武器
    gear['オータス']                  = {name="オータス"}
    gear['ニャフロンアダーガ']        = {name="ニャフロンアダーガ"}
    gear['ミッドナイト']              = {name="ミッドナイト"}
    gear['ウルスラグナ']              = {name="ウルスラグナ"}
    gear['サクパタフィスト']          = {name="サクパタフィスト"}
	gear['乾坤圏']          = {name="乾坤圏"}
    gear.Slip                         = {name="フレンジーサリット"}

    --モクシャ
    sets.SubtleBlow = {
    }

    -- 待機装備
    sets.idle = {
--    range="Ｐ．ストリンガー+1",
    ammo="ルブリカント+3",
    head="タリアターバン+2",
    body="ＰＩトベ+4",
    hands="ＰＩダスタナ+3",
    legs={ name="ヘルクリアトラウザ", augments={'Pet: Attack+18 Pet: Rng.Atk.+18','Pet: "Store TP"+11','Pet: INT+1',}},
    feet={ name="ヘルクリアブーツ", augments={'Pet: "Store TP"+11','Pet: Attack+3 Pet: Rng.Atk.+3',}},
--    feet="ムパカブーツ",
    neck="エンパスネックレス",
    waist="クルスカサッシュ+1",
    left_ear="エンメルカルピアス",
    right_ear={ name="カラゴズピアス+1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Store TP"+5',}},
    left_ring="ヴァラールリング+1",
    right_ring="シュネデックリング",
    back={ name="ビスシアスマント", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: Haste+10','Pet: Damage taken -5%',}},
    }

    sets.idle.Tate = {
--    range="Ｐ．ストリンガー+1",
    ammo="ルブリカント+3",
    head={ name="羅王頭成兜改", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    body="ＦＯトベ+3",
    hands={ name="羅王篠篭手改", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    legs={ name="羅王板佩楯改", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    feet="ムパカブーツ",
    neck="エンパスネックレス",
    waist="イーサベルト",
    left_ear="ライムアイスピアス",
    right_ear={ name="カラゴズピアス+1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Store TP"+5',}},
    left_ring="オーバーベアリング",
    right_ring="シュネデックリング",
    back={ name="ビスシアスマント", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: "Regen"+10','Pet: "Regen"+5',}},
    }

    sets.idle.cut2 = {
    head="ニャメヘルム",
    body="ニャメメイル",
    hands="ニャメガントレ",
    legs="ニャメフランチャ",
    feet="ニャメソルレット",
    neck="バーシチョーカー+1",
    waist="プラチナモグベルト",
    left_ear="アスプロピアス",
    right_ear={ name="カラゴズピアス+1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Store TP"+5',}},
    left_ring="メランリング",
    right_ring="シュネデックリング",
    back={ name="ビスシアスマント", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: "Regen"+10','Pet: "Regen"+5',}},
    }

    sets.idle.cut = {
    range="Ｐ．ストリンガー+1",
    ammo="ルブリカント+3",
    head={ name="羅王頭成兜改", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    body="ＦＯトベ+3",
    hands={ name="羅王篠篭手改", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    legs={ name="羅王板佩楯改", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    feet="ムパカブーツ",
    neck="エンパスネックレス",
    waist="イーサベルト",
    left_ear="ライムアイスピアス",
    right_ear={ name="カラゴズピアス+1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Store TP"+5',}},
    left_ring="オーバーベアリング",
    right_ring="シュネデックリング",
    back={ name="ビスシアスマント", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: "Regen"+10','Pet: "Regen"+5',}},
    }

    -- 抜刀装備
    sets.engaged = {
--    range="Ｐ．ストリンガー+1",
    ammo="ルブリカント+3",
    head="タリアターバン+2",
    body="ＰＩトベ+4",
    hands="ＰＩダスタナ+3",
    legs={ name="ヘルクリアトラウザ", augments={'Pet: Attack+18 Pet: Rng.Atk.+18','Pet: "Store TP"+11','Pet: INT+1',}},
    feet={ name="ヘルクリアブーツ", augments={'Pet: "Store TP"+11','Pet: Attack+3 Pet: Rng.Atk.+3',}},
--    feet="ムパカブーツ",
    neck="エンパスネックレス",
    waist="クルスカサッシュ+1",
    left_ear="エンメルカルピアス",
    right_ear={ name="カラゴズピアス+1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Store TP"+5',}},
    left_ring="ヴァラールリング+1",
    right_ring="ヴァラールリング+1",
    back={ name="ビスシアスマント", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: Haste+10','Pet: Damage taken -5%',}},
    }

    sets.engaged.Tate = {
--    range="Ｐ．ストリンガー+1",
    ammo="ルブリカント+3",
    head={ name="羅王頭成兜改", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    body="ＦＯトベ+3",
    hands={ name="羅王篠篭手改", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    legs={ name="羅王板佩楯改", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    feet="ムパカブーツ",
    neck="エンパスネックレス",
    waist="イーサベルト",
    left_ear="ライムアイスピアス",
    right_ear={ name="カラゴズピアス+1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Store TP"+5',}},
    left_ring="オーバーベアリング",
    right_ring="ヴァラールリング+1",
    back={ name="ビスシアスマント", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: "Regen"+10','Pet: "Regen"+5',}},
    }

    sets.engaged.Cut = {
    main="サクパタフィスト",
--    range="Ｐ．ストリンガー+1",
    ammo="ルブリカント+3",
    head="ニャメヘルム",
    body="ニャメメイル",
    hands="ニャメガントレ",
    legs="ニャメフランチャ",
    feet="ニャメソルレット",
    neck="ロリケートトルク+1",
    waist="プラチナモグベルト",
    left_ear="アスプロピアス",
    right_ear="エアバニピアス",
    left_ring="メランリング",
    right_ring="ワーデンリング",
    back={ name="ビスシアスマント", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: "Regen"+10','Pet: "Regen"+5',}},
    }

    sets.engaged.hontai = {
    head="ムパカキャップ",
    body="ムパカダブレット",
    hands="マリグナスグローブ",
    legs="ムパカホーズ",
    feet="マリグナスブーツ",
    neck="無の喉輪",
    waist="月虹帯+1",
    left_ear="シェレピアス",
    right_ear="マーケピアス+1",
    left_ring="シーリチリング+1",
    right_ring="ゲリリング",
    back={ name="ビスシアスマント", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: Haste+10','Pet: Damage taken -5%',}},
    }

    -- ===================================================================
    -- 【Mote-libs仕様】オートマトン用アビリティ・WS装備
    -- ===================================================================
    -- 親の箱（sets.midcast.Pet）は Mote-Include.lua の中で最初から自動定義されているため、
    -- ここで「 sets.midcast.Pet = {} 」と初期化し直す必要はありません。

    -- ① 【一括共通】すべてのマトンWSで使う高威力装備セット
    sets.midcast.Pet.WeaponSkill = {
        head="ＫＧカペッロ+3",
        body="ＰＩトベ+4",
        hands="ムパカグローブ",
		legs="ＫＧパンタロニ+3",
        feet="ムパカブーツ",
        neck="エンパスネックレス",
        waist="インカーネトサッシュ",
        left_ear="ブラーナピアス",
        right_ear={ name="カラゴズピアス+1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Store TP"+5',}},
        left_ring="パルーグリング",
        right_ring="オーバーベアリング",
        back={ name="ビスシアスマント", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: Haste+10','Pet: Damage taken -5%',}},
    }

    -- ③ ボーンクラッシャー専用セット
    sets.midcast.Pet['ボーンクラッシャー'] = set_combine(sets.midcast.Pet.WeaponSkill, {
        head="ＫＧカペッロ+3",
        body="ＰＩトベ+4",
        hands="ムパカグローブ",
		legs="ＫＧパンタロニ+3",
        feet="ムパカブーツ",
        neck="エンパスネックレス",
        waist="インカーネトサッシュ",
        left_ear="ブラーナピアス",
        right_ear={ name="カラゴズピアス+1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Store TP"+5',}},
        left_ring="パルーグリング",
        right_ring="オーバーベアリング",
        back={ name="ビスシアスマント", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: Haste+10','Pet: Damage taken -5%',}},
    })
	
   
    sets.midcast.Pet['Provoke']  = {
        head="ヘヨカキャップ+1",
        body="ヘヨカハーネス+1",
        hands="ヘヨカミトン+1",
        legs="ヘヨカサブリガ+1",
        feet="ヘヨカレギンス+1",
        left_ear="ライムアイスピアス",
        right_ear="ドメスティカピアス",
    }

-- フラッシュバルブ用装備
    sets.midcast.Pet['Flashbulb'] = sets.midcast.Pet['Provoke']

	-- ⑥ バフ・アビリティ関連
   	sets.precast.JA['オーバードライヴ']     = set_combine({body="ＰＩトベ+4"})
   	sets.precast.JA['アクティベート']       = set_combine()
   	sets.precast.JA['応急処置']             = set_combine()
   	sets.precast.JA['リペアー']             = set_combine({legs="デサルタタセッツ",feet="ＦＯバブーシュ+2",left_ear="ギニョルピアス",right_ear="プラティクピアス"})
   	sets.precast.JA['黒衣チェンジ']         = set_combine({feet="ＰＩバブーシュ+4"})
   	sets.precast.JA['腹話術']               = set_combine({legs="ＰＩチュリダル+4"})
   	sets.precast.JA['タクティクスウィッチ'] = set_combine({feet="ＫＧスカルペ+3"})
   	sets.precast.JA['クールダウン']         = set_combine()
   	sets.precast.JA['ヘディーアーテフィス'] = set_combine()

    -- ⑦ マニューバ装備（カタカナで大元とカチッと一致させます）
    sets.precast.JA['マニューバ'] = set_combine({
        main="乾坤圏",
        head="ＰＩタージ+3",
        body="ＫＧファルセト+1",
        hands="ＦＯダスタナ+2",
        neck="バフーンカラー",
        left_ear="ブラーナピアス",
        back={ name="ビスシアスマント", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: Haste+10','Pet: Damage taken -5%',}}
    })


    -- FC装備
    sets.precast.FC = {
--    range="Ｐ．ストリンガー+1",
    head={ name="ヘルクリアヘルム", augments={'"Mag.Atk.Bns."+28','Weapon skill damage +2%','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
    body="ゼンディックローブ",
    hands="ニャメガントレ",
    legs="ギーヴトラウザ",
    feet="ニャメソルレット",
    neck="ベーテルペンダント",
    waist="プラチナモグベルト",
    left_ear="エンチャンピアス+1",
    right_ear={ name="カラゴズピアス+1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Store TP"+5',}},
    left_ring="プロリクスリング",
    right_ring="ラハブリング",
    }

    -- WSダメージ
    sets.precast.WS.Damage = {
--    range="Ｐ．ストリンガー+1",
    head="ニャメヘルム",
    body="ニャメメイル",
    hands="ニャメガントレ",
    legs="ニャメフランチャ",
    feet="ニャメソルレット",
    neck="フォシャゴルゲット",
    waist="フォシャベルト",
    left_ear="シェレピアス",
    right_ear="イシュヴァラピアス",
    left_ring="ニックマドゥリング",
    right_ring="コーネリアリング",
    }
    
    -- WS魔攻
    sets.precast.WS.Magic = {
    }
    
    --共通WS定義読み込み
    init_weapon_skill()

end
