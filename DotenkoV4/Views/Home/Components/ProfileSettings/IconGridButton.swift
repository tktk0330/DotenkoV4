//
//  IconGridButton.swift
//  DotenkoV4
//
//  アイコングリッドボタンコンポーネント
//

import SwiftUI

struct IconGridButton: View {
    let iconName: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                onTap()
            }
        } label: {
            ZStack {
                // 背景（アニメーション強化）
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected
                            ? LinearGradient(
                                colors: [
                                    AppColors.brightYellow.opacity(0.4),
                                    AppColors.vibrantOrange.opacity(0.3),
                                    Color.black.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [
                                    Color.black.opacity(0.5),
                                    Color.black.opacity(0.3),
                                    Color.black.opacity(0.4)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected
                                    ? LinearGradient(
                                        colors: [AppColors.brightYellow, AppColors.vibrantOrange, AppColors.brightYellow],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    : LinearGradient(
                                        colors: [AppColors.cardWhite.opacity(0.4), AppColors.cardWhite.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                lineWidth: isSelected ? 2.5 : 1
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                Color.white.opacity(isSelected ? 0.4 : 0.2),
                                lineWidth: 0.5
                            )
                            .blendMode(.overlay)
                    )
                    .shadow(
                        color: isSelected ? AppColors.brightYellow.opacity(0.5) : Color.black.opacity(0.3),
                        radius: isSelected ? 12 : 6,
                        x: 0,
                        y: isSelected ? 4 : 2
                    )
                
                // アイコン（シャドウ付き）
                Image(systemName: iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(
                        isSelected
                            ? LinearGradient(
                                colors: [AppColors.brightYellow, AppColors.vibrantOrange, AppColors.brightYellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [AppColors.cardWhite, AppColors.cardWhite.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                    )
                    .shadow(
                        color: isSelected ? Color.black.opacity(0.4) : Color.black.opacity(0.2),
                        radius: isSelected ? 3 : 1,
                        x: 0,
                        y: 1
                    )
            }
        }
        .scaleEffect(isSelected ? 1.08 : 1.0)
        .rotationEffect(.degrees(isSelected ? 2 : 0))
        .animation(.interpolatingSpring(stiffness: 400, damping: 12).delay(isSelected ? 0 : 0.1), value: isSelected)
    }
}

#Preview {
    HStack {
        IconGridButton(iconName: "person.fill", isSelected: true) { }
        IconGridButton(iconName: "star.fill", isSelected: false) { }
    }
    .background(AppGradients.primaryBackground)
}