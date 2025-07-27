//
//  Appearance.swift
//  DotenkoV4
//
//  アプリ全体のカラーとイメージを管理するクラス
//  カジノ風デザインをテーマとした色彩設定
//

import SwiftUI
import UIKit

// MARK: - カラーパレット
struct AppColors {
    
    // MARK: - DOTENKOカジノ風カラー（参考画像ベース）
    static let dotenkoGreen = Color(red: 0.05, green: 0.25, blue: 0.15)   // DOTENKO深緑背景
    static let brightYellow = Color(red: 1.0, green: 0.85, blue: 0.0)     // 明るい黄色
    static let vibrantOrange = Color(red: 1.0, green: 0.5, blue: 0.0)     // 鮮やかなオレンジ
    static let hotRed = Color(red: 1.0, green: 0.2, blue: 0.0)           // 情熱的な赤
    static let cardWhite = Color(red: 0.95, green: 0.95, blue: 0.95)     // カード白
    static let cardBorder = Color(red: 0.7, green: 0.7, blue: 0.7)       // カード境界線
    static let heartRed = Color(red: 0.9, green: 0.1, blue: 0.1)         // ハートの赤
    static let spadeBlack = Color(red: 0.1, green: 0.1, blue: 0.1)       // スペードの黒
    
    // MARK: - DOTENKOグラデーション用カラー
    static let logoGradientStart = Color(red: 1.0, green: 0.85, blue: 0.0)   // ロゴ開始（明るい黄色）
    static let logoGradientMiddle = Color(red: 1.0, green: 0.5, blue: 0.0)   // ロゴ中間（オレンジ）
    static let logoGradientEnd = Color(red: 1.0, green: 0.2, blue: 0.0)      // ロゴ終了（赤）
    static let buttonBorderStart = Color(red: 1.0, green: 0.85, blue: 0.0)   // ボタン境界線開始
    static let buttonBorderEnd = Color(red: 1.0, green: 0.2, blue: 0.0)      // ボタン境界線終了
    static let backgroundGreen = Color(red: 0.05, green: 0.25, blue: 0.15)   // 背景緑
    
    // MARK: - UI要素カラー
    static let primaryBackground = dotenkoGreen                          // メイン背景色（DOTENKO深緑）
    static let secondaryBackground = Color(red: 0.03, green: 0.2, blue: 0.12) // セカンダリ背景色
    static let cardBackground = cardWhite                                // カード背景色
    static let overlayBackground = spadeBlack.opacity(0.8)              // オーバーレイ背景
    
    // MARK: - テキストカラー
    static let primaryText = cardWhite                                   // メインテキスト
    static let secondaryText = Color(red: 0.8, green: 0.9, blue: 0.85)  // サブテキスト
    static let accentText = brightYellow                                 // アクセントテキスト
    static let warningText = hotRed                                      // 警告テキスト
    static let successText = Color(red: 0.0, green: 0.8, blue: 0.4)     // 成功テキスト
    
    // MARK: - ボタンカラー
    static let primaryButton = brightYellow                             // プライマリボタン
    static let secondaryButton = vibrantOrange                          // セカンダリボタン
    static let accentButton = hotRed                                     // アクセントボタン
    static let dangerButton = hotRed                                     // 危険ボタン
    static let disabledButton = Color(red: 0.4, green: 0.4, blue: 0.4)  // 無効化ボタン
    
    // MARK: - その他UI要素
    static let borderColor = brightYellow                               // 境界線色
    static let shadowColor = spadeBlack.opacity(0.5)                   // 影色
    static let highlightColor = brightYellow.opacity(0.3)              // ハイライト色
    static let glowColor = vibrantOrange.opacity(0.6)                  // グロー効果色
}

// MARK: - グラデーション定義
struct AppGradients {
    
    // MARK: - 背景グラデーション
    static let primaryBackground = AppColors.dotenkoGreen // 参考画像のような単色背景
    
