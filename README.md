# FF11-GearSwap-PUP (v2.2)

FF11（ファイナルファンタジーXI）のからくり士（PUP）用 GearSwap スクリプトです。
オートマトンの **挑発（ストロボ）**・**フラッシュバルブ** のリキャストを管理して **発動の2秒前に敵対心装備へ先回りして着替え**、マトンの **TPが930に届いたらWS装備へ事前着替え** します。

---

## 主な機能

1. **ストロボ・フラッシュバルブの事前着替え**
   - アタッチメント（ストロボ／ストロボII・フラッシュバルブ）と、対応するマニューバ（火・光）が付いているときに、リキャストの残りが2秒以下になると、自動で `sets.midcast.Pet['Provoke']` / `['Flashbulb']` に着替えます。
   - リキャストは、挑発 30秒・フラッシュバルブ 45秒 で計算します。
2. **マトンWSの事前着替え**
   - マトンのTPが930以上になると、`sets.midcast.Pet.WeaponSkill` に着替えて待ちます。
   - 技ごとのセット（例: `sets.midcast.Pet['ボーンクラッシャー']`）があれば、発動時にそちらを使います。
3. **優先順位で誤着替えを防止**
   - ストロボ ➔ フラッシュバルブ ➔ マトンWS ➔ 通常装備 の順で、今着るべき装備を1つだけ決めます。
   - 本体やマトンが行動している最中は着替えないので、行動用の装備を崩しません。
4. **引き戻し中もタイマーを維持**
   - マトンを手元に引き戻しても、リキャストのタイマーは数え続けます。マトンが消えたときだけ初期化します。
5. **10秒の安全ガード**
   - 事前着替えから10秒たっても発動しない場合は、発動したものとみなして通常装備に戻ります。

---

## v2.1 の変更点（v2.0 から）

- **ストロボ・フラッシュバルブの検出を正確に**: マトンの行動パケットの「技ID」で判定するようにしました。v2.0 ではマトンのほかの行動やチャットの文字でタイマーがリセットされることがありましたが、それが起きなくなりました。
- **動作を軽く**: 毎フレーム呼ばれる処理（中身は 1 秒に 1 回だけ実行）と行動パケットの処理を、GearSwap の装備処理を挟まない方法（`raw_register_event`）で受けるようにしました。
- **行動中は着替えない**: 本体・マトンの行動中（`midaction()` / `pet_midaction()`）は事前着替えを止めます。
- **マニューバの判定をバフIDに**: 表記ゆれの影響を受けません。
- （v2.1 に入っていた本体の自動WSは、v2.2 で公開版から外しました。）
- `user-globals.lua` の `job_self_command` を上書きせずに、前に処理を差し込む方式にしました。

---

## 必要なもの

| 必要なもの | 説明 |
| :--- | :--- |
| **Windower 4 + GearSwap** | GearSwap は Windower のアドオン一覧から入れられます |
| **Mote-Include** | GearSwap に最初から入っています（`GearSwap/libs/Mote-Include.lua`） |
| **日本語クライアント** | アタッチメント名・WS名・装備名は日本語表記です |
| **ぐりーずさんの `user-globals.lua`（推奨）** | 武器の切り替え（`MainWeapons`）・初期武器・ロックスタイルはこのファイルの仕組みを使います。無くてもマトン用の着替えは動くはずですが、作者の環境では、`user-globals.lua` を入れた状態でしか確認していません |

