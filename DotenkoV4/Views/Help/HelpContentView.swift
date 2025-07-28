//
//  HelpContentView.swift
//  DotenkoV4
//
//  ヘルプタブのコンテンツ
//

import SwiftUI

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