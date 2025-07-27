//
//  TopView.swift
//  DotenkoV4
//
//  トップ画面
//  参考画像に基づいたDOTENKOロゴと散らばったカード、STARTボタンを配置
//  深緑の単色背景にカジノ風のデザイン
//

import SwiftUI

// MARK: - トップ画面ビュー
struct TopView: View {
    
    // MARK: - プロパティ
    @EnvironmentObject private var navigationManager: NavigationStateManager // ナビゲーション管理
    @State private var logoScale: CGFloat = 0.001                       // ロゴのスケールアニメーション（極小から開始）
    @State private var logoOpacity: Double = 0.0                        // ロゴの透明度
    @State private var logoRotation: Double = -1440.0                   // ロゴの回転（4回転）
    @State private var buttonOpacity: Double = 0.0                      // ボタンの透明度アニメーション
    @State private var isButtonPressed: Bool = false                    // ボタン押下状態
    @State private var cardsOffset: [CGSize] = []                       // カードのオフセット位置
    @State private var cardsRotation: [Double] = []                     // カードの回転角度
    @State private var tornadoRotation: Double = 0.0                    // 竜巻全体の回転角度
    @State private var cardAnimationOffset: [Double] = []               // カード個別のアニメーション角度
    
    // カードデータ（Assetのカード名）
    private let cardAssets = ["c01", "h07", "s04", "d05", "c13", "h12", "s11", "d02", "h01", "c03", "s08", "d09"]
    
    // MARK: - ボディ
    var body: some View {
        ZStack {
            // 背景
            backgroundView
            
            // 散らばったカード
            cardBackgroundView
            
            // メインコンテンツ
            mainContentView
        }
        .ignoresSafeArea()
        .onAppear {
            setupCards()
            startTopViewAnimations()
        }
    }
    
    // MARK: - 背景ビュー
    private var backgroundView: some View {
        AppGradients.primaryBackground
            .ignoresSafeArea()
    }
    
    // MARK: - カード背景ビュー
    private var cardBackgroundView: some View {
        ZStack {
            ForEach(0..<cardAssets.count, id: \.self) { index in
                AssetPlayingCardView(cardName: cardAssets[index])
                    .offset(cardsOffset.indices.contains(index) ? cardsOffset[index] : .zero)
                    .rotationEffect(.degrees(cardsRotation.indices.contains(index) ? cardsRotation[index] + cardAnimationOffset[index] : 0))
                    .opacity(0.85)
            }
        }
        .rotationEffect(.degrees(tornadoRotation))
    }
    
    // MARK: - メインコンテンツビュー
    private var mainContentView: some View {
        VStack(spacing: 80) {
            
            Spacer()
            
            // DOTENKOロゴ
            dotenkoLogoView
            
            Spacer()
            
            // STARTボタン
            startButtonView
            
            Spacer()
                .frame(height: AppConstants.Screen.bannerHeight + AppConstants.Screen.defaultPadding)
        }
        .padding(AppConstants.Screen.defaultPadding)
    }
    
    // MARK: - DOTENKOロゴビュー
    private var dotenkoLogoView: some View {
        Text("DOTENKO")
            .font(.custom("Impact", size: 80))
            .fontWeight(.heavy)
            .foregroundStyle(AppGradients.logoGradient)
            .shadow(color: AppColors.shadowColor, radius: 8, x: 3, y: 3)
            .scaleEffect(logoScale)
            .rotationEffect(.degrees(logoRotation))
            .opacity(logoOpacity)
    }
    
