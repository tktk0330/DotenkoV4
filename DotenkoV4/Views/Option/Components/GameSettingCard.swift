//
//  GameSettingCard.swift
//  DotenkoV4
//
//  ゲーム設定カードコンポーネント
//

import SwiftUI

/// ゲーム設定項目を表示するカードコンポーネント
/// タップで設定変更モーダルを表示する
struct GameSettingCard: View {
    // MARK: - Properties
    let setting: GameSettingType
    let currentValue: Int
    let displayValue: String
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    // MARK: - Body
    var body: some View {
        Button(action: handleTap) {
            VStack(spacing: 16) {
                iconSection
                titleSection
                valueSection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(
                color: isPressed ? AppColors.brightYellow.opacity(0.4) : Color.black.opacity(0.3),
                radius: isPressed ? 12 : 8,
                x: 0,
                y: isPressed ? 6 : 4
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, perform: {}) { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }
    }
    
    // MARK: - Icon Section
    private var iconSection: some View {
        Image(systemName: setting.icon)
            .font(.system(size: 32, weight: .medium))
            .foregroundStyle(AppGradients.logoGradient)
            .frame(width: 60, height: 60)
            .background(iconBackground)
    }
    
    /// アイコンの背景グラデーション
    private var iconBackground: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        AppColors.brightYellow.opacity(0.2),
                        AppColors.brightYellow.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        Text(setting.rawValue)
            .font(AppFonts.gothicBody(16))
            .fontWeight(.medium)
            .foregroundColor(AppColors.cardWhite)
            .multilineTextAlignment(.center)
            .lineLimit(2)
    }
    
    // MARK: - Value Section
    private var valueSection: some View {
        Text(displayValue)
            .font(AppFonts.gothicHeadline(28))
            .fontWeight(.bold)
            .foregroundStyle(AppGradients.logoGradient)
            .minimumScaleFactor(0.7)
            .lineLimit(1)
    }
    
    // MARK: - Card Background
    private var cardBackground: some View {
        baseGradient
            .overlay(borderGradient)
            .overlay(overlayBorder)
    }
    
    /// カードのベースグラデーション
    private var baseGradient: some View {
        LinearGradient(
            colors: [
                Color.black.opacity(0.4),
                Color.black.opacity(0.2),
                Color.black.opacity(0.3)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// カードのボーダーグラデーション
    private var borderGradient: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(
                LinearGradient(
                    colors: [
                        AppColors.brightYellow.opacity(isPressed ? 0.6 : 0.3),
                        AppColors.vibrantOrange.opacity(isPressed ? 0.4 : 0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: isPressed ? 2 : 1
            )
    }
    
    /// カードのオーバーレイボーダー
    private var overlayBorder: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(
                Color.white.opacity(isPressed ? 0.3 : 0.1),
                lineWidth: 0.5
            )
            .blendMode(.overlay)
    }
    
    // MARK: - Actions
    /// カードタップ時の処理
    private func handleTap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        onTap()
    }
}

#Preview {
    VStack {
        GameSettingCard(
            setting: .rounds,
            currentValue: 10,
            displayValue: "10"
        ) {
            // Preview action
        }
    }
    .padding()
    .background(AppGradients.primaryBackground)
}