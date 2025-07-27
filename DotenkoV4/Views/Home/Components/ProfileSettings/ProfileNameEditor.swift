//
//  ProfileNameEditor.swift
//  DotenkoV4
//
//  プロフィール名前編集コンポーネント
//

import SwiftUI

struct ProfileNameEditor: View {
    @Binding var editingName: String
    
    var body: some View {
        VStack(spacing: 10) {
            // セクションタイトル
            HStack {
                Image(systemName: "person.badge.key.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.brightYellow)
                
                Text("ユーザー名")
                    .font(AppFonts.gothicHeadline(16))
                    .foregroundColor(AppColors.cardWhite)
                
                Spacer()
            }
            
            // テキストフィールド（高級グラデーション）
            TextField("ユーザー名を入力", text: $editingName)
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite)
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.7),
                                    Color.black.opacity(0.4),
                                    Color.black.opacity(0.6)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [AppColors.brightYellow.opacity(0.7), AppColors.vibrantOrange.opacity(0.5), AppColors.brightYellow.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    Color.white.opacity(0.2),
                                    lineWidth: 0.5
                                )
                                .blendMode(.overlay)
                        )
                        .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
                        .shadow(color: AppColors.brightYellow.opacity(0.3), radius: 4, x: 0, y: 0)
                )
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
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
                    RoundedRectangle(cornerRadius: 16)
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
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            Color.white.opacity(0.1),
                            lineWidth: 0.5
                        )
                        .blendMode(.overlay)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        )
    }
}

#Preview {
    ProfileNameEditor(editingName: .constant("テストユーザー"))
        .background(AppGradients.primaryBackground)
}