//
//  LocalizedStrings.swift
//  DotenkoV4
//
//  アプリの文字列リソースを管理
//  画面別、機能別に文字列を整理
//

import Foundation

// MARK: - 共通文字列
struct CommonStrings {
    static let ok = "OK"
    static let cancel = "キャンセル"
    static let close = "閉じる"
    static let retry = "再試行"
    static let loading = "読み込み中..."
    static let error = "エラー"
    static let success = "成功"
    static let back = "戻る"
    static let next = "次へ"
    static let skip = "スキップ"
    static let done = "完了"
}

// MARK: - アプリ情報
struct AppStrings {
    static let appName = "DOTENKO"
    static let appTitle = "DOTENKO"
    static let version = "バージョン"
    static let copyright = "© 2024 DOTENKO Team"
}

// MARK: - スプラッシュ画面
struct SplashStrings {
    static let loadingMessage = "ゲームを準備中..."
    static let loadingProgress = "読み込み中"
    static let initialization = "初期化中..."
    static let checkingUpdate = "アップデート確認中..."
}

// MARK: - トップ画面
struct TopStrings {
    static let welcomeMessage = "カジノへようこそ"
    static let startGame = "START"
    static let gameTitle = "DOTENKO"
    static let tapToStart = "タップしてスタート"
}

// MARK: - ホーム画面
struct HomeStrings {
    static let homeTitle = "HOME"
    static let playerName = "プレイヤー名"
    static let gameMode = "ゲームモード"
    static let vsCPU = "vs CPU"
    static let vsOnline = "vs オンライン"
    static let comingSoon = "Coming Soon!"
    static let tabBarHomeDescription = "タブバー構成のホーム画面実装予定"
}

// MARK: - ゲーム設定画面
struct GameSettingsStrings {
    static let title = "ゲーム設定"
    static let initialRate = "初期レート"
    static let scoreLimit = "スコア上限"
    static let deckCycle = "デッキサイクル"
    static let uprateSettings = "Uprate設定"
    static let soundEffect = "効果音"
    static let vibration = "バイブレーション"
    static let backgroundMusic = "BGM"
    static let gameRules = "ゲームルール"
}

// MARK: - ヘルプ画面
struct HelpStrings {
    static let title = "ヘルプ"
    static let appSettings = "アプリ設定"
    static let gameRules = "ゲームルール"
    static let termsOfService = "利用規約"
    static let contact = "お問い合わせ"
    static let faq = "よくある質問"
    static let tutorial = "チュートリアル"
    static let about = "このアプリについて"
}

// MARK: - ゲーム画面
struct GameStrings {
    static let title = "DOTENKOゲーム"
    static let dotenko = "DOTENKO"
    static let shotenko = "しょてんこ"
    static let pass = "パス"
    static let drawCard = "カードを引く"
    static let challengeZone = "チャレンジゾーン"
    static let participate = "参加"
    static let decline = "辞退"
    static let yourTurn = "あなたのターン"
    static let waitingForPlayer = "相手の手番を待っています"
    static let gameOver = "ゲーム終了"
    static let winner = "勝者"
    static let loser = "敗者"
    static let draw = "引き分け"
}

// MARK: - スコア・結果画面
struct ScoreStrings {
    static let finalScore = "最終スコア"
    static let highScore = "ハイスコア"
    static let newRecord = "新記録！"
    static let totalScore = "合計スコア"
    static let gameResult = "ゲーム結果"
    static let playAgain = "もう一度プレイ"
    static let shareScore = "スコアをシェア"
    static let leaderboard = "ランキング"
}

// MARK: - エラーメッセージ
struct ErrorStrings {
    static let networkError = "ネットワークエラーが発生しました"
    static let maintenanceMode = "メンテナンス中です"
    static let versionUpdateRequired = "アプリの更新が必要です"
    static let gameLoadError = "ゲームの読み込みに失敗しました"
    static let connectionTimeout = "接続がタイムアウトしました"
    static let unexpectedError = "予期しないエラーが発生しました"
    static let retryLater = "しばらく時間をおいて再試行してください"
    static let checkConnection = "インターネット接続を確認してください"
}

// MARK: - 確認メッセージ
struct ConfirmationStrings {
    static let exitGame = "ゲームを終了しますか？"
    static let resetProgress = "進行状況をリセットしますか？"
    static let deleteData = "データを削除しますか？"
    static let confirmAction = "この操作を実行しますか？"
    static let unsavedChanges = "保存されていない変更があります"
    static let continueWithoutSaving = "保存せずに続行しますか？"
}

// MARK: - ボタンテキスト
struct ButtonStrings {
    static let start = "スタート"
    static let pause = "一時停止"
    static let resume = "再開"
    static let restart = "リスタート"
    static let quit = "終了"
    static let save = "保存"
    static let load = "読み込み"
    static let settings = "設定"
    static let help = "ヘルプ"
    static let about = "概要"
}