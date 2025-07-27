//
//  AppStatusManager.swift
//  DotenkoV4
//
//  アプリステータス管理クラス
//  メンテナンス情報と最低iOSバージョンをFirestoreから取得
//

import Foundation
import FirebaseFirestore

@MainActor
class AppStatusManager: ObservableObject {
    // MARK: - シングルトン
    static let shared = AppStatusManager()
    
    // MARK: - プロパティ
    @Published var appStatus: AppStatus?
    @Published var isLoading = false
    @Published var statusError: StatusError?
    
    private let db = Firestore.firestore()
    
    // MARK: - エラー定義
    enum StatusError: LocalizedError {
        case networkError
        case dataNotFound
        case invalidData
        case unknown(Error)
        
        var errorDescription: String? {
            switch self {
            case .networkError:
                return "ネットワーク接続エラー"
            case .dataNotFound:
                return "アプリステータス情報が見つかりません"
            case .invalidData:
                return "データ形式が正しくありません"
            case .unknown(let error):
                return error.localizedDescription
            }
        }
        
        var recoverySuggestion: String? {
            switch self {
            case .networkError:
                return "インターネット接続を確認してください"
            case .dataNotFound:
                return "しばらく待ってからお試しください"
            case .invalidData:
                return "アプリを再起動してください"
            case .unknown:
                return "しばらく待ってからお試しください"
            }
        }
    }
    
    // MARK: - イニシャライザ
    private init() {}
    
    // MARK: - アプリステータス取得
    func fetchAppStatus() async throws -> AppStatus {
        isLoading = true
        statusError = nil
        
        print("🔄 アプリステータス取得開始")
        
        do {
            // Firestoreからapp_status_master->app_statusドキュメント取得
// Extract Firestore paths into a private constant enum
private enum FirestoreConstants {
    static let appStatusCollection = "app_status_master"
    static let appStatusDocument   = "app_status"
}

// Then update the fetch call:
let document = try await db
    .collection(FirestoreConstants.appStatusCollection)
    .document(FirestoreConstants.appStatusDocument)
    .getDocument()
            
            if document.exists {
                print("📄 アプリステータスドキュメント取得成功")
                
                // ドキュメントデータをデコード
                let data = document.data() ?? [:]
                let maintenanceFlag = data["maintenance_flag"] as? Bool ?? false
                let minIosVer = data["min_ios_ver"] as? String ?? "1.0.0"
                
                let status = AppStatus(
                    maintenanceFlag: maintenanceFlag,
                    minIosVer: minIosVer
                )
                
                // ログ出力
                print("✅ アプリステータス取得完了:")
                print("   - メンテナンスフラグ: \(maintenanceFlag)")
                print("   - 最小iOSバージョン: \(minIosVer)")
                
                // 現在のアプリバージョンと比較
                let currentVersion = getCurrentAppVersion()
                let isSupported = status.isCurrentVersionSupported(currentVersion: currentVersion)
                print("   - 現在のアプリバージョン: \(currentVersion)")
                print("   - バージョンサポート状況: \(isSupported ? "サポート中" : "要アップデート")")
                
                self.appStatus = status
                isLoading = false
                return status
                
            } else {
                print("⚠️ アプリステータスドキュメントが存在しません")
                statusError = .dataNotFound
                isLoading = false
                throw StatusError.dataNotFound
            }
            
        } catch let error as NSError {
            isLoading = false
            
            // エラーハンドリング
            if error.domain == "FIRFirestoreErrorDomain" {
                if error.code == 14 { // UNAVAILABLE
                    statusError = .networkError
                    throw StatusError.networkError
                } else {
                    statusError = .unknown(error)
                    throw StatusError.unknown(error)
                }
            } else {
                statusError = .unknown(error)
                throw StatusError.unknown(error)
            }
        }
    }
    
    // MARK: - 現在のアプリバージョン取得
    private func getCurrentAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0.0" // デフォルト値
    }
    
    // MARK: - メンテナンス状態チェック
    func isMaintenanceMode() -> Bool {
        return appStatus?.maintenanceFlag ?? false
    }
    
    // MARK: - バージョンサポート状況チェック
    func isCurrentVersionSupported() -> Bool {
        guard let status = appStatus else { return true }
        let currentVersion = getCurrentAppVersion()
        return status.isCurrentVersionSupported(currentVersion: currentVersion)
    }
}