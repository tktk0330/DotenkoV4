//
//  GameModeSelectionView.swift
//  DotenkoV4
//
//  ゲームモード選択コンポーネント（vs CPU, vs Online）
//

import SwiftUI

// GameMode model definition
struct GameMode {
    let title: String
    let subtitle: String
    let iconName: String
    let iconColor: Color
    let action: () -> Void
}

struct GameModeSelectionView: View {
    let gameModes: [GameMode]
    @Binding var selectedPlayerCount: Int
    @EnvironmentObject private var navigationManager: NavigationStateManager
    @State private var selectedGameMode: String = ""
    
    init(selectedPlayerCount: Binding<Int>, gameModes: [GameMode]? = nil) {
        self._selectedPlayerCount = selectedPlayerCount
        
        if let customGameModes = gameModes {
            self.gameModes = customGameModes
        } else {
            self.gameModes = [
                GameMode(title: "vs CPU", subtitle: "コンピューターと対戦", iconName: "desktopcomputer", iconColor: .blue) {
                    // アクションは後でセットアップ
                },
                GameMode(title: "vs Online", subtitle: "友人とオンライン対戦", iconName: "wifi", iconColor: .green) {
                    print("オンライン対戦は Phase 2 で実装予定")
                }
            ]
        }
    }
    
    // MARK: - アクション
    private func showVsCPUMatching() {
        selectedGameMode = "vs CPU"
        let matchingInfo = createMatchingInfo()
        navigationManager.push(MatchingView(matchingInfo: matchingInfo))
    }
    
    private func showVsOnlineNotice() {
        print("オンライン対戦は Phase 2 で実装予定")
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(gameModes.indices, id: \.self) { index in
                let mode = gameModes[index]
                gameModeButton(
                    title: mode.title,
                    subtitle: mode.subtitle,
                    iconName: mode.iconName,
                    iconColor: mode.iconColor,
                    action: {
                        if mode.title == "vs CPU" {
                            showVsCPUMatching()
                        } else {
                            mode.action()
                        }
                    }
                )
            }
        }
    }
    
    // MARK: - ヘルパーメソッド
    private func createMatchingInfo() -> MatchingInfo {
        return MatchingInfo.defaultInfo(
            gameMode: selectedGameMode,
            playerCount: selectedPlayerCount
        )
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
                iconView(iconName: iconName, iconColor: iconColor)
                
                // テキスト
                textSection(title: title, subtitle: subtitle, iconColor: iconColor)
                
                Spacer()
                
                // 矢印
                arrowIcon
            }
            .padding(20)
            .cardBackground(
                cornerRadius: 18,
                borderColor: AnyShapeStyle(LinearGradient(
                    colors: [iconColor.opacity(0.8), iconColor.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - アイコンビュー
    private func iconView(iconName: String, iconColor: Color) -> some View {
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
    }
    
    // MARK: - テキストセクション
    private func textSection(title: String, subtitle: String, iconColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(AppFonts.gothicHeadline(24))
                .fontWeight(.bold)
                .foregroundColor(iconColor)
            
            Text(subtitle)
                .font(AppFonts.gothicBody(14))
                .foregroundColor(AppColors.cardWhite.opacity(0.9))
        }
    }
    
    // MARK: - 矢印アイコン
    private var arrowIcon: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(AppColors.cardWhite.opacity(0.7))
    }
    
}

#Preview {
    @Previewable @State var selectedPlayerCount = 3
    return GameModeSelectionView(selectedPlayerCount: $selectedPlayerCount)
        .background(AppGradients.primaryBackground)
        .padding()
}
