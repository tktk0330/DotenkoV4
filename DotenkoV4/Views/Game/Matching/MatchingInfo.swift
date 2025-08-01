//
//  MatchingInfo.swift
//  DotenkoV4
//
//  マッチング情報データモデル
//  - ゲームモード、プレイヤー数など設定情報を管理
//

import Foundation

// MARK: - マッチング情報
/// マッチング画面で表示する情報
struct MatchingInfo {
    let gameMode: String              // ゲームモード（vs CPU等）
    let playerCount: Int              // プレイヤー数
    let rounds: Int                   // ラウンド数
    let jokerCount: Int               // ジョーカー枚数
    let gameRate: Int                 // ゲームレート
}

// MARK: - MatchingInfo拡張
extension MatchingInfo {
    /// デフォルトのマッチング情報を作成
    static func defaultInfo(gameMode: String, playerCount: Int) -> MatchingInfo {
        return MatchingInfo(
            gameMode: gameMode,
            playerCount: playerCount,
            rounds: 10,              // デフォルト値
            jokerCount: 2,           // デフォルト値
            gameRate: 10             // デフォルト値
        )
    }
    
    /// vs CPUモード判定
    var isVsCPUMode: Bool {
        return gameMode == "vs CPU"
    }
}