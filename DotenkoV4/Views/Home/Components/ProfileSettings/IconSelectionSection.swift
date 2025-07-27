//
//  IconSelectionSection.swift
//  DotenkoV4
//
//  アイコン選択セクションコンポーネント
//

import SwiftUI
import PhotosUI

struct IconSelectionSection: View {
    let selectedIconName: String
    let selectedImage: UIImage?
    let isUsingCustomImage: Bool
    @Binding var selectedPhoto: PhotosPickerItem?
    let availableIcons: [String]
    let onIconSelect: (String) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // セクションタイトル
            HStack {
                Image(systemName: "person.crop.circle.badge.plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.brightYellow)
                
                Text("アイコンを選択")
                    .font(AppFonts.gothicHeadline(18))
                    .foregroundColor(AppColors.cardWhite)
                
                Spacer()
            }
            
            // プレビューとカスタムボタン
            HStack(spacing: 20) {
                IconPreview(
                    selectedIconName: selectedIconName,
                    selectedImage: selectedImage,
                    isUsingCustomImage: isUsingCustomImage
                )
                
                CustomImageButton(
                    selectedPhoto: $selectedPhoto,
                    isUsingCustomImage: isUsingCustomImage
                )
            }
            
            // 定型アイコングリッド（コンパクト）
            VStack(spacing: 8) {
                Text("定型アイコン")
                    .font(AppFonts.gothicCaption(12))
                    .foregroundColor(AppColors.cardWhite.opacity(0.8))
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                    ForEach(availableIcons, id: \.self) { iconName in
                        IconGridButton(
                            iconName: iconName,
                            isSelected: selectedIconName == iconName && !isUsingCustomImage
                        ) {
                            onIconSelect(iconName)
                        }
                    }
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.2),
                            Color.black.opacity(0.1),
                            Color.black.opacity(0.15)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.cardWhite.opacity(0.2), AppColors.cardWhite.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            Color.white.opacity(0.1),
                            lineWidth: 0.5
                        )
                        .blendMode(.overlay)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 6)
        )
    }
}

#Preview {
    IconSelectionSection(
        selectedIconName: "person.fill",
        selectedImage: nil,
        isUsingCustomImage: false,
        selectedPhoto: .constant(nil),
        availableIcons: ["person.fill", "star.fill", "heart.fill", "crown.fill"],
        onIconSelect: { _ in }
    )
    .background(AppGradients.primaryBackground)
}