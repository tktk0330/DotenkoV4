//
//  SplashView.swift
//  DotenkoV4
//
//  スプラッシュ画面
//  アプリ起動時の最初の画面で、裏でFirebaseからメンテ情報や最低アプリバージョン、ユーザー情報などを取得
//  カジノ風デザインでアプリロゴとローディングアニメーションを表示
//

import SwiftUI

// MARK: - スプラッシュ画面ビュー
struct SplashView: View {
    
    // MARK: - プロパティ
    @EnvironmentObject private var navigationManager: NavigationStateManager // ナビゲーション管理
    @State private var isLoading: Bool = true                           // ローディング状態
    @State private var cardScale: CGFloat = 0.8                         // カードのスケールアニメーション
    @State private var cardOpacity: Double = 0.0                        // カードの透明度アニメーション
    @State private var loadingOpacity: Double = 0.0                     // ローディングテキストの透明度
    @State private var loadingProgress: Double = 0.0                    // ローディング進行度
    
    // MARK: - ボディ
    var body: some View {
        ZStack {
            // 背景グラデーション
            backgroundView
            
            // メインコンテンツ
            mainContentView
            
            // ローディング表示
            if isLoading {
                loadingView
            }
        }
        .ignoresSafeArea()
        .onAppear {
            startSplashSequence()
        }
    }
    
    // MARK: - 背景ビュー
    private var backgroundView: some View {
        AppGradients.primaryBackground
    }
    
    // MARK: - メインコンテンツビュー
    private var mainContentView: some View {
        VStack(spacing: ScreenConstants.largePadding) {
            
            Spacer()
            
            // カード裏面画像
            cardBackView
            
            Spacer()
            
            // ローディングプログレスバー
            progressBarView
            
            Spacer()
                .frame(height: ScreenConstants.bannerHeight + ScreenConstants.defaultPadding)
        }
        .padding(ScreenConstants.defaultPadding)
    }
    
    // MARK: - カード裏面ビュー
    private var cardBackView: some View {
        Image("back-1")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 280)
            .shadow(color: AppGradients.cardShadow, radius: 8, x: 4, y: 4)
            .scaleEffect(cardScale)
            .opacity(cardOpacity)
    }
    
    // MARK: - プログレスバービュー
    private var progressBarView: some View {
        // プログレスバー
        ZStack(alignment: .leading) {
            // 背景バー
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.cardWhite.opacity(0.3), lineWidth: 2)
                .frame(height: 8)
            
            // 進行バー
            RoundedRectangle(cornerRadius: 20)
                .fill(AppGradients.logoGradient)
                .frame(width: UIScreen.main.bounds.width * 0.7 * loadingProgress, height: 8)
        }
        .frame(width: UIScreen.main.bounds.width * 0.7)
        .opacity(loadingOpacity)
    }
    
    // MARK: - ローディングビュー
    private var loadingView: some View {
        Color.clear
    }
    
    // MARK: - アニメーション開始
    private func startSplashSequence() {
        // カードアニメーション
        withAnimation(.easeOut(duration: 1.0)) {
            cardScale = 1.0
            cardOpacity = 1.0
        }
        
        // ローディングテキスト表示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeIn(duration: 0.5)) {
                loadingOpacity = 1.0
            }
        }
        
        // プログレスバーアニメーション
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 1.5)) {
                loadingProgress = 1.0
            }
        }
        
        // Firebase初期化処理をシミュレート
        performInitialization()
    }
    
    // MARK: - 初期化処理
    private func performInitialization() {
        // 実際の実装では、ここでFirebaseからのデータ取得を行う
        // 現在はシミュレーション
        DispatchQueue.main.asyncAfter(deadline: .now() + AnimationConstants.splashDuration) {
            withAnimation(.easeOut(duration: 0.5)) {
                isLoading = false
            }
            
            // トップ画面に遷移
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                navigationManager.push(TopView())
            }
        }
    }
}

// MARK: - プレビュー
#Preview {
    SplashView()
        .environmentObject(NavigationStateManager())
}