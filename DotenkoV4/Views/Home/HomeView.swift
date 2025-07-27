//
//  HomeView.swift
//  DotenkoV4
//
//  ファイル概要:
//  ホーム画面（タブバー構造）
//  プレイヤー数選択、ゲームモード選択、タブバーナビゲーションを実装
//  参考画像に基づいたUIデザイン
//

import SwiftUI

// MARK: - ホーム画面ビュー
struct HomeView: View {
    
    // MARK: - プロパティ
    @EnvironmentObject private var navigationManager: NavigationStateManager
    @State private var selectedTab: HomeTab = .home
    @State private var selectedPlayerCount: Int = 3
    @State private var isAnimating: Bool = false
    
    // MARK: - ボディ
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景グラデーション
                backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // メインコンテンツエリア
                    ScrollView(.vertical, showsIndicators: false) {
                        mainContentArea
                            .frame(minHeight: geometry.size.height - ScreenConstants.bannerHeight - 100)
                    }
                    
                    // 高級感のあるタブバー
                    HomeTabBarView(
                        selectedTab: $selectedTab,
                        onTabSelection: handleTabSelection
                    )
                    .padding(.bottom, ScreenConstants.bannerHeight + 8)
                }
            }
        }
        .onAppear {
            startAnimations()
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
    
    // MARK: - メインコンテンツエリア
    private var mainContentArea: some View {
        VStack(spacing: 24) {
            // 上部スペース
            Spacer()
                .frame(height: 20)
            
            // プロフィールセクション
            ProfileSectionView(isAnimating: $isAnimating)
            
            // プレイヤー数選択
            PlayerCountSelectionView(
                selectedPlayerCount: $selectedPlayerCount,
                isAnimating: $isAnimating
            )
            
            // ゲームモード選択
            GameModeSelectionView(isAnimating: $isAnimating)
            
            // 下部スペース
            Spacer()
                .frame(height: 20)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    // MARK: - アニメーション開始
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
            isAnimating = true
        }
    }
    
    // MARK: - タブ選択処理
    private func handleTabSelection(_ tab: HomeTab) {
        switch tab {
        case .help:
            print("ヘルプタブを選択")
            // HelpViewに遷移する処理を追加
        case .home:
            print("ホームタブを選択")
            // 既にホーム画面なので何もしない
        case .option:
            print("オプションタブを選択")
            // OptionViewに遷移する処理を追加
        }
    }
}

// MARK: - プレビュー
#Preview {
    HomeView()
        .environmentObject(NavigationStateManager())
}