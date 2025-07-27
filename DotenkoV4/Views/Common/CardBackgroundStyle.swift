//
//  CardBackgroundStyle.swift
//  DotenkoV4
//
//  共通のカード風背景スタイル
//

import SwiftUI

// MARK: - カード背景スタイル
struct CardBackgroundStyle: ViewModifier {
    let cornerRadius: CGFloat
    let borderColor: AnyShapeStyle
    
    init(cornerRadius: CGFloat = 16, borderColor: AnyShapeStyle = AnyShapeStyle(AppGradients.logoGradient)) {
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // 背景グラデーション
                    RoundedRectangle(cornerRadius: cornerRadius)
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
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: 1.5)
                    
                    // 微かなグロー効果
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(AppColors.brightYellow.opacity(0.2), lineWidth: 3)
                        .blur(radius: 3)
                }
            )
    }
}

// MARK: - View Extension
extension View {
    func cardBackground(cornerRadius: CGFloat = 16, borderColor: AnyShapeStyle = AnyShapeStyle(AppGradients.logoGradient)) -> some View {
        self.modifier(CardBackgroundStyle(cornerRadius: cornerRadius, borderColor: borderColor))
    }
}