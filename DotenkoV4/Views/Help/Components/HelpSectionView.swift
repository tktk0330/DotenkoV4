//
//  HelpSectionView.swift
//  DotenkoV4
//
//  アコーディオン形式のHelpセクションビュー
//

import SwiftUI

struct HelpSectionView: View {
    let section: HelpSection
    let isExpanded: Bool
    let onToggle: () -> Void
    let onItemTap: (HelpItem) -> Void
    
    @State private var animationRotation: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // セクションヘッダー
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                onToggle()
            }) {
                HStack(spacing: 16) {
                    // アイコン
                    Image(systemName: section.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(AppGradients.logoGradient)
                        .frame(width: 30)
                    
                    // セクションタイトル
                    Text(section.rawValue)
                        .font(AppFonts.gothicHeadline(20))
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.cardWhite)
                    
                    Spacer()
                    
                    // 展開インジケーター
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.cardWhite.opacity(0.7))
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .background(backgroundGradient)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
            
            // 展開されたコンテンツ
            ZStack {
                if isExpanded {
                    VStack(spacing: 8) {
                        ForEach(section.items) { item in
                            HelpItemRow(item: item) {
                                onItemTap(item)
                            }
                        }
                    }
                    .padding(.top, 8)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
                    .zIndex(1)
                }
            }
            .clipped()
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color.black.opacity(0.3),
                Color.black.opacity(0.2),
                Color.black.opacity(0.25)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [
                            AppColors.cardWhite.opacity(0.2),
                            AppColors.cardWhite.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Help項目行ビュー
struct HelpItemRow: View {
    let item: HelpItem
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            onTap()
        }) {
            HStack(spacing: 14) {
                // アイコン
                Image(systemName: item.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.brightYellow)
                    .frame(width: 24)
                
                // タイトル
                Text(item.title)
                    .font(AppFonts.gothicBody(16))
                    .foregroundColor(AppColors.cardWhite)
                
                Spacer()
                
                // 矢印
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.brightYellow, AppColors.vibrantOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.25),
                                Color.black.opacity(0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isPressed ? 
                                AppColors.brightYellow.opacity(0.3) : 
                                AppColors.cardWhite.opacity(0.1), 
                                lineWidth: 1
                            )
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .shadow(
                color: isPressed ? AppColors.brightYellow.opacity(0.2) : Color.clear,
                radius: 8,
                x: 0,
                y: 2
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, perform: {}) { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }
    }
}

#Preview {
    VStack {
        HelpSectionView(
            section: .settings,
            isExpanded: true,
            onToggle: {},
            onItemTap: { _ in }
        )
    }
    .padding()
    .background(AppGradients.primaryBackground)
}