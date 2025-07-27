//
//  UserProfileSettingsSheet.swift
//  DotenkoV4
//
//  ユーザープロフィール設定シート（リファクタリング版）
//  分割されたコンポーネントを組み合わせて構成
//

import SwiftUI
import SwiftData
import PhotosUI

struct UserProfileSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var imageCacheManager = ImageCacheManager.shared
    @Binding var userProfile: UserProfile?
    
    @State private var editingName: String = ""
    @State private var selectedIconName: String = "person.fill"
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isUpdating: Bool = false
    @State private var showingErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var isUsingCustomImage: Bool = false
    
    // 利用可能なアイコンリスト（8個に厳選）
    private let availableIcons = [
        "person.fill",
        "crown.fill",
        "star.fill",
        "gamecontroller.fill",
        "suit.heart.fill",
        "suit.diamond.fill",
        "suit.spade.fill",
        "flame.fill"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景グラデーション
                AppGradients.primaryBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // ヘッダー
                    ProfileSettingsHeader(
                        isUpdating: isUpdating,
                        onDismiss: { dismiss() }
                    )
                    
                    VStack(spacing: 16) {
                        // アイコン選択セクション
                        IconSelectionSection(
                            selectedIconName: selectedIconName,
                            selectedImage: selectedImage,
                            isUsingCustomImage: isUsingCustomImage,
                            selectedPhoto: $selectedPhoto,
                            availableIcons: availableIcons,
                            onIconSelect: handleIconSelection
                        )
                        
                        // 名前編集セクション
                        ProfileNameEditor(editingName: $editingName)
                        
                        // 保存ボタン
                        ProfileSaveButton(
                            isDisabled: editingName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isUpdating,
                            isUpdating: isUpdating,
                            onSave: saveProfile
                        )
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            setupInitialValues()
        }
        .onReceive(imageCacheManager.$profileImages) { _ in
            handleImageCacheUpdate()
        }
        .onChange(of: selectedPhoto) { _, newPhoto in
            if let newPhoto = newPhoto {
                Task {
                    await loadSelectedPhoto(from: newPhoto)
                }
            }
        }
        .alert("エラー", isPresented: $showingErrorAlert) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Helper Methods
    
    private func handleIconSelection(_ iconName: String) {
        selectedIconName = iconName
        isUsingCustomImage = false
        selectedImage = nil
    }
    
    private func handleImageCacheUpdate() {
        // キャッシュが更新されたときに画像を再取得
        if let profile = userProfile,
           let iconUrl = profile.iconUrl, !iconUrl.isEmpty,
           isUsingCustomImage,
           selectedImage == nil {
            if let cachedImage = imageCacheManager.getProfileImage(for: profile.firebaseUID, iconUrl: iconUrl) {
                selectedImage = cachedImage
                print("✅ プロフィール設定画面: バックグラウンド読み込み完了")
            }
        }
    }
    
    // MARK: - Data Management
    
    private func setupInitialValues() {
        if let profile = userProfile {
            editingName = profile.displayName
            selectedIconName = profile.iconName
            
            // カスタム画像が設定されている場合、キャッシュから取得
            if let iconUrl = profile.iconUrl, !iconUrl.isEmpty {
                isUsingCustomImage = true
                
                // キャッシュから画像を取得
                if let cachedImage = imageCacheManager.getProfileImage(for: profile.firebaseUID, iconUrl: iconUrl) {
                    selectedImage = cachedImage
                    print("✅ プロフィール設定画面: キャッシュから画像を取得")
                } else {
                    print("⚠️ プロフィール設定画面: キャッシュに画像がない、バックグラウンド読み込み中...")
                    // キャッシュにない場合はバックグラウンドで読み込み中
                    // ImageCacheManagerが自動的にバックグラウンド読み込みを開始
                }
            }
        }
    }
    
    private func loadSelectedPhoto(from photoItem: PhotosPickerItem) async {
        guard let data = try? await photoItem.loadTransferable(type: Data.self),
              let image = UIImage(data: data) else {
            await MainActor.run {
                errorMessage = "画像の読み込みに失敗しました"
                showingErrorAlert = true
            }
            return
        }
        
        await MainActor.run {
            selectedImage = image
            isUsingCustomImage = true
        }
    }
    
    private func saveProfile() {
        guard let profile = userProfile else { return }
        
        let trimmedName = editingName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        isUpdating = true
        
        Task {
            do {
                var imageUrl: String? = nil
                
                // カスタム画像を使用する場合、Firebase Storageにアップロード
                if isUsingCustomImage, let selectedImage = selectedImage {
                    print("🔄 カスタム画像をアップロード中...")
                    
                    // 古い画像がある場合は削除
                    if let oldImageUrl = profile.iconUrl, !oldImageUrl.isEmpty {
                        await FirebaseStorageManager.shared.deleteOldProfileImage(from: oldImageUrl)
                    }
                    
                    // 新しい画像をアップロード
                    imageUrl = try await FirebaseStorageManager.shared.uploadProfileImage(
                        image: selectedImage,
                        userId: profile.firebaseUID
                    )
                } else {
                    // システムアイコンを使用する場合、古いカスタム画像を削除
                    if let oldImageUrl = profile.iconUrl, !oldImageUrl.isEmpty {
                        await FirebaseStorageManager.shared.deleteOldProfileImage(from: oldImageUrl)
                    }
                }
                
                // SwiftDataを更新
                profile.displayName = trimmedName
                profile.iconName = selectedIconName
                profile.iconUrl = imageUrl
                profile.lastLoginAt = Date()
                
                try modelContext.save()
                
                // Firestoreを更新
                try await AuthManager.shared.updateUserProfile(
                    firebaseUID: profile.firebaseUID,
                    displayName: trimmedName,
                    iconUrl: imageUrl
                )
                
                // 画像キャッシュを更新
                if let selectedImage = selectedImage, isUsingCustomImage {
                    ImageCacheManager.shared.updateProfileImage(
                        userId: profile.firebaseUID,
                        image: selectedImage
                    )
                } else {
                    // システムアイコンに変更した場合はキャッシュを削除
                    ImageCacheManager.shared.removeProfileImage(userId: profile.firebaseUID)
                }
                
                print("✅ プロフィール更新完了:")
                print("   - 表示名: \(trimmedName)")
                print("   - アイコン: \(selectedIconName)")
                print("   - 画像URL: \(imageUrl ?? "なし")")
                
                await MainActor.run {
                    isUpdating = false
                    dismiss()
                }
                
            } catch {
                print("❌ プロフィール更新エラー: \(error)")
                
                await MainActor.run {
                    isUpdating = false
                    errorMessage = "プロフィールの更新に失敗しました: \(error.localizedDescription)"
                    showingErrorAlert = true
                }
            }
        }
    }
}

// MARK: - プレビュー
#Preview {
    UserProfileSettingsSheet(userProfile: .constant(nil))
}