`user-globals.lua` は [ぐりーずさんの GearSwap（ktgreeds/GearSwap）](https://github.com/ktgreeds/GearSwap/tree/main/data) から入手できます。詳しくは [greeds.net の解説](https://greeds.net/gearswap-code-list/) を見てください。

---

## ファイル構成

```text
Windower4/addons/GearSwap/data/
├── PUP.lua              <-- ロジック（タイマー・優先度制御）
└── <キャラ名>/
    └── PUP_gear.lua     <-- 装備セット（自分の装備に書き換えて使う）
```

- `PUP_gear.lua` は `data/` の直下に置いても動きます（GearSwap は `data/<キャラ名>/` → `data/common/` → `data/` の順に探します）。
- 同梱の `PUP_gear.lua` は作者の装備です。**自分の持っている装備に書き換えてください。**

---

## インストール方法

1. GitHub のページで **Code → Download ZIP** を押してダウンロードし、解凍します。
2. `PUP.lua` を `Windower4/addons/GearSwap/data/` に置きます。
3. `PUP_gear.lua` を `Windower4/addons/GearSwap/data/<キャラ名>/` に置き、自分の装備に書き換えます。
4. からくり士になって、ゲーム内で `//gs reload`（または `//gs load PUP`）を実行します。

---

## 装備セットの書き方（`PUP_gear.lua`）

| セット | 使われるとき |
| :--- | :--- |
| `sets.midcast.Pet['Provoke']` | ストロボの事前着替え・発動時 |
| `sets.midcast.Pet['Flashbulb']` | フラッシュバルブの事前着替え・発動時 |
| `sets.midcast.Pet.WeaponSkill` | マトンTP930以上での事前着替え・マトンWS発動時 |
| `sets.midcast.Pet['技の名前']` | その技の発動時（例: `['ボーンクラッシャー']`。無ければ WeaponSkill を使う） |
| `sets.idle` / `sets.engaged` など | 通常の装備（Mote-Include の標準どおり） |

- `sets.midcast.Pet` は Mote-Include が最初から用意しているので、`sets.midcast.Pet = {}` と書き直す必要はありません。
- 武器の選択肢（`state.MainWeapons`）の名前は、`PUP_gear.lua` の `gear['名前']` と一致させてください。

---

## コマンド（ゲーム内マクロ用）

| コマンド | 内容 |
| :--- | :--- |
| `/console gs c cycle OffenseMode` | 戦闘中の装備を切り替え（Normal / Tate / Cut / hontai） |
| `/console gs c cycle IdleMode` | 待機装備を切り替え（Normal / Tate / cut2） |
| `/console gs c cycle MainWeapons` | 武器を切り替え（`user-globals.lua` が必要） |

---

## 謝辞・クレジット

本スクリプトのベース構造および開発知見は、**[ぐりーずさん (greeds.net)](https://greeds.net/gearswap-code-list/)** の解説とコード（[ktgreeds/GearSwap](https://github.com/ktgreeds/GearSwap)）を参考に、カスタマイズして作り直したものです。コードと知識を公開し続けてくださっていることに、感謝します。

---

## 免責事項

本スクリプトは、装備を着替える GearSwap のジョブファイルです。ウェポンスキルや魔法を自動で入力する機能はありません。

FFXI の利用規約では、外部ツールの利用が禁止されています。Windower と GearSwap も、これに当たる可能性があります。処分を受ける可能性があることを理解した上で、自己責任で使ってください。使用によって生じた不利益について、作者は責任を負えません。

## ライセンス

このリポジトリには、ライセンスを付けていません。ぐりーずさんのコードを元にした改変なので、再配布や転載はしないでください。

- **作者**: hikaruoshino
- **動作環境**: Windower 4 / GearSwap（Mote-Include）/ 日本語クライアント

---

## 更新履歴

- **v2.2 (2026-10-23)**: 本体の自動WS（`AutoWS`、`AutoWSName`）を公開版から削除。
- **v2.1 (2026-10-07)**: 技IDでのストロボ・フラッシュバルブ検出、処理の軽量化、行動中の着替え停止、マニューバをバフIDで判定、本体の自動WS（初期値 OFF）。
- **v2.0**: ストロボ・フラッシュバルブの事前着替え、マトンTP930でのWS事前着替え、引き戻し中のタイマー維持、10秒の安全ガード。
