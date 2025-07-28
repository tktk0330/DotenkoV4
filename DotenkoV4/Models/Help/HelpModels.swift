//
//  HelpModels.swift
//  DotenkoV4
//
//  Help画面で使用するデータモデル
//

import Foundation

// MARK: - Help画面のセクションデータ
enum HelpSection: String, CaseIterable, Identifiable {
    case settings = "設定"
    case rules = "ルール説明"
    case howToPlay = "操作方法"
    case faq = "よくある質問"
    case support = "サポート"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .settings: return "gearshape.fill"
        case .rules: return "book.fill"
        case .howToPlay: return "gamecontroller.fill"
        case .faq: return "questionmark.circle.fill"
        case .support: return "envelope.fill"
        }
    }
    
    var items: [HelpItem] {
        switch self {
        case .settings:
            return [
                HelpItem(title: "サウンド設定", icon: "speaker.wave.2.fill", type: .soundSettings),
                HelpItem(title: "バイブレーション設定", icon: "iphone.radiowaves.left.and.right", type: .vibrationSettings),
                HelpItem(title: "通知設定", icon: "bell.fill", type: .notificationSettings)
            ]
        case .rules:
            return [
                HelpItem(title: "基本ルール", icon: "doc.text.fill", type: .basicRules),
                HelpItem(title: "詳細設定", icon: "slider.horizontal.3", type: .advancedSettings),
                HelpItem(title: "カードの強さ", icon: "suit.spade.fill", type: .cardStrength)
            ]
        case .howToPlay:
            return [
                HelpItem(title: "ゲームの始め方", icon: "play.circle.fill", type: .howToStart),
                HelpItem(title: "カードの出し方", icon: "hand.tap.fill", type: .howToPlayCards),
                HelpItem(title: "勝利条件", icon: "trophy.fill", type: .winConditions)
            ]
        case .faq:
            return [
                HelpItem(title: "よくある質問", icon: "bubble.left.and.bubble.right.fill", type: .faq),
                HelpItem(title: "トラブルシューティング", icon: "wrench.and.screwdriver.fill", type: .troubleshooting)
            ]
        case .support:
            return [
                HelpItem(title: "お問い合わせ", icon: "message.fill", type: .contact),
                HelpItem(title: "利用規約", icon: "doc.plaintext.fill", type: .terms),
                HelpItem(title: "プライバシーポリシー", icon: "lock.fill", type: .privacy)
            ]
        }
    }
}

// MARK: - Help項目データ
struct HelpItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let type: HelpItemType
}

// MARK: - Help項目タイプ
enum HelpItemType {
    // 設定
    case soundSettings
    case vibrationSettings
    case notificationSettings
    
    // ルール
    case basicRules
    case advancedSettings
    case cardStrength
    
    // 操作方法
    case howToStart
    case howToPlayCards
    case winConditions
    
    // FAQ
    case faq
    case troubleshooting
    
    // サポート
    case contact
    case terms
    case privacy
}