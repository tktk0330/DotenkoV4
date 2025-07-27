//
//  ProfileSaveButton.swift
//  DotenkoV4
//
//  プロフィール保存ボタンコンポーネント
//

import SwiftUI

struct ProfileSaveButton: View {
    let isDisabled: Bool
    let isUpdating: Bool
    let onSave: () -> Void
    
    var body: some View {
        Button {
            onSave()
        } label: {
            HStack(spacing: 12) {
                if isUpdating {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.black)
                }
                
                Text(isUpdating ? "保存中..." : "変更を保存")
                    .font(AppFonts.gothicHeadline(18))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                if !isUpdating {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        isDisabled
                            ? LinearGradient(
                                colors: [Color.gray.opacity(0.6), Color.gray.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [
                                    AppColors.brightYellow,
                                    AppColors.vibrantOrange,
                                    AppColors.brightYellow.opacity(0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                isDisabled
                                    ? LinearGradient(
                                        colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.4)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    : LinearGradient(
                                        colors: [AppColors.brightYellow, AppColors.vibrantOrange, AppColors.brightYellow],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                lineWidth: isDisabled ? 1 : 3
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                Color.white.opacity(isDisabled ? 0.1 : 0.4),
                                lineWidth: 1
                            )
                            .blendMode(.overlay)
                    )
            )
            .shadow(
                color: isDisabled ? Color.black.opacity(0.3) : AppColors.brightYellow.opacity(0.6),
                radius: isDisabled ? 4 : 12,
                x: 0,
                y: isDisabled ? 2 : 6
            )
            .shadow(
                color: isDisabled ? Color.clear : AppColors.vibrantOrange.opacity(0.4),
                radius: isDisabled ? 0 : 20,
                x: 0,
                y: isDisabled ? 0 : 8
            )
        }
        .disabled(isDisabled)
        .scaleEffect(isDisabled ? 0.96 : 1.02)
        .animation(.interpolatingSpring(stiffness: 400, damping: 18), value: isDisabled)
        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: !isDisabled)
    }
}

#Preview {
    VStack {
        ProfileSaveButton(isDisabled: false, isUpdating: false) { }
        ProfileSaveButton(isDisabled: true, isUpdating: false) { }
        ProfileSaveButton(isDisabled: false, isUpdating: true) { }
    }
    .background(AppGradients.primaryBackground)
}