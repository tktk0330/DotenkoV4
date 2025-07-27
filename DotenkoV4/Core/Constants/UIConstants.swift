//
//  UIConstants.swift
//  DotenkoV4
//
//  画面、レイアウト、アニメーション関連の定数を管理
//

import SwiftUI

// MARK: - 画面関連定数
struct ScreenConstants {
    static let defaultPadding: CGFloat = 16.0           // デフォルトパディング
    static let largePadding: CGFloat = 24.0             // 大きなパディング
    static let smallPadding: CGFloat = 8.0              // 小さなパディング
    static let cornerRadius: CGFloat = 12.0             // デフォルト角丸
    static let largeCornerRadius: CGFloat = 20.0        // 大きな角丸
    static let borderWidth: CGFloat = 2.0               // デフォルト境界線幅
    static let shadowRadius: CGFloat = 10.0             // 影の半径
    static let bannerHeight: CGFloat = 50.0             // バナー広告高さ
}

// MARK: - アニメーション関連定数
struct AnimationConstants {
    static let fastDuration: Double = 0.2               // 高速アニメーション
    static let normalDuration: Double = 0.3             // 通常アニメーション
    static let slowDuration: Double = 0.5               // 低速アニメーション
    static let splashDuration: Double = 2.0             // スプラッシュ表示時間
    static let countdownDuration: Double = 5.0          // カウントダウン時間
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