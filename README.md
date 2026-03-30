# test_flutter_weekly_schedule_sample

最終更新日：2026-03-30

## 概要

**週間スケジュールをグリッド形式で表示する Flutter サンプルアプリ**です。

日〜土の 7 列・時刻軸（03:00〜24:00）を持つカレンダーグリッドをダイアログで表示し、予定イベントのタイムブロック・重複レイアウト・バッジマーカー・現在時刻インジケーターなどをシンプルな単一ファイルで実装したプロトタイプです。

---

## 主な機能

- **週間グリッド表示**：日〜土の 7 列 × 時刻軸（03:00〜24:00）を持つスクロール可能なカレンダーグリッド
- **イベントタイムブロック**：曜日・開始／終了時刻・タイトル・色・メモを持つ予定を矩形カードで表示
- **重複イベントの自動レイアウト**：同じ曜日で時間が重なるイベントを列分割して横並びに配置
- **バッジマーカー**：特定の曜日・時刻にアイコン付きバッジを表示（ツールチップ対応）
- **現在時刻インジケーター**：赤い水平線で今の時刻をリアルタイム表示
- **イベント詳細ダイアログ**：タップするとタイトル・曜日・時間帯・メモをポップアップ表示
- **土日ハイライト**：日曜・土曜列を薄い背景色で強調
- **縦横スクロール同期**：水平スクロール中も時刻ラベルが左端に固定表示

---

## 画面構成

```
WeeklySchedulePage（起動画面）
└── ElevatedButton（「週スケジュールを開く」）
    └── AlertDialog（週スケジュールダイアログ）
        ├── WeeklyScheduleView
        │   ├── _WeekHeader（日〜土ヘッダー行）
        │   ├── _TimeLabels（時刻ラベル、左端固定）
        │   ├── _GridPainter（CustomPaint グリッド線・土日背景）
        │   ├── _EventCard × N（イベントタイムブロック）
        │   ├── BadgeMarker × N（アイコンバッジ）
        │   └── _NowIndicatorLine（現在時刻赤線）
        └── TextButton（「閉じる」）
```

---

## ファイル構成

```
lib/
└── main.dart          # エントリーポイント＋全クラス定義（単一ファイル構成）

    ScheduleEvent      # イベントデータクラス（曜日・開始終了時刻・タイトル・色・メモ）
    BadgeMarker        # バッジマーカーデータクラス（曜日・時刻・アイコン・色・ツールチップ）
    WeeklySchedulePage # 起動画面 Widget
    WeeklyScheduleView # 週間グリッド本体 Widget
    _WeekHeader        # 曜日ヘッダー行
    _TimeLabels        # 時刻ラベル列
    _GridPainter       # グリッド線・土日背景の CustomPainter
    _EventCard         # イベントタイムブロックカード
    _NowIndicatorLine  # 現在時刻インジケーター
    _PlacedEvent       # レイアウト計算用内部クラス
    _placeWeekly()     # 全曜日のイベント配置計算
    _placeForOneDay()  # 1 曜日分のクラスタリング
    _assignColumns()   # 重複イベントへの列割り当て
```

---

## 主要データクラス

### `ScheduleEvent`（予定イベント）

| フィールド       | 型        | 説明                            |
|----------------|-----------|---------------------------------|
| `dayIndex`     | `int`     | 曜日インデックス（0=日〜6=土）   |
| `startMinutes` | `int`     | 開始時刻（深夜 0 時からの分数）  |
| `endMinutes`   | `int`     | 終了時刻（深夜 0 時からの分数）  |
| `title`        | `String`  | イベントタイトル                 |
| `color`        | `Color`   | タイムブロックの表示色           |
| `memo`         | `String?` | メモ（任意）                    |

### `BadgeMarker`（バッジマーカー）

| フィールド      | 型          | 説明                            |
|---------------|-------------|---------------------------------|
| `dayIndex`    | `int`       | 曜日インデックス（0=日〜6=土）  |
| `minutesOfDay`| `int`       | 表示位置（深夜 0 時からの分数） |
| `icon`        | `IconData`  | アイコン                        |
| `color`       | `Color`     | アイコンの色                    |
| `tooltip`     | `String?`   | ツールチップテキスト（任意）    |

---

## 依存パッケージ

### dependencies

| パッケージ          | バージョン  | 用途               |
|--------------------|------------|-------------------|
| `flutter`          | SDK        | Flutter フレームワーク |
| `cupertino_icons`  | `^1.0.8`   | iOS スタイルアイコン   |

### dev_dependencies

| パッケージ        | バージョン  | 用途               |
|------------------|------------|-------------------|
| `flutter_lints`  | `^5.0.0`   | 推奨 Lint ルール    |

---

## 環境

| 項目       | バージョン  |
|-----------|-----------|
| Dart SDK  | `^3.8.1`  |

---

## セットアップ

```bash
# リポジトリのクローン
git clone https://github.com/toyotarou/test_flutter_weekly_schedule_sample.git
cd test_flutter_weekly_schedule_sample

# パッケージの取得
flutter pub get

# アプリの実行
flutter run
```

---

## 対応プラットフォーム

- Android
- iOS
- Web
- macOS
- Linux
- Windows