    // MARK: - DOTENKOロゴグラデーション
    static let logoGradient = LinearGradient(
        colors: [AppColors.logoGradientStart, AppColors.logoGradientMiddle, AppColors.logoGradientEnd],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // MARK: - ボタングラデーション
    static let buttonBorderGradient = LinearGradient(
        colors: [AppColors.buttonBorderStart, AppColors.buttonBorderEnd],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // MARK: - STARTボタングラデーション
    static let startButtonBackground = AppColors.dotenkoGreen // 透明背景
    
    static let startButtonText = LinearGradient(
        colors: [AppColors.logoGradientStart, AppColors.logoGradientMiddle, AppColors.logoGradientEnd],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // MARK: - カード関連グラデーション
    static let cardShadow = Color.black.opacity(0.3)
    
    static let cardGlow = LinearGradient(
        colors: [Color.white.opacity(0.8), Color.clear],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - カードグラデーション
    static let cardBackground = RadialGradient(
        colors: [AppColors.cardBackground, AppColors.primaryBackground],
        center: .center,
        startRadius: 50,
        endRadius: 150
    )
    
    // MARK: - グロー効果
    static let glowEffect = RadialGradient(
        colors: [AppColors.glowColor, Color.clear],
        center: .center,
        startRadius: 0,
        endRadius: 100
    )
}

// MARK: - イメージ管理
struct AppImages {
    
    // MARK: - アイコン・ロゴ
    static let appLogo = "app_logo"                    // アプリロゴ
    static let splashIcon = "splash_icon"              // スプラッシュアイコン
    static let casinoChip = "casino_chip"              // カジノチップ
    static let cardDeck = "card_deck"                  // カードデッキ
    
    // MARK: - 背景画像
    static let casinoBackground = "casino_background"   // カジノ背景
    static let feltTexture = "felt_texture"            // フェルト質感
    static let goldTexture = "gold_texture"            // ゴールド質感
    
    // MARK: - ボタンアイコン
    static let playIcon = "play_icon"                  // プレイアイコン
    static let settingsIcon = "settings_icon"         // 設定アイコン
    static let helpIcon = "help_icon"                  // ヘルプアイコン
    static let backIcon = "back_icon"                  // 戻るアイコン
    
    // MARK: - カードスート
    static let spadeIcon = "spade_icon"                // スペード
    static let heartIcon = "heart_icon"                // ハート
    static let diamondIcon = "diamond_icon"            // ダイヤ
    static let clubIcon = "club_icon"                  // クラブ
    static let jokerIcon = "joker_icon"                // ジョーカー
    
    // MARK: - エフェクト
    static let sparkleEffect = "sparkle_effect"        // キラキラエフェクト
    static let goldParticle = "gold_particle"          // ゴールドパーティクル
}

// MARK: - フォント設定
struct AppFonts {
    
    // MARK: - エレガントフォント
    static func elegantTitle(_ size: CGFloat) -> Font {
        if UIFont(name: "Didot", size: size) != nil {
            return .custom("Didot", size: size).weight(.bold)
        } else {
            return .system(size: size, weight: .bold, design: .serif)
        }
    }
    
    static func elegantHeadline(_ size: CGFloat) -> Font {
        if UIFont(name: "Didot", size: size) != nil {
            return .custom("Didot", size: size).weight(.semibold)
        } else {
            return .system(size: size, weight: .semibold, design: .serif)
        }
    }
    
    static func elegantBody(_ size: CGFloat) -> Font {
        if UIFont(name: "Avenir Next", size: size) != nil {
            return .custom("Avenir Next", size: size).weight(.medium)
        } else {
            return .system(size: size, weight: .medium, design: .default)
        }
    }
    
    static func elegantCaption(_ size: CGFloat) -> Font {
        if UIFont(name: "Avenir Next", size: size) != nil {
            return .custom("Avenir Next", size: size).weight(.regular)
        } else {
            return .system(size: size, weight: .regular, design: .default)
        }
    }
    
    // MARK: - サイズ定義
    static let titleSize: CGFloat = 32
    static let headlineSize: CGFloat = 24
    static let bodySize: CGFloat = 16
    static let captionSize: CGFloat = 12
}

// MARK: - アニメーション設定
struct AppAnimations {
    
    // MARK: - 基本アニメーション
    static let fastTransition = Animation.easeInOut(duration: 0.2)
    static let normalTransition = Animation.easeInOut(duration: 0.3)
    static let slowTransition = Animation.easeInOut(duration: 0.5)
    
    // MARK: - ポップなエフェクト
    static let popEffect = Animation.interpolatingSpring(stiffness: 400, damping: 8)
    static let bounceEffect = Animation.interpolatingSpring(stiffness: 300, damping: 10)
    static let elasticEffect = Animation.interpolatingSpring(stiffness: 200, damping: 5)
    
    // MARK: - 継続エフェクト
    static let pulseEffect = Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    static let glowEffect = Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
    static let rotationEffect = Animation.linear(duration: 3.0).repeatForever(autoreverses: false)
    static let floatEffect = Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true)
    
    // MARK: - インタラクションエフェクト
    static let buttonPress = Animation.easeInOut(duration: 0.1)
    static let buttonRelease = Animation.interpolatingSpring(stiffness: 500, damping: 15)
    static let cardFlip = Animation.easeInOut(duration: 0.6)
}