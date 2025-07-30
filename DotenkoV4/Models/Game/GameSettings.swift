//
//  GameSettings.swift
//  DotenkoV4
//
//  ゲーム設定モデル
//

import Foundation
import SwiftUI

// MARK: - ゲーム設定モデル
/// ゲーム設定を管理するシングルトンクラス
/// AppStorageを使用して設定値を永続化
class GameSettings: ObservableObject {
    static let shared = GameSettings()
    
    // MARK: - 設定項目
    /// ゲームの総ラウンド数（デフォルト: 10）
    @AppStorage("gameRounds") var rounds: Int = 10
    
    /// デッキに含まれるジョーカーの枚数（デフォルト: 2）
    @AppStorage("jokerCount") var jokerCount: Int = 2
    
    /// 1ポイントあたりのレート（デフォルト: 10）
    @AppStorage("gameRate") var gameRate: Int = 10
    
    /// 1ラウンドで獲得可能な最大スコア（デフォルト: 無限）
    @AppStorage("scoreLimit") var scoreLimit: Int = .max
    
    /// 同じカードを重ねた時のレート倍率（デフォルト: なし）
    @AppStorage("stackRateUp") var stackRateUp: Int = 0
    
    /// デッキが何周したらゲーム終了（デフォルト: 無限）
    @AppStorage("deckCycle") var deckCycle: Int = .max
    
    private init() {}
    
    // MARK: - 選択可能なオプション定義
    /// ラウンド数の選択肢
    static let roundsOptions = [1, 2, 3, 5, 10, 20]
    
    /// ジョーカー枚数の選択肢
    static let jokerCountOptions = [0, 1, 2, 3, 4]
    
    /// ゲームレートの選択肢
    static let gameRateOptions = [1, 5, 10, 50, 100]
    
    /// スコア上限の選択肢（Int.maxは無限を表す）
    static let scoreLimitOptions = [Int.max, 1000, 3000, 5000, 100000]
    
    /// 重ねレートアップの選択肢（0はなしを表す）
    static let stackRateUpOptions = [0, 3, 4]
    
    /// デッキサイクルの選択肢（Int.maxは無限を表す）
    static let deckCycleOptions = [Int.max, 1, 2, 3, 4, 5, 10]
    
    // MARK: - 表示用文字列変換
    /// 設定値を表示用の文字列に変換
    /// - Parameters:
    ///   - setting: 設定タイプ
    ///   - value: 設定値
    /// - Returns: 表示用文字列
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
    /// 指定した設定タイプの現在値を取得
    /// - Parameter setting: 設定タイプ
    /// - Returns: 現在の設定値
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
    /// 指定した設定タイプの値を更新
    /// - Parameters:
    ///   - setting: 設定タイプ
    ///   - value: 新しい設定値
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
    /// 指定した設定タイプの選択可能な値の配列を取得
    /// - Parameter setting: 設定タイプ
    /// - Returns: 選択可能な値の配列
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
/// ゲーム設定のタイプを定義する列挙型
enum GameSettingType: String, CaseIterable, Identifiable {
    case rounds = "ラウンド数"
    case jokerCount = "ジョーカー枚数"
    case gameRate = "ゲームレート"
    case scoreLimit = "スコア上限"
    case stackRateUp = "重ねレートアップ"
    case deckCycle = "デッキサイクル"
    
    var id: String { rawValue }
    
    /// 各設定タイプにSF Symbolsアイコンを返す
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
    
    /// 各設定タイプの説明文を返す
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