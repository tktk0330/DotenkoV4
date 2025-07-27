//
//  CustomImageButton.swift
//  DotenkoV4
//
//  カスタム画像追加ボタンコンポーネント
//

import SwiftUI
import PhotosUI

struct CustomImageButton: View {
    @Binding var selectedPhoto: PhotosPickerItem?
    let isUsingCustomImage: Bool
    
    var body: some View {
        PhotosPicker(selection: $selectedPhoto, matching: .images) {
            VStack(spacing: 6) {
                // アイコン（シンプルデザイン）
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    AppColors.brightYellow.opacity(0.2),
                                    AppColors.vibrantOrange.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [AppColors.brightYellow.opacity(0.6), AppColors.vibrantOrange.opacity(0.4)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                    
                    Image(systemName: "photo.badge.plus.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [AppColors.brightYellow, AppColors.vibrantOrange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                // テキスト（シンプル）
                VStack(spacing: 1) {
                    Text("カスタム")
                        .font(AppFonts.gothicCaption(10))
                        .foregroundColor(AppColors.cardWhite)
                    
                    Text("追加")
                        .font(AppFonts.gothicCaption(9))
                        .foregroundColor(AppColors.cardWhite.opacity(0.7))
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.3),
                                Color.black.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isUsingCustomImage
                                    ? LinearGradient(
                                        colors: [AppColors.brightYellow, AppColors.vibrantOrange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    : LinearGradient(
                                        colors: [AppColors.cardWhite.opacity(0.3), AppColors.cardWhite.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                lineWidth: isUsingCustomImage ? 1.5 : 1
                            )
                    )
            )
        }
        .scaleEffect(isUsingCustomImage ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isUsingCustomImage)
    }
}

#Preview {
    CustomImageButton(
        selectedPhoto: .constant(nil),
        isUsingCustomImage: false
    )
    .background(AppGradients.primaryBackground)
}