//
//  GameConstants.swift
//  DotenkoV4
//
//  ゲーム関連の定数を管理
//  ゲームルール、レート設定、スコア関連の定数を定義
//

import Foundation

// MARK: - ゲーム関連定数
struct GameConstants {
    
    // MARK: - 基本ゲーム設定
    static let maxFileSize: Int = 400                   // 最大ファイル行数
    static let initialHandSize: Int = 2                 // 初期手札枚数
    static let jokerValues: [Int] = [-1, 0, 1]         // ジョーカーの値
    static let specialCardNumber: Int = 30              // ♦3の特殊値
    static let challengeZoneTimeout: Double = 15.0     // チャレンジゾーンタイムアウト
    static let rouletteSpinDuration: Double = 3.0      // ルーレット回転時間
}

// MARK: - レート設定
struct RateConstants {
    static let availableRates: [Int] = [1, 2, 5, 10, 50, 100]  // 利用可能レート
    static let defaultRate: Int = 10                             // デフォルトレート
    static let uprateMultiplier: Int = 2                         // Uprate倍数
    static let scoreUpperLimits: [Int] = [300, 500, 1000, 5000, 10000]  // スコア上限
    static let cycleLimits: [Int] = [5, 10]                      // サイクル上限
}

// MARK: - カード関連定数
struct CardConstants {
    
    // MARK: - スート定数
    enum Suit: String, CaseIterable {
        case spade = "s"
        case heart = "h" 
        case diamond = "d"
        case club = "c"
    }
    
    // MARK: - カード値範囲
    static let minCardValue: Int = 1                    // 最小カード値（A）
    static let maxCardValue: Int = 13                   // 最大カード値（K）
    static let jokerValue: Int = 0                      // ジョーカー値
    
    // MARK: - デッキ構成
    static let standardDeckSize: Int = 52               // 標準デッキサイズ
    static let jokerCount: Int = 2                      // ジョーカー枚数
    static let fullDeckSize: Int = standardDeckSize + jokerCount  // フルデッキサイズ
}

// MARK: - ゲームフロー定数
struct GameFlowConstants {
    
    // MARK: - ターン制限
    static let maxTurnDuration: Double = 30.0          // 最大ターン時間
    static let warningTimeRemaining: Double = 10.0     // 警告表示時間
    static let quickActionTime: Double = 5.0           // クイックアクション時間
    
    // MARK: - スコア計算
    static let baseScore: Int = 100                     // 基本スコア
    static let bonusMultiplier: Double = 1.5           // ボーナス倍率
    static let penaltyDivisor: Double = 2.0            // ペナルティ除数
    
    // MARK: - ゲーム状態
    enum GameState: String {
        case waiting = "waiting"
        case playing = "playing"
        case paused = "paused"
        case finished = "finished"
        case error = "error"
    }
}