//
//  Constants.swift
//  DotenkoV4
//
//  アプリ全体で使用する定数を管理するクラス
//  画面サイズ、アニメーション時間、ゲーム設定などの定数を定義
//

import SwiftUI

// MARK: - アプリ基本設定
struct AppConstants {
    
    // MARK: - アプリ情報
    static let appName = "DotenkoV4"
    static let appVersion = "1.0.0"
    static let minimumIOSVersion = "15.0"
    
    // MARK: - 画面関連
    struct Screen {
        static let defaultPadding: CGFloat = 16.0           // デフォルトパディング
        static let largePadding: CGFloat = 24.0             // 大きなパディング
        static let smallPadding: CGFloat = 8.0              // 小さなパディング
        static let cornerRadius: CGFloat = 12.0             // デフォルト角丸
        static let largeCornerRadius: CGFloat = 20.0        // 大きな角丸
        static let borderWidth: CGFloat = 2.0               // デフォルト境界線幅
        static let shadowRadius: CGFloat = 10.0             // 影の半径
        static let bannerHeight: CGFloat = 50.0             // バナー広告高さ
    }
    
    // MARK: - アニメーション関連
    struct Animation {
        static let fastDuration: Double = 0.2               // 高速アニメーション
        static let normalDuration: Double = 0.3             // 通常アニメーション
        static let slowDuration: Double = 0.5               // 低速アニメーション
        static let splashDuration: Double = 2.0             // スプラッシュ表示時間
        static let countdownDuration: Double = 5.0          // カウントダウン時間
    }
    
    // MARK: - ゲーム関連
    struct Game {
        static let maxFileSize: Int = 400                   // 最大ファイル行数
        static let initialHandSize: Int = 2                 // 初期手札枚数
        static let jokerValues: [Int] = [-1, 0, 1]         // ジョーカーの値
        static let specialCardNumber: Int = 30              // ♦3の特殊値
        static let challengeZoneTimeout: Double = 15.0     // チャレンジゾーンタイムアウト
        static let rouletteSpinDuration: Double = 3.0      // ルーレット回転時間
    }
    
    // MARK: - レート設定
    struct Rate {
        static let availableRates: [Int] = [1, 2, 5, 10, 50, 100]
        static let defaultRate: Int = 10
        static let uprateMultiplier: Int = 2
        static let scoreUpperLimits: [Int] = [300, 500, 1000, 5000, 10000]
        static let cycleLimits: [Int] = [5, 10]
    }
    
    // MARK: - Firebase関連
    struct Firebase {
        static let timeoutInterval: TimeInterval = 10.0    // タイムアウト時間
        static let retryCount: Int = 3                     // リトライ回数
        static let maintenanceCheckInterval: TimeInterval = 300.0 // メンテナンス確認間隔（5分）
    }
    
    // MARK: - AdMob関連
    struct AdMob {
        static let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716" // テスト用ID
        static let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910" // テスト用ID
        static let rewardedAdUnitID = "ca-app-pub-3940256099942544/1712485313" // テスト用ID
    }
    
    // MARK: - 文字列リソース
    struct Strings {
        
        // MARK: - 共通
        static let ok = "OK"
        static let cancel = "キャンセル"
        static let close = "閉じる"
        static let retry = "再試行"
        static let loading = "読み込み中..."
        static let error = "エラー"
        static let success = "成功"
        
        // MARK: - スプラッシュ画面
        static let appTitle = "DOTENKO"
        static let loadingMessage = "ゲームを準備中..."
        
        // MARK: - トップ画面
        static let welcomeMessage = "カジノへようこそ"
        static let startGame = "ゲームスタート"
        
        // MARK: - ホーム画面
        static let homeTitle = "ホーム"
        static let playerName = "プレイヤー名"
        static let gameMode = "ゲームモード"
        static let vsCPU = "vs CPU"
        static let vsOnline = "vs オンライン"
        
        // MARK: - ゲーム設定画面
        static let gameSettingsTitle = "ゲーム設定"
        static let initialRate = "初期レート"
        static let scoreLimit = "スコア上限"
        static let deckCycle = "デッキサイクル"
        static let uprateSettings = "Uprate設定"
        
        // MARK: - ヘルプ画面
        static let helpTitle = "ヘルプ"
        static let appSettings = "アプリ設定"
        static let gameRules = "ゲームルール"
        static let termsOfService = "利用規約"
        static let contact = "お問い合わせ"
        static let soundEffect = "効果音"
        static let vibration = "バイブレーション"
        static let backgroundMusic = "BGM"
        
        // MARK: - ゲーム画面
        static let gameTitle = "DOTENKOゲーム"
        static let dotenko = "DOTENKO"
        static let shotenko = "しょてんこ"
        static let pass = "パス"
        static let drawCard = "カードを引く"
        static let challengeZone = "チャレンジゾーン"
        static let participate = "参加"
        static let decline = "辞退"
        
        // MARK: - エラーメッセージ
        static let networkError = "ネットワークエラーが発生しました"
        static let maintenanceMode = "メンテナンス中です"
        static let versionUpdateRequired = "アプリの更新が必要です"
        static let gameLoadError = "ゲームの読み込みに失敗しました"
    }
}

// MARK: - レイアウト用定数
struct LayoutConstants {
    
    // MARK: - ボタンサイズ
    struct Button {
        static let small = CGSize(width: 80, height: 40)
        static let medium = CGSize(width: 120, height: 50)
        static let large = CGSize(width: 200, height: 60)
        static let extraLarge = CGSize(width: 280, height: 70)
    }
    
    // MARK: - カードサイズ
    struct Card {
        static let width: CGFloat = 60.0
        static let height: CGFloat = 90.0
        static let cornerRadius: CGFloat = 8.0
        static let shadowOffset = CGSize(width: 2, height: 4)
    }
    
    // MARK: - アイコンサイズ
    struct Icon {
        static let small: CGFloat = 16.0
        static let medium: CGFloat = 24.0
        static let large: CGFloat = 32.0
        static let extraLarge: CGFloat = 48.0
    }
    
    // MARK: - スペーシング
    struct Spacing {
        static let tiny: CGFloat = 4.0
        static let small: CGFloat = 8.0
        static let medium: CGFloat = 16.0
        static let large: CGFloat = 24.0
        static let extraLarge: CGFloat = 32.0
    }
}

// MARK: - デバイス情報
extension UIDevice {
    
    /// iPhone かどうかを判定
    static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    /// iPad かどうかを判定
    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// 画面サイズが小さいかどうかを判定
    static var isSmallScreen: Bool {
        guard isPhone else { return false }
        return UIScreen.main.bounds.height < 667 // iPhone SE サイズ以下
    }
}