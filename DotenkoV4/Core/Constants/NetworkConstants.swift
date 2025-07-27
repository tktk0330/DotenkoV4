//
//  NetworkConstants.swift
//  DotenkoV4
//
//  ネットワーク関連の定数を管理
//  Firebase、AdMob、API設定などの定数を定義
//

import Foundation

// MARK: - Firebase関連定数
struct FirebaseConstants {
    
    // MARK: - 接続設定
    static let timeoutInterval: TimeInterval = 10.0      // タイムアウト時間
    static let retryCount: Int = 3                       // リトライ回数
    static let maintenanceCheckInterval: TimeInterval = 300.0  // メンテナンス確認間隔（5分）
    
    // MARK: - データベース設定
    static let maxDataSize: Int = 1024 * 1024           // 最大データサイズ（1MB）
    static let cacheTimeout: TimeInterval = 3600.0      // キャッシュタイムアウト（1時間）
    
    // MARK: - 認証設定
    static let sessionTimeout: TimeInterval = 86400.0   // セッションタイムアウト（24時間）
    static let tokenRefreshInterval: TimeInterval = 3600.0  // トークン更新間隔（1時間）
}

// MARK: - AdMob関連定数
struct AdMobConstants {
    
    // MARK: - 広告ユニットID（テスト用）
    static let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    static let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    static let rewardedAdUnitID = "ca-app-pub-3940256099942544/1712485313"
    
    // MARK: - 広告表示設定
    static let bannerRefreshInterval: TimeInterval = 30.0    // バナー更新間隔
    static let interstitialMinInterval: TimeInterval = 60.0  // インタースティシャル最小間隔
    static let rewardedCooldown: TimeInterval = 300.0        // リワード広告クールダウン
    
    // MARK: - 広告サイズ設定
    static let bannerHeight: CGFloat = 50.0              // バナー広告高さ
    static let smartBannerHeight: CGFloat = 90.0         // スマートバナー高さ
}

// MARK: - API関連定数
struct APIConstants {
    
    // MARK: - エンドポイント
    static let baseURL = "https://api.dotenko.com/v1"   // ベースURL
    static let gameEndpoint = "/game"                    // ゲームエンドポイント
    static let userEndpoint = "/user"                    // ユーザーエンドポイント
    static let leaderboardEndpoint = "/leaderboard"     // リーダーボードエンドポイント
    
    // MARK: - リクエスト設定
    static let requestTimeout: TimeInterval = 15.0      // リクエストタイムアウト
    static let maxRetryCount: Int = 3                    // 最大リトライ回数
    static let retryDelay: TimeInterval = 1.0            // リトライ遅延
    
    // MARK: - レスポンス設定
    static let maxResponseSize: Int = 5 * 1024 * 1024   // 最大レスポンスサイズ（5MB）
    static let cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
}

// MARK: - ネットワーク状態管理
struct NetworkConstants {
    
    // MARK: - 接続確認設定
    static let connectivityCheckInterval: TimeInterval = 5.0    // 接続確認間隔
    static let connectivityTimeout: TimeInterval = 3.0         // 接続確認タイムアウト
    static let reachabilityHost = "www.google.com"             // 到達性確認ホスト
    
    // MARK: - エラーハンドリング
    static let maxNetworkErrors: Int = 5                       // 最大ネットワークエラー数
    static let errorResetInterval: TimeInterval = 300.0        // エラーリセット間隔
    
    // MARK: - データ同期
    static let syncInterval: TimeInterval = 30.0               // 同期間隔
    static let offlineDataLimit: Int = 1000                    // オフラインデータ制限
}