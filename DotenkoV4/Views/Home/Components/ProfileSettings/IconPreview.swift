//
//  IconPreview.swift
//  DotenkoV4
//
//  アイコンプレビューコンポーネント
//

import SwiftUI

struct IconPreview: View {
    let selectedIconName: String
    let selectedImage: UIImage?
    let isUsingCustomImage: Bool
    
    var body: some View {
        ZStack {
            
            // メインフレーム（グラデーション強化）
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.8),
                            Color.black.opacity(0.4),
                            Color.black.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 70, height: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.brightYellow, AppColors.vibrantOrange, AppColors.brightYellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2.5
                        )
                        .shadow(color: AppColors.brightYellow.opacity(0.6), radius: 4, x: 0, y: 0)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            Color.white.opacity(0.3),
                            lineWidth: 0.5
                        )
                        .blendMode(.overlay)
                )
            
            // 選択中のアイコン
            Group {
                if isUsingCustomImage, let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                } else if isUsingCustomImage {
                    // カスタム画像選択中だが、まだ読み込み中
                    ZStack {
                        Image(systemName: selectedIconName)
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [AppColors.cardWhite.opacity(0.5), AppColors.cardWhite.opacity(0.3)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        // 小さなローディングインジケーター
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ProgressView()
                                    .scaleEffect(0.6)
                                    .tint(AppColors.brightYellow)
                                    .background(
                                        Circle()
                                            .fill(Color.black.opacity(0.7))
                                            .frame(width: 20, height: 20)
                                    )
                            }
                        }
                    }
                } else {
                    Image(systemName: selectedIconName)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [AppColors.cardWhite, AppColors.cardWhite.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
            }
        }
    }
}

#Preview {
    IconPreview(
        selectedIconName: "person.fill",
        selectedImage: nil,
        isUsingCustomImage: false
    )
    .background(AppGradients.primaryBackground)
}