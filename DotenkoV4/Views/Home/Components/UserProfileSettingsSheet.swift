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
                    headerView
                    
                    VStack(spacing: 16) {
                        // アイコン選択セクション
                        iconSelectionSection
                        
                        // 名前編集セクション
                        nameEditingSection
                        
                        // 保存ボタン
                        saveButton
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
        VStack(spacing: 0) {
            // ナビゲーションバー
            HStack {
                // 閉じるボタン
                Button {
                    dismiss()
                } label: {
                    Text("❌")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.cardWhite)
                }
                
                Spacer()
                
                // タイトル（中央）
                Text("プロフィール設定")
                    .font(AppFonts.gothicHeadline(22))
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
    
    // MARK: - アイコン選択セクション
    private var iconSelectionSection: some View {
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
                currentIconPreview
                    .shadow(color: AppColors.brightYellow.opacity(0.3), radius: 12, x: 0, y: 6)
                
                photoLibraryButton
                    .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
            }
            
            // 定型アイコングリッド（コンパクト）
            VStack(spacing: 8) {
                Text("定型アイコン")
                    .font(AppFonts.gothicCaption(12))
                    .foregroundColor(AppColors.cardWhite.opacity(0.8))
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                    ForEach(availableIcons, id: \.self) { iconName in
                        iconButton(iconName: iconName)
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
    
    // MARK: - 現在のアイコンプレビュー
    private var currentIconPreview: some View {
        ZStack {
            // グロー効果（アニメーション付き）
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    RadialGradient(
                        colors: [
                            AppColors.brightYellow.opacity(0.4),
                            AppColors.vibrantOrange.opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 50
                    )
                )
                .frame(width: 85, height: 85)
                .blur(radius: 6)
                .scaleEffect(isUsingCustomImage ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isUsingCustomImage)
            
            // メインフレーム（グラデーション強化）
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.8),
                            Color.black.opacity(0.4),
                            Color.black.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 70, height: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.brightYellow, AppColors.vibrantOrange, AppColors.brightYellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2.5
                        )
                        .shadow(color: AppColors.brightYellow.opacity(0.6), radius: 4, x: 0, y: 0)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            Color.white.opacity(0.3),
                            lineWidth: 0.5
                        )
                        .blendMode(.overlay)
                )
            
            // 選択中のアイコン
            Group {
                if isUsingCustomImage, let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                } else if isUsingCustomImage {
                    // カスタム画像選択中だが、まだ読み込み中
                    ZStack {
                        Image(systemName: selectedIconName)
                            .font(.system(size: 28, weight: .medium))
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
                        .font(.system(size: 28, weight: .medium))
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
        VStack(spacing: 12) {
            Text("定型アイコンから選択")
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite.opacity(0.8))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                ForEach(availableIcons, id: \.self) { iconName in
                    iconButton(iconName: iconName)
                }
            }
            .padding(.horizontal, 8)
        }
    }
    
    // MARK: - アイコンボタン
    private func iconButton(iconName: String) -> some View {
        let isSelected = (selectedIconName == iconName && !isUsingCustomImage)
        
        return Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedIconName = iconName
                isUsingCustomImage = false
                selectedImage = nil
            }
        } label: {
            ZStack {
                // 背景（アニメーション強化）
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected
                            ? LinearGradient(
                                colors: [
                                    AppColors.brightYellow.opacity(0.4),
                                    AppColors.vibrantOrange.opacity(0.3),
                                    Color.black.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [
                                    Color.black.opacity(0.5),
                                    Color.black.opacity(0.3),
                                    Color.black.opacity(0.4)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected
                                    ? LinearGradient(
                                        colors: [AppColors.brightYellow, AppColors.vibrantOrange, AppColors.brightYellow],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    : LinearGradient(
                                        colors: [AppColors.cardWhite.opacity(0.4), AppColors.cardWhite.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                lineWidth: isSelected ? 2.5 : 1
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                Color.white.opacity(isSelected ? 0.4 : 0.2),
                                lineWidth: 0.5
                            )
                            .blendMode(.overlay)
                    )
                    .shadow(
                        color: isSelected ? AppColors.brightYellow.opacity(0.5) : Color.black.opacity(0.3),
                        radius: isSelected ? 12 : 6,
                        x: 0,
                        y: isSelected ? 4 : 2
                    )
                
                // アイコン（シャドウ付き）
                Image(systemName: iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(
                        isSelected
                            ? LinearGradient(
                                colors: [AppColors.brightYellow, AppColors.vibrantOrange, AppColors.brightYellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [AppColors.cardWhite, AppColors.cardWhite.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                    )
                    .shadow(
                        color: isSelected ? Color.black.opacity(0.4) : Color.black.opacity(0.2),
                        radius: isSelected ? 3 : 1,
                        x: 0,
                        y: 1
                    )
            }
        }
        .scaleEffect(isSelected ? 1.08 : 1.0)
        .rotationEffect(.degrees(isSelected ? 2 : 0))
        .animation(.interpolatingSpring(stiffness: 400, damping: 12).delay(isSelected ? 0 : 0.1), value: isSelected)
    }
    
    // MARK: - 名前編集セクション
    private var nameEditingSection: some View {
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
    
    // MARK: - 保存ボタン
    private var saveButton: some View {
        let isDisabled = editingName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isUpdating
        
        return Button {
            saveProfile()
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
