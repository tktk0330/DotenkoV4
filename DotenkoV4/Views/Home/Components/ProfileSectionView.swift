//
//  ProfileSectionView.swift
//  DotenkoV4
//
//  プロフィールセクション（アイコン + 名前）
//

import SwiftUI
import SwiftData

struct ProfileSectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userProfiles: [UserProfile]
    @ObservedObject private var imageCacheManager = ImageCacheManager.shared
    @State private var showingSettingsSheet = false
    
    // 現在のユーザープロフィール
    private var currentProfile: UserProfile? {
        userProfiles.first
    }
    
    // キャッシュされたプロフィール画像
    private var profileImage: UIImage? {
        guard let profile = currentProfile else { return nil }
        return imageCacheManager.getProfileImage(for: profile.firebaseUID, iconUrl: profile.iconUrl)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // プロフィールアイコン
            profileIconView
            
            // プレイヤー名
            playerNameView
        }
        .sheet(isPresented: $showingSettingsSheet) {
            UserProfileSettingsSheet(userProfile: .constant(currentProfile))
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
            Group {
                if let profileImage = profileImage {
                    // カスタム画像（キャッシュから即座に表示）
                    Image(uiImage: profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 96, height: 96)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else if let profile = currentProfile, imageCacheManager.isLoading(userId: profile.firebaseUID) {
                    // バックグラウンド読み込み中
                    ZStack {
                        Image(systemName: profile.iconName)
                            .font(.system(size: 40, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [AppColors.cardWhite, AppColors.cardWhite.opacity(0.7)],
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
                    // システムアイコン
                    Image(systemName: currentProfile?.iconName ?? "person.fill")
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
        }
    }
    
    // MARK: - プレイヤー名
    private var playerNameView: some View {
        Button {
            showingSettingsSheet = true
        } label: {
            HStack(spacing: 8) {
                Text(currentProfile?.displayName ?? "ゲスト")
                    .font(AppFonts.gothicHeadline(24))
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
}

#Preview {
    ProfileSectionView()
        .background(AppGradients.primaryBackground)
}