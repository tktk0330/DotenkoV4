//
//  ProfileSettingsHeader.swift
//  DotenkoV4
//
//  プロフィール設定ヘッダーコンポーネント
//

import SwiftUI

struct ProfileSettingsHeader: View {
    let isUpdating: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // ナビゲーションバー
            HStack {
                // 閉じるボタン
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.cardWhite)
                }
                .padding(.leading, 8)
                
                Spacer()
                
                // タイトル（中央）
                Text("プロフィール設定")
                    .font(AppFonts.gothicHeadline(26))
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.brightYellow, AppColors.vibrantOrange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Spacer()
                
                // 保存状態表示
                if isUpdating {
                    HStack(spacing: 6) {
                        ProgressView()
                            .scaleEffect(0.7)
                            .tint(AppColors.brightYellow)
                        Text("保存中")
                            .font(AppFonts.gothicCaption(10))
                            .foregroundColor(AppColors.brightYellow)
                    }
                } else {
                    // スペーサー（バランス用）
                    Text("")
                        .frame(width: 32)
                }
            }
        }
    }
}

#Preview {
    ProfileSettingsHeader(isUpdating: false) {
        // Preview action
    }
    .background(AppGradients.primaryBackground)
}