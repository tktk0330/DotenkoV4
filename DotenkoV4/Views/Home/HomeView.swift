//
//  HomeView.swift
//  DotenkoV4
//
//  ファイル概要:
//  ホーム画面（タブバー構造）
//  タブ選択に応じてコンテンツを切り替え、タブバーは常に表示
//

import SwiftUI

// MARK: - ホーム画面ビュー
struct HomeView: View {
    
    // MARK: - プロパティ
    @EnvironmentObject private var navigationManager: NavigationStateManager
    @State private var selectedTab: HomeTab = .home
    
    // MARK: - ボディ
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景グラデーション
                backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 選択されたタブのコンテンツ
                    contentView
                        .frame(minHeight: geometry.size.height - ScreenConstants.bannerHeight - 100)
                    
                    // 高級感のあるタブバー
                    HomeTabBarView(selectedTab: $selectedTab)
                    .padding(.bottom, ScreenConstants.bannerHeight + 8)
                }
            }
        }
    }
    
    // MARK: - 背景グラデーション
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                AppColors.dotenkoGreen,
                AppColors.dotenkoGreen.opacity(0.8),
                Color.black.opacity(0.9)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - コンテンツビュー
    @ViewBuilder
    private var contentView: some View {
        switch selectedTab {
        case .home:
            HomeContentView()
                .id(HomeTab.home)
        case .help:
            HelpContentView()
                .id(HomeTab.help)
        case .option:
            OptionContentView()
                .id(HomeTab.option)
        }
    }
    
}

// MARK: - プレビュー
#Preview {
    HomeView()
        .environmentObject(NavigationStateManager())
}
