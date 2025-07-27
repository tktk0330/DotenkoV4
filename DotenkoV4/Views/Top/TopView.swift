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
                .frame(height: ScreenConstants.bannerHeight + ScreenConstants.defaultPadding)
        }
        .padding(ScreenConstants.defaultPadding)
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
    
    // MARK: - アニメーションタイムライン構造
    private struct AnimationPhase {
        let delay: Double
        let duration: Double
        let animation: Animation
        let changes: () -> Void
        
        init(delay: Double, duration: Double, animation: Animation, changes: @escaping () -> Void) {
            self.delay = delay
            self.duration = duration
            self.animation = animation
            self.changes = changes
        }
    }
    
    // MARK: - アニメーション定数
    private struct TopViewAnimationTimings {
        static let logoExpansionDelay: Double = 0.0
        static let logoExpansionDuration: Double = 0.4
        static let logoBounceDelay: Double = 0.4
        static let logoBounceBackDuration: Double = 0.4
        static let tornadoStartDelay: Double = 0.5
        static let logoFinalPositionDelay: Double = 0.8
        static let logoFinalPositionDuration: Double = 0.4
        static let logoExtraBounceDelay: Double = 1.2
        static let logoExtraBounceDuration: Double = 0.2
        static let logoSettleDelay: Double = 1.4
        static let logoSettleDuration: Double = 0.2
        static let buttonShowDelay: Double = 1.5
        static let buttonShowDuration: Double = 0.8
    }
    
    // MARK: - アニメーション開始
    private func startTopViewAnimations() {
        // アニメーションタイムラインを定義
        let animationTimeline: [AnimationPhase] = [
            // フェーズ1: 極小から超巨大へ急拡大
            AnimationPhase(
                delay: TopViewAnimationTimings.logoExpansionDelay,
                duration: TopViewAnimationTimings.logoExpansionDuration,
                animation: .easeIn(duration: TopViewAnimationTimings.logoExpansionDuration)
            ) {
                logoScale = 8.0      // 8倍まで拡大！
                logoOpacity = 1.0
                logoRotation = 1080.0 // 3回転
            },
            
            // フェーズ2: 跳ね返り
            AnimationPhase(
                delay: TopViewAnimationTimings.logoBounceDelay,
                duration: TopViewAnimationTimings.logoBounceBackDuration,
                animation: .interpolatingSpring(stiffness: 50, damping: 4)
            ) {
                logoScale = 0.5       // 半分まで縮小
                logoRotation = -180.0 // 逆回転
            },
            
            // フェーズ3: 竜巻アニメーション開始
            AnimationPhase(
                delay: TopViewAnimationTimings.tornadoStartDelay,
                duration: 0.0,
                animation: .linear(duration: 0.0)
            ) {
                startTornadoAnimation()
            },
            
            // フェーズ4: 最終位置へ
            AnimationPhase(
                delay: TopViewAnimationTimings.logoFinalPositionDelay,
                duration: TopViewAnimationTimings.logoFinalPositionDuration,
                animation: .interpolatingSpring(stiffness: 150, damping: 8)
            ) {
                logoScale = 1.0
                logoRotation = 0.0
            },
            
            // フェーズ5: 追加のバウンス（拡大）
            AnimationPhase(
                delay: TopViewAnimationTimings.logoExtraBounceDelay,
                duration: TopViewAnimationTimings.logoExtraBounceDuration,
                animation: .interpolatingSpring(stiffness: 300, damping: 10)
            ) {
                logoScale = 1.3
            },
            
            // フェーズ6: 追加のバウンス（収束）
            AnimationPhase(
                delay: TopViewAnimationTimings.logoSettleDelay,
                duration: TopViewAnimationTimings.logoSettleDuration,
                animation: .interpolatingSpring(stiffness: 400, damping: 12)
            ) {
                logoScale = 1.0
            },
            
            // フェーズ7: ボタン表示
            AnimationPhase(
                delay: TopViewAnimationTimings.buttonShowDelay,
                duration: TopViewAnimationTimings.buttonShowDuration,
                animation: .easeOut(duration: TopViewAnimationTimings.buttonShowDuration)
            ) {
                buttonOpacity = 1.0
            }
        ]
        
        // タイムラインを実行
        executeAnimationTimeline(animationTimeline)
    }
    
    // MARK: - アニメーションタイムライン実行
    private func executeAnimationTimeline(_ timeline: [AnimationPhase]) {
        for phase in timeline {
            if phase.delay == 0.0 {
                // 即座に実行
                if phase.duration > 0.0 {
                    withAnimation(phase.animation) {
                        phase.changes()
                    }
                } else {
                    phase.changes()
                }
            } else {
                // 遅延実行
                DispatchQueue.main.asyncAfter(deadline: .now() + phase.delay) {
                    if phase.duration > 0.0 {
                        withAnimation(phase.animation) {
                            phase.changes()
                        }
                    } else {
                        phase.changes()
                    }
                }
            }
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
