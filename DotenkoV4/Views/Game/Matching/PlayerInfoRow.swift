//
//  PlayerInfoRow.swift
//  DotenkoV4
//
//  プレイヤー情報表示行コンポーネント
//  - ユーザープロフィール情報の表示
//  - メインプレイヤーと他プレイヤーの区別表示
//

import SwiftUI

// MARK: - プレイヤー情報行コンポーネント
struct PlayerInfoRow: View {
    // MARK: - プロパティ
    let playerNumber: Int                    // プレイヤー番号
    let isMainPlayer: Bool                   // メインプレイヤーか
    let userProfile: UserProfile?            // ユーザープロフィール
    @ObservedObject private var imageCacheManager = ImageCacheManager.shared
    
    // キャッシュされたプロフィール画像
    private var profileImage: UIImage? {
        guard let profile = userProfile else { return nil }
        return imageCacheManager.getProfileImage(for: profile.firebaseUID, iconUrl: profile.iconUrl)
    }
    
    // MARK: - ボディ
    var body: some View {
        HStack(spacing: 16) {
            // プレイヤーアイコン
            playerIcon
            
            // プレイヤー情報
            playerInfo
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(rowBackground)
    }
    
    // MARK: - プレイヤーアイコン
    private var playerIcon: some View {
        ZStack {
            // グロー効果
            Circle()
                .fill(isMainPlayer ? AppColors.accentText.opacity(0.3) : AppColors.secondaryText.opacity(0.2))
                .frame(width: 60, height: 60)
                .blur(radius: 8)
            
            // メインアイコン背景
            Circle()
                .fill(
                    isMainPlayer ? 
                    AnyShapeStyle(AppGradients.logoGradient) :
                    AnyShapeStyle(AppColors.secondaryBackground)
                )
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(
                            isMainPlayer ? AppColors.accentText : AppColors.secondaryText.opacity(0.3), 
                            lineWidth: 2
                        )
                )
            
            // アイコン内容
            iconContent
        }
    }
    
    // MARK: - アイコン内容
    private var iconContent: some View {
        Group {
            if isMainPlayer {
                // メインプレイヤー（ユーザー）のアイコン
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    Image(systemName: userProfile?.iconName ?? "person.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white)
                }
            } else {
                // その他のプレイヤー
                Image(systemName: "person.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(AppColors.secondaryText)
            }
        }
    }
    
    // MARK: - プレイヤー情報
    private var playerInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            // プレイヤー名
            Text(playerDisplayName)
                .font(AppFonts.gothicBody(18))
                .fontWeight(isMainPlayer ? .bold : .medium)
                .foregroundStyle(AppColors.primaryText)
        }
    }
    
    // MARK: - 背景
    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(isMainPlayer ? AppColors.accentText.opacity(0.05) : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isMainPlayer ? AppColors.accentText.opacity(0.3) : AppColors.secondaryText.opacity(0.1), 
                        lineWidth: 1
                    )
            )
    }
    
    // MARK: - 計算プロパティ
    private var playerDisplayName: String {
        return isMainPlayer ? (userProfile?.displayName ?? "あなた") : "プレイヤー\(playerNumber)"
    }
}

// MARK: - プレビュー
#Preview {
    VStack(spacing: 16) {
        PlayerInfoRow(
            playerNumber: 1,
            isMainPlayer: true,
            userProfile: nil
        )
        
        PlayerInfoRow(
            playerNumber: 2,
            isMainPlayer: false,
            userProfile: nil
        )
    }
    .padding()
    .background(AppColors.primaryBackground)
}