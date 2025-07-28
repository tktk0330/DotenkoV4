//
//  HelpContentView.swift
//  DotenkoV4
//
//  ヘルプタブのコンテンツ
//

import SwiftUI

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

// MARK: - Help画面メインビュー
struct HelpContentView: View {
    @State private var expandedSections: Set<HelpSection> = [.settings]
    @State private var selectedItem: HelpItem?
    @State private var showingPopup = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // ヘッダー
                headerView
                
                // セクションリスト
                VStack(spacing: 12) {
                    ForEach(HelpSection.allCases) { section in
                        HelpSectionView(
                            section: section,
                            isExpanded: expandedSections.contains(section),
                            onToggle: { toggleSection(section) },
                            onItemTap: { item in
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                selectedItem = item
                                withAnimation(.easeOut(duration: 0.3)) {
                                    showingPopup = true
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
        }
        .overlay {
            if showingPopup, let item = selectedItem {
                ZStack {
                    // 背景オーバーレイ
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.3)) {
                                showingPopup = false
                            }
                        }
                    
                    // ポップアップ
                    HelpDetailPopupView(
                        item: item,
                        isPresented: $showingPopup
                    )
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .scale(scale: 0.8).combined(with: .opacity)
                    ))
                }
                .animation(.interpolatingSpring(stiffness: 300, damping: 25), value: showingPopup)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("HELP")
                .font(AppFonts.elegantHeadline(36))
                .fontWeight(.bold)
                .foregroundStyle(AppGradients.logoGradient)
            
            Text("ヘルプ & 設定")
                .font(AppFonts.gothicBody(14))
                .foregroundColor(AppColors.cardWhite.opacity(0.8))
        }
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
    
    private func toggleSection(_ section: HelpSection) {
        withAnimation(.easeInOut(duration: 0.3)) {
            if expandedSections.contains(section) {
                expandedSections.remove(section)
            } else {
                expandedSections.insert(section)
            }
        }
    }
}

#Preview {
    HelpContentView()
        .background(AppGradients.primaryBackground)
}