    // MARK: - スタートボタンビュー
    private var startButtonView: some View {
        Button(action: {
            handleStartButtonTap()
        }) {
            ZStack {
                // ボタン境界線（グラデーション）
                RoundedRectangle(cornerRadius: 28)
                    .stroke(AppGradients.buttonBorderGradient, lineWidth: 3)
                    .frame(width: 240, height: 56)
                    .shadow(color: AppColors.glowColor, radius: 8)
                
                // ボタン背景（透明）
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.clear)
                    .frame(width: 240, height: 56)
                
                // ボタンテキスト
                Text("START")
                    .font(.custom("Impact", size: 32))
                    .fontWeight(.bold)
                    .foregroundStyle(AppGradients.startButtonText)
                    .shadow(color: AppColors.shadowColor, radius: 4, x: 2, y: 2)
                    .overlay(
                        Text("START")
                            .font(.custom("Impact", size: 32))
                            .fontWeight(.bold)
                            .foregroundStyle(AppColors.glowColor)
                            .blur(radius: 2)
                            .opacity(0.3)
                    )
            }
            .scaleEffect(isButtonPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .opacity(buttonOpacity)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(AppAnimations.buttonPress) {
                isButtonPressed = pressing
            }
        }, perform: {})
    }
    
    // MARK: - カード設定
    private func setupCards() {
        cardsOffset = []
        cardsRotation = []
        cardAnimationOffset = []
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // 各カードの位置を竜巻状に配置
        for i in 0..<cardAssets.count {
            let angle = Double(i) * (360.0 / Double(cardAssets.count))
            let radius = CGFloat.random(in: 120...250)
            
            let x = cos(angle * .pi / 180) * radius
            let y = sin(angle * .pi / 180) * radius
            
            cardsOffset.append(CGSize(width: x, height: y))
            cardsRotation.append(Double.random(in: -45...45))
            cardAnimationOffset.append(Double(i) * 30) // 個別の開始角度
        }
    }
    
    // MARK: - アニメーション開始
    private func startTopViewAnimations() {
        // 派手な動きのアニメーション
        
        // フェーズ1: 極小から超巨大へ急拡大（0.4秒）
        withAnimation(.easeIn(duration: 0.4)) {
            logoScale = 8.0  // 8倍まで拡大！
            logoOpacity = 1.0
            logoRotation = 1080.0  // 3回転
        }
        
        // フェーズ2: 跳ね返り（0.4秒後）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.interpolatingSpring(stiffness: 50, damping: 4)) {
                logoScale = 0.5  // 半分まで縮小
                logoRotation = -180.0  // 逆回転
            }
        }
        
        // フェーズ3: 最終位置へ（0.8秒後）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.interpolatingSpring(stiffness: 150, damping: 8)) {
                logoScale = 1.0
                logoRotation = 0.0
            }
        }
        
        // フェーズ4: 追加のバウンス（1.2秒後）
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 10)) {
                logoScale = 1.3
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.interpolatingSpring(stiffness: 400, damping: 12)) {
                    logoScale = 1.0
                }
            }
        }
        
        // ボタン表示アニメーション（ロゴ登場後）
        withAnimation(.easeOut(duration: 0.8).delay(1.5)) {
            buttonOpacity = 1.0
        }
        
        // 竜巻アニメーション開始
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            startTornadoAnimation()
        }
    }
    
    // MARK: - 竜巻アニメーション
    private func startTornadoAnimation() {
        // 全体の竜巻回転
        withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: false)) {
            tornadoRotation = 360.0
        }
        
        // 各カードの個別回転
        for i in 0..<cardAssets.count {
            let delay = Double(i) * 0.1
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
                    cardAnimationOffset[i] += 360.0
                }
            }
        }
    }
    
    // MARK: - スタートボタンタップ処理
    private func handleStartButtonTap() {
        // ハプティックフィードバック
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
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
        
        // ホーム画面に遷移
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            navigationManager.push(HomeView())
        }
    }
}

// MARK: - Assetプレイングカードビュー
struct AssetPlayingCardView: View {
    let cardName: String
    
    var body: some View {
        Image(cardName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 45, height: 65)
            .shadow(color: AppGradients.cardShadow, radius: 4, x: 2, y: 2)
    }
}

// MARK: - プレビュー
#Preview {
    TopView()
        .environmentObject(NavigationStateManager())
}
