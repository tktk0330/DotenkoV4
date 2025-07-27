//
//  HomeTabBarView.swift
//  DotenkoV4
//
//  ホーム画面タブバーコンポーネント
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

// MARK: - タブバービュー
struct HomeTabBarView: View {
    @Binding var selectedTab: HomeTab
    
    var body: some View {
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
            // 既に選択されているタブの場合は何もしない
            guard selectedTab != tab else { return }
            
            // ハプティックフィードバック
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            // タブを変更（アニメーションなし）
            selectedTab = tab
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
                    
                    // アイコン
                    Image(systemName: tab.iconName)
                        .font(.system(size: tab == .home ? 17 : 15, weight: .medium))
                        .foregroundColor(selectedTab == tab ? .black : AppColors.brightYellow.opacity(0.9))
                        .scaleEffect(selectedTab == tab ? 1.05 : 1.0)
                }
                
                // ラベル
                Text(tab.rawValue)
                    .font(AppFonts.gothicCaption(8))
                    .fontWeight(.medium)
                    .foregroundColor(selectedTab == tab ? AppColors.brightYellow : AppColors.cardWhite.opacity(0.8))
                    .scaleEffect(selectedTab == tab ? 1.02 : 1.0)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    @State var selectedTab: HomeTab = .home
    return HomeTabBarView(selectedTab: $selectedTab)
        .background(AppGradients.primaryBackground)
        .padding()
}