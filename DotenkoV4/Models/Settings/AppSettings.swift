//
//  AppSettings.swift
//  DotenkoV4
//
//  アプリ設定を管理するクラス
//

import Foundation
import SwiftUI

/// アプリの設定を管理するシングルトンクラス
/// AppStorageを使用して設定値を永続化
class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    // MARK: - サウンド設定
    /// 効果音のON/OFF（デフォルト: ON）
    @AppStorage("soundEffectsEnabled") var soundEffectsEnabled: Bool = true
    
    /// BGMのON/OFF（デフォルト: ON）
    @AppStorage("backgroundMusicEnabled") var backgroundMusicEnabled: Bool = true
    
    /// バイブレーションのON/OFF（デフォルト: ON）
    @AppStorage("vibrationEnabled") var vibrationEnabled: Bool = true
    
    private init() {}
}