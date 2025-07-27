//
//  ImageCacheManager.swift
//  DotenkoV4
//
//  画像キャッシュマネージャー
//  プロフィール画像のキャッシュとプリロード機能
//

import Foundation
import UIKit
import SwiftUI

@MainActor
class ImageCacheManager: ObservableObject {
    // MARK: - シングルトン
    static let shared = ImageCacheManager()
    
    // MARK: - プロパティ
    @Published var profileImages: [String: UIImage] = [:]
    private var downloadTasks: [String: Task<UIImage?, Never>] = [:]
    
    // MARK: - イニシャライザ
    private init() {}
    
    // MARK: - プロフィール画像取得
    func getProfileImage(for userId: String, iconUrl: String?) -> UIImage? {
        // キャッシュから取得
        if let cachedImage = profileImages[userId] {
            return cachedImage
        }
        
        // キャッシュにない場合はバックグラウンドで読み込み開始
        if let iconUrl = iconUrl, !iconUrl.isEmpty {
            loadImageInBackground(userId: userId, iconUrl: iconUrl)
        }
        
        return nil
    }
    
    // MARK: - プロフィール画像プリロード
    func preloadProfileImage(userId: String, iconUrl: String?) async {
        guard let iconUrl = iconUrl, !iconUrl.isEmpty else { return }
        
        // 既にキャッシュされている場合はスキップ
        if profileImages[userId] != nil {
            print("✅ 画像キャッシュ済み: \(userId)")
            return
        }
        
        // 既にダウンロード中の場合は待機
        if let existingTask = downloadTasks[userId] {
            _ = await existingTask.value
            return
        }
        
        print("🔄 プロフィール画像プリロード開始: \(userId)")
        
        let task = Task<UIImage?, Never> {
            do {
                let image = try await FirebaseStorageManager.shared.downloadProfileImage(from: iconUrl)
                
                await MainActor.run {
                    profileImages[userId] = image
                    downloadTasks.removeValue(forKey: userId)
                }
                
                print("✅ プロフィール画像プリロード完了: \(userId)")
                return image
                
            } catch {
                print("❌ プロフィール画像プリロードエラー: \(userId) - \(error)")
                
                await MainActor.run {
                    downloadTasks.removeValue(forKey: userId)
                }
                
                return nil
            }
        }
        
        downloadTasks[userId] = task
        _ = await task.value
    }
    
    // MARK: - バックグラウンド画像読み込み
    private func loadImageInBackground(userId: String, iconUrl: String) {
        // 既にダウンロード中の場合はスキップ
        guard downloadTasks[userId] == nil else { return }
        
        let task = Task<UIImage?, Never> {
            do {
                let image = try await FirebaseStorageManager.shared.downloadProfileImage(from: iconUrl)
                
                await MainActor.run {
                    profileImages[userId] = image
                    downloadTasks.removeValue(forKey: userId)
                }
                
                return image
                
            } catch {
                print("❌ バックグラウンド画像読み込みエラー: \(userId) - \(error)")
                
                await MainActor.run {
                    downloadTasks.removeValue(forKey: userId)
                }
                
                return nil
            }
        }
        
        downloadTasks[userId] = task
    }
    
    // MARK: - 画像キャッシュ更新
    func updateProfileImage(userId: String, image: UIImage) {
        profileImages[userId] = image
        print("✅ プロフィール画像キャッシュ更新: \(userId)")
    }
    
    // MARK: - 画像キャッシュ削除
    func removeProfileImage(userId: String) {
        profileImages.removeValue(forKey: userId)
        downloadTasks[userId]?.cancel()
        downloadTasks.removeValue(forKey: userId)
        print("🗑️ プロフィール画像キャッシュ削除: \(userId)")
    }
    
    // MARK: - 全キャッシュクリア
    func clearAllCache() {
        profileImages.removeAll()
        downloadTasks.values.forEach { $0.cancel() }
        downloadTasks.removeAll()
        print("🗑️ 全プロフィール画像キャッシュクリア")
    }
    
    // MARK: - キャッシュ状態確認
    func isCached(userId: String) -> Bool {
        return profileImages[userId] != nil
    }
    
    func isLoading(userId: String) -> Bool {
        return downloadTasks[userId] != nil
    }
}