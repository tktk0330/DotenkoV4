//
//  UserProfileSettingsSheet.swift
//  DotenkoV4
//
//  ユーザープロフィール設定シート
//  ユーザー名とアイコン画像の設定機能
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
    
    // 利用可能なアイコンリスト
    private let availableIcons = [
        "person.fill",
        "person.crop.circle.fill", 
        "gamecontroller.fill",
        "crown.fill",
        "star.fill",
        "heart.fill",
        "diamond.fill",
        "suit.heart.fill",
        "suit.diamond.fill",
        "suit.club.fill",
        "suit.spade.fill",
        "flame.fill"
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // ヘッダー
                headerView
                
                // アイコン選択セクション
                iconSelectionSection
                
                // 名前編集セクション
                nameEditingSection
                
                Spacer()
                
                // 保存ボタン
                saveButton
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 32)
            .background(AppColors.primaryBackground)
            .navigationBarHidden(true)
        }
        .onAppear {
            setupInitialValues()
        }
        .onReceive(imageCacheManager.$profileImages) { _ in
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
        .alert("エラー", isPresented: $showingErrorAlert) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - ヘッダー
    private var headerView: some View {
        HStack {
            Button("キャンセル") {
                dismiss()
            }
            .font(AppFonts.gothicBody(16))
            .foregroundColor(AppColors.cardWhite)
            
            Spacer()
            
            Text("プロフィール設定")
                .font(AppFonts.gothicHeadline(20))
                .foregroundColor(AppColors.cardWhite)
            
            Spacer()
            
            if isUpdating {
                ProgressView()
                    .scaleEffect(0.8)
                    .tint(AppColors.brightYellow)
            } else {
                // 空のスペース
                Text("")
                    .frame(width: 60)
            }
        }
    }
    
    // MARK: - アイコン選択セクション
    private var iconSelectionSection: some View {
        VStack(spacing: 16) {
            // 現在選択中のアイコンプレビュー
            currentIconPreview
            
            Text("アイコンを選択")
                .font(AppFonts.gothicHeadline(18))
                .foregroundColor(AppColors.cardWhite)
            
            // フォトライブラリボタン
            photoLibraryButton
            
            Text("または定型アイコンから選択")
                .font(AppFonts.gothicCaption(14))
                .foregroundColor(AppColors.cardWhite.opacity(0.7))
            
            // アイコングリッド
            iconGrid
        }
    }
    
    // MARK: - 現在のアイコンプレビュー
    private var currentIconPreview: some View {
        ZStack {
            // 外側のグロー効果
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.brightYellow.opacity(0.2))
                .frame(width: 110, height: 110)
                .blur(radius: 6)
            
            // メインフレーム
            RoundedRectangle(cornerRadius: 18)
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
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.brightYellow, AppColors.vibrantOrange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
            
            // 選択中のアイコン
            Group {
                if isUsingCustomImage, let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 96, height: 96)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                } else if isUsingCustomImage {
                    // カスタム画像選択中だが、まだ読み込み中
                    ZStack {
                        Image(systemName: selectedIconName)
                            .font(.system(size: 40, weight: .medium))
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
    
    // MARK: - フォトライブラリボタン
    private var photoLibraryButton: some View {
        PhotosPicker(selection: $selectedPhoto, matching: .images) {
            HStack(spacing: 12) {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.brightYellow)
                
                Text("フォトライブラリから選択")
                    .font(AppFonts.gothicBody(16))
                    .foregroundColor(AppColors.cardWhite)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.cardWhite.opacity(0.6))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isUsingCustomImage 
                                    ? AppColors.brightYellow
                                    : AppColors.cardWhite.opacity(0.3),
                                lineWidth: isUsingCustomImage ? 2 : 1
                            )
                    )
            )
        }
        .onChange(of: selectedPhoto) { _, newPhoto in
            Task {
                if let newPhoto = newPhoto {
                    await loadSelectedPhoto(from: newPhoto)
                }
            }
        }
    }
    
    // MARK: - アイコングリッド
    private var iconGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
            ForEach(availableIcons, id: \.self) { iconName in
                iconButton(iconName: iconName)
            }
        }
        .padding(.horizontal, 8)
    }
    
    // MARK: - アイコンボタン
    private func iconButton(iconName: String) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedIconName = iconName
                isUsingCustomImage = false
                selectedImage = nil
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        (selectedIconName == iconName && !isUsingCustomImage)
                            ? AppColors.brightYellow.opacity(0.3)
                            : Color.black.opacity(0.3)
                    )
                    .frame(width: 60, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                (selectedIconName == iconName && !isUsingCustomImage)
                                    ? AppColors.brightYellow
                                    : AppColors.cardWhite.opacity(0.3),
                                lineWidth: (selectedIconName == iconName && !isUsingCustomImage) ? 2 : 1
                            )
                    )
                
                Image(systemName: iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(
                        (selectedIconName == iconName && !isUsingCustomImage)
                            ? AppColors.brightYellow
                            : AppColors.cardWhite.opacity(0.7)
                    )
            }
        }
        .scaleEffect((selectedIconName == iconName && !isUsingCustomImage) ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: selectedIconName)
        .animation(.easeInOut(duration: 0.2), value: isUsingCustomImage)
    }
    
    // MARK: - 名前編集セクション
    private var nameEditingSection: some View {
        VStack(spacing: 12) {
            Text("ユーザー名")
                .font(AppFonts.gothicHeadline(18))
                .foregroundColor(AppColors.cardWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("ユーザー名を入力", text: $editingName)
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.brightYellow.opacity(0.5), lineWidth: 1)
                        )
                )
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
    }
    
    // MARK: - 保存ボタン
    private var saveButton: some View {
        Button {
            saveProfile()
        } label: {
            Text(isUpdating ? "保存中..." : "保存")
                .font(AppFonts.gothicHeadline(18))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            editingName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isUpdating
                                ? AppColors.disabledButton
                                : AppColors.brightYellow
                        )
                )
        }
        .disabled(editingName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isUpdating)
    }
    
    // MARK: - 初期値設定
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
    
    // MARK: - フォトライブラリから画像読み込み
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
    
    
    // MARK: - プロフィール保存
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