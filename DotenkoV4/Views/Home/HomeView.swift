//
//  HomeView.swift
//  DotenkoV4
//
//  ファイル概要:
//  ホーム画面（プレースホルダー）
//  将来的にタブバー構成のホーム画面を実装予定
//  ポップなカジノ風デザインで統一
//

import SwiftUI

// MARK: - ホーム画面ビュー
struct HomeView: View {
    
    // MARK: - プロパティ
    @EnvironmentObject private var navigationManager: NavigationStateManager // ナビゲーション管理
    @State private var iconScale: CGFloat = 0.8                              // アイコンスケール
    @State private var isButtonPressed: Bool = false                         // ボタン押下状態
    
    // MARK: - ボディ
    var body: some View {
        ZStack {
            // 背景
            backgroundView
            
            // メインコンテンツ
            mainContentView
        }
        .ignoresSafeArea()
        .onAppear {
            startHomeAnimations()
        }
    }
    
    // MARK: - 背景ビュー
    private var backgroundView: some View {
        AppGradients.primaryBackground
    }
    
    // MARK: - メインコンテンツビュー
    private var mainContentView: some View {
        VStack(spacing: ScreenConstants.largePadding * 1.5) {
            
            Spacer()
            
            // タイトルセクション
            titleSectionView
            
            // メインアイコンセクション
            iconSectionView
            
            // 説明テキスト
            descriptionView
            
            // 戻るボタン
            backButtonView
            
            Spacer()
        }
        .padding(ScreenConstants.defaultPadding)
    }
    
    // MARK: - タイトルセクション
    private var titleSectionView: some View {
        Text("HOME")
            .font(.custom("Impact", size: 48))
            .fontWeight(.heavy)
            .foregroundStyle(AppGradients.logoGradient)
            .shadow(color: AppColors.shadowColor, radius: 8, x: 3, y: 3)
    }
    
    // MARK: - アイコンセクション
    private var iconSectionView: some View {
        VStack(spacing: 40) {
            // カードアイコン
            HStack(spacing: 15) {
                ForEach(["s01", "h13", "d01", "c13"], id: \.self) { cardName in
                    Image(cardName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 85)
                        .shadow(color: AppGradients.cardShadow, radius: 4, x: 2, y: 2)
                        .rotationEffect(.degrees(Double.random(in: -10...10)))
                }
            }
            .scaleEffect(iconScale)
            
            // メッセージ
            Text("Coming Soon!")
                .font(.custom("Impact", size: 32))
                .fontWeight(.bold)
                .foregroundStyle(AppGradients.logoGradient)
                .shadow(color: AppColors.shadowColor, radius: 4, x: 2, y: 2)
        }
    }
    
    // MARK: - 説明テキスト
    private var descriptionView: some View {
        Text("タブバー構成のホーム画面実装予定")
            .font(.custom("Avenir Next", size: 20))
            .fontWeight(.medium)
            .foregroundColor(AppColors.cardWhite.opacity(0.8))
            .multilineTextAlignment(.center)
    }
    
    // MARK: - 戻るボタン
    private var backButtonView: some View {
        Group {
            if navigationManager.canGoBack {
                Button(action: {
                    handleBackButtonTap()
                }) {
                    ZStack {
                        // ボタン境界線（グラデーション）
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(AppGradients.buttonBorderGradient, lineWidth: 3)
                            .frame(width: 200, height: 56)
                            .shadow(color: AppColors.glowColor, radius: 8)
                        
                        // ボタン背景（透明）
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.clear)
                            .frame(width: 200, height: 56)
                        
                        // ボタンテキスト
                        Text("BACK")
                            .font(.custom("Impact", size: 28))
                            .fontWeight(.bold)
                            .foregroundStyle(AppGradients.startButtonText)
                            .shadow(color: AppColors.shadowColor, radius: 4, x: 2, y: 2)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                    withAnimation(AppAnimations.buttonPress) {
                        isButtonPressed = pressing
                    }
                }, perform: {})
            }
        }
    }
    
    // MARK: - アニメーション開始
    private func startHomeAnimations() {
        // アイコン拡大アニメーション
        withAnimation(.easeOut(duration: 0.8)) {
            iconScale = 1.0
        }
    }
    
    // MARK: - 戻るボタンタップ処理
    private func handleBackButtonTap() {
        // ハプティックフィードバック
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // ボタンアニメーション
        withAnimation(AppAnimations.buttonPress) {
            isButtonPressed = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(AppAnimations.buttonRelease) {
                isButtonPressed = false
            }
        }
        
        // 前の画面に戻る
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            navigationManager.pop()
        }
    }
}

// MARK: - プレビュー
#Preview {
    HomeView()
        .environmentObject(NavigationStateManager())
}