//
//  MainContentView.swift
//  DotenkoV4
//
//  ファイル概要:
//  メインコンテンツビューとナビゲーション管理
//  新しいナビゲーションシステムを使用した画面表示制御
//

import SwiftUI

// MARK: - メインコンテンツビュー
struct MainContentView: View {
    
    // MARK: - プロパティ
    @StateObject private var navigationManager = NavigationStateManager() // 通常画面ナビゲーション
    @StateObject private var allViewManager = NavigationAllViewStateManager.shared // 全画面ナビゲーション
    
    // MARK: - ボディ
    var body: some View {
        ZStack {
            // メイン画面表示
            mainContentView
            
            // 全画面オーバーレイ
            if let fullScreenView = allViewManager.currentView {
                fullScreenView
                    .transition(.opacity)
            }
        }
        .onAppear {
            // 初期画面をスプラッシュ画面に設定
            if navigationManager.currentView == nil {
                navigationManager.push(SplashView())
            }
        }
    }
    
    // MARK: - メインコンテンツビュー
    private var mainContentView: some View {
        ZStack {
            // 背景
            AppGradients.primaryBackground
                .ignoresSafeArea()
            
            // 現在のビュー表示
            if let currentView = navigationManager.currentView {
                currentView
                    .environmentObject(navigationManager)
                    .environmentObject(allViewManager)
            } else {
                // フォールバック：スプラッシュ画面
                SplashView()
                    .environmentObject(navigationManager)
                    .environmentObject(allViewManager)
            }
            
            // バナー広告（通常画面のみ）
            if !isFullScreenMode {
                bannerAdView
            }
        }
    }
    
    // MARK: - バナー広告ビュー
    private var bannerAdView: some View {
        VStack {
            Spacer()
            
            ZStack {
                // バナー広告背景
                Rectangle()
                    .fill(AppColors.secondaryBackground)
                    .frame(height: AppConstants.Screen.bannerHeight)
                    .border(AppColors.borderColor, width: 1)
                
                // バナー広告プレースホルダー
                Text("AdMob Banner")
                    .font(AppFonts.elegantCaption(AppFonts.captionSize))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
    }
    
    // MARK: - フルスクリーン表示判定
    private var isFullScreenMode: Bool {
        // 全画面オーバーレイが表示されている場合はバナーを非表示
        return allViewManager.currentView != nil
    }
}

// MARK: - プレビュー
#Preview("MainContentView") {
    MainContentView()
}