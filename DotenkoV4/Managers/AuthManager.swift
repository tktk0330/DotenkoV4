//
//  AuthManager.swift
//  DotenkoV4
//
//  Firebase認証管理クラス
//  匿名認証とユーザー状態管理を担当
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftData

@MainActor
class AuthManager: ObservableObject {
    // MARK: - シングルトン
    static let shared = AuthManager()
    
    // MARK: - プロパティ
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var authError: AuthError?
    
    private var modelContext: ModelContext?
    private let db = Firestore.firestore()
    
    // MARK: - エラー定義
    enum AuthError: LocalizedError {
        case networkError
        case authenticationFailed
        case userDataNotFound
        case unknown(Error)
        
        var errorDescription: String? {
            switch self {
            case .networkError:
                return "ネットワーク接続エラー"
            case .authenticationFailed:
                return "認証に失敗しました"
            case .userDataNotFound:
                return "ユーザーデータが見つかりません"
            case .unknown(let error):
                return error.localizedDescription
            }
        }
        
        var recoverySuggestion: String? {
            switch self {
            case .networkError:
                return "インターネット接続を確認してください"
            case .authenticationFailed:
                return "もう一度お試しください"
            case .userDataNotFound:
                return "アプリを再起動してください"
            case .unknown:
                return "しばらく待ってからお試しください"
            }
        }
    }
    
    // MARK: - イニシャライザ
    private init() {
        // 初期化時に現在のユーザーを設定
        self.currentUser = Auth.auth().currentUser
        self.isAuthenticated = currentUser != nil
    }
    
    // MARK: - ModelContext設定
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    // MARK: - 認証メソッド
    func signInAnonymously() async throws -> UserProfile {
        isLoading = true
        authError = nil
        
        // 既に認証済みの場合は既存のユーザー情報を返す
        if let currentUser = Auth.auth().currentUser {
            print("📱 既存ユーザーで認証: Firebase UID = \(currentUser.uid)")
            
            guard let context = modelContext else {
                throw AuthError.userDataNotFound
            }
            
            // Firestoreから最新データを取得してローカルを更新
            let userProfile = try await syncUserWithFirestore(
                firebaseUID: currentUser.uid,
                context: context
            )
            
            print("👤 ユーザープロファイル取得: 名前 = \(userProfile.displayName)")
            
            isLoading = false
            return userProfile
        }
        
        do {
            // Firebase匿名認証（新規の場合のみ）
            let authResult = try await Auth.auth().signInAnonymously()
            let firebaseUID = authResult.user.uid
            
            print("🆕 新規匿名認証成功: Firebase UID = \(firebaseUID)")
            
            // SwiftDataからユーザー情報取得/作成
            guard let context = modelContext else {
                throw AuthError.userDataNotFound
            }
            
            // 新規ユーザーをFirestoreに登録してローカルに保存
            let userProfile = try await createUserInFirestore(
                firebaseUID: firebaseUID,
                context: context
            )
            
            print("👤 ユーザープロファイル作成: 名前 = \(userProfile.displayName)")
            
            // 認証状態を手動で更新
            self.currentUser = authResult.user
            self.isAuthenticated = true
            
            isLoading = false
            return userProfile
            
        } catch let error as NSError {
            isLoading = false
            
            // エラーハンドリング
            if error.domain == "FIRAuthErrorDomain" {
                if error.code == 17020 {
                    authError = .networkError
                } else {
                    authError = .authenticationFailed
                }
            } else {
                authError = .unknown(error)
            }
            
            throw authError ?? .unknown(error)
        }
    }
    
    
    // MARK: - サインアウト
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            currentUser = nil
        } catch {
            throw AuthError.unknown(error)
        }
    }
    
    // MARK: - 現在のユーザー取得
    func getCurrentUserProfile() async throws -> UserProfile? {
        guard let uid = currentUser?.uid,
              let context = modelContext else {
            return nil
        }
        
        let descriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.firebaseUID == uid }
        )
        
        return try context.fetch(descriptor).first
    }
    
    // MARK: - Firestoreユーザー作成
    private func createUserInFirestore(
        firebaseUID: String,
        context: ModelContext
    ) async throws -> UserProfile {
        print("🔥 Firestoreに新規ユーザー作成開始: UID = \(firebaseUID)")
        
        // Firestoreユーザーデータ作成
        let firestoreUser = FirestoreUser(uid: firebaseUID)
        
        // Firestoreに保存
        try await db.collection("users").document(firebaseUID).setData(firestoreUser.asDictionary)
        print("✅ Firestoreへの保存完了")
        
        // ローカルSwiftDataに保存
        let userProfile = UserProfile(
            firebaseUID: firebaseUID,
            displayName: firestoreUser.displayName,
            iconUrl: firestoreUser.iconUrl,
            createdAt: firestoreUser.createdAt,
            lastLoginAt: firestoreUser.lastLoginAt
        )
        
        context.insert(userProfile)
        try context.save()
        
        print("💾 ローカルデータベースへの保存完了")
        return userProfile
    }
    
    // MARK: - Firestoreとの同期
    private func syncUserWithFirestore(
        firebaseUID: String,
        context: ModelContext
    ) async throws -> UserProfile {
        print("🔄 Firestoreとの同期開始: UID = \(firebaseUID)")
        
        // Firestoreからデータ取得
        let document = try await db.collection("users").document(firebaseUID).getDocument()
        
        if document.exists {
            print("📄 Firestoreドキュメント取得成功")
            
            // Firestoreデータをデコード
            let data = document.data() ?? [:]
            let displayName = data["display_name"] as? String ?? "ゲスト"
            let iconUrl = data["icon_url"] as? String
            let lastLoginAt = (data["last_login_at"] as? Timestamp)?.dateValue() ?? Date()
            let createdAt = (data["created_at"] as? Timestamp)?.dateValue() ?? Date()
            
            // ローカルプロファイルを取得または作成
            let descriptor = FetchDescriptor<UserProfile>(
                predicate: #Predicate { $0.firebaseUID == firebaseUID }
            )
            
            if let existingProfile = try context.fetch(descriptor).first {
                // 既存プロファイルを更新
                existingProfile.displayName = displayName
                existingProfile.iconUrl = iconUrl
                existingProfile.lastLoginAt = Date()
                
                // Firestoreの最終ログイン時刻を更新
                try await db.collection("users").document(firebaseUID).updateData([
                    "last_login_at": Timestamp(date: Date())
                ])
                
                try context.save()
                print("✅ 既存プロファイル更新完了")
                return existingProfile
            } else {
                // 新規プロファイル作成（Firestoreには既にデータがある場合）
                let newProfile = UserProfile(
                    firebaseUID: firebaseUID,
                    displayName: displayName,
                    iconUrl: iconUrl,
                    createdAt: createdAt,
                    lastLoginAt: Date()
                )
                
                context.insert(newProfile)
                
                // Firestoreの最終ログイン時刻を更新
                try await db.collection("users").document(firebaseUID).updateData([
                    "last_login_at": Timestamp(date: Date())
                ])
                
                try context.save()
                print("✅ 新規ローカルプロファイル作成完了")
                return newProfile
            }
        } else {
            // Firestoreにデータがない場合は新規作成
            print("⚠️ Firestoreにデータが存在しないため新規作成")
            return try await createUserInFirestore(firebaseUID: firebaseUID, context: context)
        }
    }
}