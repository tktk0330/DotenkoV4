//
//  SplashView.swift
//  DotenkoV4
//
//  スプラッシュ画面
//  アプリ起動時の最初の画面で、裏でFirebaseからメンテ情報や最低アプリバージョン、ユーザー情報などを取得
//  カジノ風デザインでアプリロゴとローディングアニメーションを表示
//

import SwiftUI

// MARK: - スプラッシュ画面ビュー
struct SplashView: View {
    
    // MARK: - プロパティ
    @EnvironmentObject private var navigationManager: NavigationStateManager // ナビゲーション管理
    @Environment(\.modelContext) private var modelContext               // SwiftData
    @StateObject private var authManager = AuthManager.shared           // 認証管理
    @StateObject private var appStatusManager = AppStatusManager.shared // アプリステータス管理
    @State private var isLoading: Bool = true                           // ローディング状態
    @State private var cardScale: CGFloat = 0.8                         // カードのスケールアニメーション
    @State private var cardOpacity: Double = 0.0                        // カードの透明度アニメーション
    @State private var loadingOpacity: Double = 0.0                     // ローディングテキストの透明度
    @State private var loadingProgress: Double = 0.0                    // ローディング進行度
    @State private var showErrorPopup: Bool = false                     // エラーポップアップ表示
    @State private var authError: Error?                                // 認証エラー
    
    // MARK: - ボディ
    var body: some View {
        ZStack {
            // 背景グラデーション
            backgroundView
            
            // メインコンテンツ
            mainContentView
            
            // ローディング表示
            if isLoading {
                loadingView
            }
        }
        .ignoresSafeArea()
        .onAppear {
            authManager.setModelContext(modelContext)
            startSplashSequence()
        }
        .overlay {
            // エラーポップアップ
            if showErrorPopup, let error = authError {
                ErrorPopupView(
                    error: error,
                    retryAction: {
                        showErrorPopup = false
                        performInitialization()
                    },
                    dismissAction: {
                        showErrorPopup = false
                        // エラーでもTOP画面へ遷移（オフラインモード）
                        navigationManager.push(TopView())
                    }
                )
            }
        }
    }
    
    // MARK: - 背景ビュー
    private var backgroundView: some View {
        AppGradients.primaryBackground
    }
    
    // MARK: - メインコンテンツビュー
    private var mainContentView: some View {
        VStack(spacing: ScreenConstants.largePadding) {
            
            Spacer()
            
            // カード裏面画像
            cardBackView
            
            Spacer()
            
            // ローディングプログレスバー
            progressBarView
            
            Spacer()
                .frame(height: ScreenConstants.bannerHeight + ScreenConstants.defaultPadding)
        }
        .padding(ScreenConstants.defaultPadding)
    }
    
    // MARK: - カード裏面ビュー
    private var cardBackView: some View {
        Image("back-1")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 280)
            .shadow(color: AppGradients.cardShadow, radius: 8, x: 4, y: 4)
            .scaleEffect(cardScale)
            .opacity(cardOpacity)
    }
    
    // MARK: - プログレスバービュー
    private var progressBarView: some View {
        // プログレスバー
        ZStack(alignment: .leading) {
            // 背景バー
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.cardWhite.opacity(0.3), lineWidth: 2)
                .frame(height: 8)
            
            // 進行バー
            RoundedRectangle(cornerRadius: 20)
                .fill(AppGradients.logoGradient)
                .frame(width: UIScreen.main.bounds.width * 0.7 * loadingProgress, height: 8)
        }
        .frame(width: UIScreen.main.bounds.width * 0.7)
        .opacity(loadingOpacity)
    }
    
    // MARK: - ローディングビュー
    private var loadingView: some View {
        Color.clear
    }
    
    // MARK: - アニメーション開始
    private func startSplashSequence() {
        // カードアニメーション
        withAnimation(.easeOut(duration: 1.0)) {
            cardScale = 1.0
            cardOpacity = 1.0
        }
        
        // ローディングテキスト表示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeIn(duration: 0.5)) {
                loadingOpacity = 1.0
            }
        }
        
        // プログレスバーアニメーション
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 1.5)) {
                loadingProgress = 1.0
            }
        }
        
        // Firebase初期化処理をシミュレート
        performInitialization()
    }
    
    // MARK: - 初期化処理
    private func performInitialization() {
        Task {
            do {
                // Firebase匿名認証
                let userProfile = try await authManager.signInAnonymously()
                print("✅ スプラッシュ画面: 認証完了")
                print("   - Firebase UID: \(userProfile.firebaseUID)")
                print("   - 表示名: \(userProfile.displayName)")
                print("   - アイコン: \(userProfile.iconName)")
                print("   - 作成日: \(userProfile.createdAt)")
                print("   - 最終ログイン: \(userProfile.lastLoginAt)")
                
                // プロフィール画像をプリロード
                await ImageCacheManager.shared.preloadProfileImage(
                    userId: userProfile.firebaseUID,
                    iconUrl: userProfile.iconUrl
                )
                
                // メンテナンス情報取得
                let appStatus = try await appStatusManager.fetchAppStatus()
                print("✅ スプラッシュ画面: アプリステータス取得完了")
                
                // メンテナンス状態チェック
                if appStatus.maintenanceFlag {
                    print("🚨 メンテナンスモード: アプリは現在メンテナンス中です")
                    // TODO: メンテナンス画面に遷移
                }
                
                // バージョンサポート状況チェック
                if !appStatus.isCurrentVersionSupported(currentVersion: getCurrentAppVersion()) {
                    print("⚠️ バージョン非対応: アプリのアップデートが必要です")
                    // TODO: アップデート要求画面に遷移
                }
                
                // 成功時の処理
                await MainActor.run {
                    withAnimation(.easeOut(duration: 0.5)) {
                        isLoading = false
                    }
                    
                    // トップ画面に遷移
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        navigationManager.push(TopView())
                    }
                }
                
            } catch {
                // エラー時の処理
                await MainActor.run {
                    authError = error
                    showErrorPopup = true
                    isLoading = false
                }
            }
        }
    }
    
    // MARK: - ヘルパーメソッド
    private func getCurrentAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0.0" // デフォルト値
    }
}

// MARK: - プレビュー
#Preview {
    SplashView()
        .environmentObject(NavigationStateManager())
}