//
//  ProfileSectionView.swift
//  DotenkoV4
//
//  プロフィールセクション（アイコン + 名前）
//

import SwiftUI

struct ProfileSectionView: View {
    
    var body: some View {
        VStack(spacing: 16) {
            // プロフィールアイコン
            profileIconView
            
            // プレイヤー名
            playerNameView
        }
    }
    
    // MARK: - プロフィールアイコン
    private var profileIconView: some View {
        ZStack {
            // 外側のグロー効果
            RoundedRectangle(cornerRadius: 18)
                .fill(AppColors.brightYellow.opacity(0.2))
                .frame(width: 110, height: 110)
                .blur(radius: 6)
            
            // メインフレーム
            RoundedRectangle(cornerRadius: 16)
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
                .frame(width: 96, height: 96)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.brightYellow, AppColors.vibrantOrange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
            
            // アイコン
            Image(systemName: "person.fill")
                .font(.system(size: 40, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.cardWhite, AppColors.cardWhite.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
    }
    
    // MARK: - プレイヤー名
    private var playerNameView: some View {
        HStack(spacing: 8) {
            Text("iphone16pro")
                .font(.custom("Impact", size: 24))
                .fontWeight(.bold)
                .foregroundColor(AppColors.cardWhite)
            
            Circle()
                .fill(AppColors.brightYellow)
                .frame(width: 18, height: 18)
                .overlay(
                    Image(systemName: "pencil")
                        .font(.system(size: 9))
                        .foregroundColor(.black)
                )
        }
    }
}

#Preview {
    ProfileSectionView()
        .background(AppGradients.primaryBackground)
}