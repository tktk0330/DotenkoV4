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

// MARK: - タブ定義
enum HomeTab: String, CaseIterable {
    case help = "HELP"
    case home = "HOME"
    case option = "OPTION"
    
    var iconName: String {
        switch self {
        case .help: return "questionmark.circle"
        case .home: return "suit.spade.fill"
        case .option: return "gearshape"
        }
    }
}

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
                    luxuryTabBarView
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
            
            // プロフィールアイコン
            profileIconView
            
            // プレイヤー名
            playerNameView
            
            // プレイヤー数選択
            playerCountSelectionView
            
            // ゲームモード選択
            gameModeSelectionView
            
            // 下部スペース
            Spacer()
                .frame(height: 20)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    // MARK: - プロフィールアイコン
    private var profileIconView: some View {
        ZStack {
            // 外側のグロー効果
            RoundedRectangle(cornerRadius: 18)
                .fill(AppColors.brightYellow.opacity(0.2))
                .frame(width: 110, height: 110)
                .blur(radius: 6)
            
            // メインフレーム
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.6),
                            Color.black.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 96, height: 96)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.brightYellow, AppColors.vibrantOrange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
            
            // アイコン
            Image(systemName: "person.fill")
                .font(.system(size: 40, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.cardWhite, AppColors.cardWhite.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .scaleEffect(isAnimating ? 1.0 : 0.8)
        .opacity(isAnimating ? 1.0 : 0.0)
    }
    
    // MARK: - プレイヤー名
    private var playerNameView: some View {
        HStack(spacing: 8) {
            Text("iphone16pro")
                .font(.custom("Impact", size: 24))
                .fontWeight(.bold)
                .foregroundColor(AppColors.cardWhite)
            
            Circle()
                .fill(AppColors.brightYellow)
                .frame(width: 18, height: 18)
                .overlay(
                    Image(systemName: "pencil")
                        .font(.system(size: 9))
                        .foregroundColor(.black)
                )
        }
        .opacity(isAnimating ? 1.0 : 0.0)
    }
    
    // MARK: - プレイヤー数選択
    private var playerCountSelectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "person.3.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(AppGradients.logoGradient)
                
                Text("プレイヤー数")
                    .font(AppFonts.elegantHeadline(18))
                    .foregroundStyle(AppGradients.logoGradient)
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                ForEach(2...5, id: \.self) { count in
                    playerCountButton(count: count)
                }
            }
        }
        .padding(20)
        .background(
            ZStack {
                // 背景グラデーション
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.6),
                                Color.black.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // 境界線グラデーション
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppGradients.logoGradient, lineWidth: 1.5)
                
                // 微かなグロー効果
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.brightYellow.opacity(0.2), lineWidth: 3)
                    .blur(radius: 3)
            }
        )
        .scaleEffect(isAnimating ? 1.0 : 0.9)
        .opacity(isAnimating ? 1.0 : 0.0)
    }
    
    // MARK: - プレイヤー数ボタン
    private func playerCountButton(count: Int) -> some View {
        Button(action: {
            withAnimation(.interpolatingSpring(stiffness: 400, damping: 12)) {
                selectedPlayerCount = count
            }
            // ハプティックフィードバック
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }) {
            Text("\(count)")
                .font(AppFonts.elegantHeadline(22))
                .fontWeight(.bold)
                .foregroundColor(selectedPlayerCount == count ? .black : AppColors.cardWhite)
                .frame(width: 55, height: 55)
                .background(
                    ZStack {
                        if selectedPlayerCount == count {
                            // 選択時の背景
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppGradients.logoGradient)
                            
                            // グロー効果
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.brightYellow, lineWidth: 2)
                                .blur(radius: 4)
                        } else {
                            // 未選択時の背景
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.cardWhite.opacity(0.4), lineWidth: 1)
                                )
                        }
                    }
                )
                .scaleEffect(selectedPlayerCount == count ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - ゲームモード選択
    private var gameModeSelectionView: some View {
        VStack(spacing: 16) {
            // vs CPU
            gameModeButton(
                title: "vs CPU",
                subtitle: "コンピューターと対戦",
                iconName: "desktopcomputer",
                iconColor: .blue,
                action: {
                    // CPU対戦画面に遷移
                    print("CPU対戦を選択")
                }
            )
            
            // vs Online
            gameModeButton(
                title: "vs Online",
                subtitle: "友人とオンライン対戦",
                iconName: "wifi",
                iconColor: .green,
                action: {
                    // オンライン対戦画面に遷移
                    print("オンライン対戦を選択")
                }
            )
        }
        .scaleEffect(isAnimating ? 1.0 : 0.9)
        .opacity(isAnimating ? 1.0 : 0.0)
    }
    
    // MARK: - ゲームモードボタン
    private func gameModeButton(title: String, subtitle: String, iconName: String, iconColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: {
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 10)) {
                action()
            }
            // ハプティックフィードバック
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }) {
            HStack(spacing: 20) {
                // アイコン
                ZStack {
                    // グロー効果
                    Circle()
                        .fill(iconColor.opacity(0.3))
                        .frame(width: 70, height: 70)
                        .blur(radius: 8)
                    
                    // メインアイコン
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [iconColor, iconColor.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: iconName)
                                .font(.system(size: 26, weight: .medium))
                                .foregroundColor(.white)
                        )
                        .shadow(color: iconColor.opacity(0.5), radius: 8, x: 0, y: 4)
                }
                
                // テキスト
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(AppFonts.elegantHeadline(24))
                        .fontWeight(.bold)
                        .foregroundColor(iconColor)
                    
                    Text(subtitle)
                        .font(AppFonts.elegantBody(14))
                        .foregroundColor(AppColors.cardWhite.opacity(0.9))
                }
                
                Spacer()
                
                // 矢印
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.cardWhite.opacity(0.7))
            }
            .padding(20)
            .background(
                ZStack {
                    // 背景グラデーション
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.6),
                                    Color.black.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // 境界線グラデーション
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            LinearGradient(
                                colors: [iconColor.opacity(0.8), iconColor.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                    
                    // 微かなグロー効果
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(iconColor.opacity(0.2), lineWidth: 4)
                        .blur(radius: 4)
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - カジノ風タブバー
    private var luxuryTabBarView: some View {
        HStack(spacing: 12) {
            ForEach(HomeTab.allCases, id: \.self) { tab in
                luxuryTabButton(tab: tab)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(tabBarBackground)
    }
    
    // MARK: - タブバー背景
    private var tabBarBackground: some View {
        ZStack {
            // 浮いている感じの背景
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.7),
                            Color.black.opacity(0.5)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .shadow(color: Color.black.opacity(0.6), radius: 12, x: 0, y: 4)
    }
    
    
    
    // MARK: - 高級タブバーボタン
    private func luxuryTabButton(tab: HomeTab) -> some View {
        Button(action: {
            // ハプティックフィードバック
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            // 直接タブを変更
            withAnimation(.interpolatingSpring(stiffness: 200, damping: 8)) {
                selectedTab = tab
            }
            
            // タブ選択時の処理
            handleTabSelection(tab)
        }) {
            VStack(spacing: 2) {
                ZStack {
                    // アイコン背景
                    Circle()
                        .fill(selectedTab == tab ? AnyShapeStyle(AppGradients.logoGradient) : AnyShapeStyle(Color.clear))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Circle()
                                .stroke(
                                    selectedTab == tab ? Color.clear : AppColors.brightYellow.opacity(0.5),
                                    lineWidth: 1
                                )
                        )
                        .scaleEffect(selectedTab == tab ? 1.05 : 1.0)
                        .animation(.interpolatingSpring(stiffness: 300, damping: 8), value: selectedTab)
                    
                    // アイコン
                    Image(systemName: tab.iconName)
                        .font(.system(size: tab == .home ? 17 : 15, weight: .medium))
                        .foregroundColor(selectedTab == tab ? .black : AppColors.brightYellow.opacity(0.9))
                        .scaleEffect(selectedTab == tab ? 1.05 : 1.0)
                        .animation(.interpolatingSpring(stiffness: 400, damping: 10), value: selectedTab)
                }
                
                // ラベル
                Text(tab.rawValue)
                    .font(AppFonts.elegantCaption(8))
                    .fontWeight(.medium)
                    .foregroundColor(selectedTab == tab ? AppColors.brightYellow : AppColors.cardWhite.opacity(0.8))
                    .scaleEffect(selectedTab == tab ? 1.02 : 1.0)
                    .animation(.interpolatingSpring(stiffness: 500, damping: 12), value: selectedTab)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
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