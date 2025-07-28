//
//  GameSettings.swift
//  DotenkoV4
//
//  ゲーム設定モデル
//

import Foundation
import SwiftUI

// MARK: - ゲーム設定モデル
class GameSettings: ObservableObject {
    static let shared = GameSettings()
    
    // MARK: - 設定項目
    @AppStorage("gameRounds") var rounds: Int = 10
    @AppStorage("jokerCount") var jokerCount: Int = 2
    @AppStorage("gameRate") var gameRate: Int = 10
    @AppStorage("scoreLimit") var scoreLimit: Int = .max // .maxで無限を表現
    @AppStorage("stackRateUp") var stackRateUp: Int = 0 // 0でなしを表現
    @AppStorage("deckCycle") var deckCycle: Int = .max // .maxで無限を表現
    
    private init() {}
    
    // MARK: - 設定項目定義
    static let roundsOptions = [1, 2, 3, 5, 10, 20]
    static let jokerCountOptions = [0, 1, 2, 3, 4]
    static let gameRateOptions = [1, 5, 10, 50, 100]
    static let scoreLimitOptions = [Int.max, 1000, 3000, 5000, 100000] // Int.maxを無限として使用
    static let stackRateUpOptions = [0, 3, 4] // 0をなしとして使用
    static let deckCycleOptions = [Int.max, 1, 2, 3, 4, 5, 10] // Int.maxを無限として使用
    
    // MARK: - 表示用文字列変換
    func displayValue(for setting: GameSettingType, value: Int) -> String {
        switch setting {
        case .scoreLimit, .deckCycle:
            return value == Int.max ? "♾️" : "\(value)"
        case .stackRateUp:
            return value == 0 ? "なし" : "\(value)"
        default:
            return "\(value)"
        }
    }
    
    // MARK: - 現在の設定値取得
    func currentValue(for setting: GameSettingType) -> Int {
        switch setting {
        case .rounds: return rounds
        case .jokerCount: return jokerCount
        case .gameRate: return gameRate
        case .scoreLimit: return scoreLimit
        case .stackRateUp: return stackRateUp
        case .deckCycle: return deckCycle
        }
    }
    
    // MARK: - 設定値更新
    func updateValue(for setting: GameSettingType, value: Int) {
        switch setting {
        case .rounds: rounds = value
        case .jokerCount: jokerCount = value
        case .gameRate: gameRate = value
        case .scoreLimit: scoreLimit = value
        case .stackRateUp: stackRateUp = value
        case .deckCycle: deckCycle = value
        }
    }
    
    // MARK: - 選択可能な値の配列取得
    func availableOptions(for setting: GameSettingType) -> [Int] {
        switch setting {
        case .rounds: return Self.roundsOptions
        case .jokerCount: return Self.jokerCountOptions
        case .gameRate: return Self.gameRateOptions
        case .scoreLimit: return Self.scoreLimitOptions
        case .stackRateUp: return Self.stackRateUpOptions
        case .deckCycle: return Self.deckCycleOptions
        }
    }
}

// MARK: - ゲーム設定タイプ
enum GameSettingType: String, CaseIterable, Identifiable {
    case rounds = "ラウンド数"
    case jokerCount = "ジョーカー枚数"
    case gameRate = "ゲームレート"
    case scoreLimit = "スコア上限"
    case stackRateUp = "重ねレートアップ"
    case deckCycle = "デッキサイクル"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .rounds: return "chart.bar.fill"
        case .jokerCount: return "crown.fill"
        case .gameRate: return "dollarsign.circle.fill"
        case .scoreLimit: return "hand.raised.fill"
        case .stackRateUp: return "arrow.up.right.circle.fill"
        case .deckCycle: return "repeat.circle.fill"
        }
    }
    
    var description: String {
        switch self {
        case .rounds: return "ゲームの総ラウンド数"
        case .jokerCount: return "デッキに含まれるジョーカーの枚数"
        case .gameRate: return "1ポイントあたりのレート"
        case .scoreLimit: return "1ラウンドで獲得可能な最大スコア"
        case .stackRateUp: return "同じカードを重ねた時のレート倍率"
        case .deckCycle: return "デッキが何周したらゲーム終了"
        }
    }
}