//
//  FirebaseStorageManager.swift
//  DotenkoV4
//
//  Firebase Storage管理クラス
//  ユーザープロフィール画像のアップロード・ダウンロード管理
//

import Foundation
import FirebaseStorage
import UIKit

@MainActor
class FirebaseStorageManager: ObservableObject {
    // MARK: - シングルトン
    static let shared = FirebaseStorageManager()
    
    // MARK: - プロパティ
    private let storage = Storage.storage()
    private let storageRef: StorageReference
    
    // MARK: - エラー定義
    enum StorageError: LocalizedError {
        case imageCompressionFailed
        case uploadFailed(Error)
        case downloadFailed(Error)
        case invalidImageData
        case invalidURL
        
        var errorDescription: String? {
            switch self {
            case .imageCompressionFailed:
                return "画像の圧縮に失敗しました"
            case .uploadFailed(let error):
                return "アップロードエラー: \(error.localizedDescription)"
            case .downloadFailed(let error):
                return "ダウンロードエラー: \(error.localizedDescription)"
            case .invalidImageData:
                return "無効な画像データです"
            case .invalidURL:
                return "無効なURLです"
            }
        }
    }
    
    // MARK: - イニシャライザ
    private init() {
        self.storageRef = storage.reference()
    }
    
    // MARK: - プロフィール画像アップロード
    func uploadProfileImage(
        image: UIImage,
        userId: String
    ) async throws -> String {
        print("🔄 プロフィール画像アップロード開始")
        print("   - ユーザーID: \(userId)")
        print("   - 元画像サイズ: \(image.size)")
        
        // 画像を最適化（リサイズ + 圧縮）
        let optimizedImage = optimizeImageForUpload(image)
        guard let imageData = optimizedImage.jpegData(compressionQuality: 0.7) else {
            throw StorageError.imageCompressionFailed
        }
        
        // ファイル参照を作成
        let fileName = "profile_\(userId)_\(Date().timeIntervalSince1970).jpg"
        let profileImageRef = storageRef.child("profile_images").child(fileName)
        
        print("   - ファイル名: \(fileName)")
        print("   - データサイズ: \(imageData.count) bytes")
        
        do {
            // メタデータを設定
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            metadata.customMetadata = [
                "userId": userId,
                "uploadedAt": ISO8601DateFormatter().string(from: Date())
            ]
            
            // Firebase Storageにアップロード
            let _ = try await profileImageRef.putDataAsync(imageData, metadata: metadata)
            
            // ダウンロードURLを取得
            let downloadURL = try await profileImageRef.downloadURL()
            
            print("✅ プロフィール画像アップロード完了")
            print("   - ダウンロードURL: \(downloadURL.absoluteString)")
            
            return downloadURL.absoluteString
            
        } catch {
            print("❌ プロフィール画像アップロードエラー: \(error)")
            throw StorageError.uploadFailed(error)
        }
    }
    
    // MARK: - プロフィール画像ダウンロード
    func downloadProfileImage(from urlString: String) async throws -> UIImage {
        print("🔄 プロフィール画像ダウンロード開始")
        print("   - URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            throw StorageError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else {
                throw StorageError.invalidImageData
            }
            
            print("✅ プロフィール画像ダウンロード完了")
            return image
            
        } catch {
            print("❌ プロフィール画像ダウンロードエラー: \(error)")
            throw StorageError.downloadFailed(error)
        }
    }
    
    // MARK: - 古いプロフィール画像削除
    func deleteOldProfileImage(from urlString: String) async {
        print("🔄 古いプロフィール画像削除開始")
        print("   - URL: \(urlString)")
        
        // Firebase StorageのURLからファイルパスを抽出
        guard let url = URL(string: urlString),
              let path = extractStoragePath(from: url) else {
            print("⚠️ 無効なURLのため削除をスキップ")
            return
        }
        
        let fileRef = storageRef.child(path)
        
        do {
            try await fileRef.delete()
            print("✅ 古いプロフィール画像削除完了")
        } catch {
            print("⚠️ 古いプロフィール画像削除エラー（継続）: \(error)")
            // 削除に失敗してもアプリの動作は継続
        }
    }
    
    // MARK: - 画像最適化
    private func optimizeImageForUpload(_ image: UIImage) -> UIImage {
        // プロフィール画像のターゲットサイズ（正方形）
        let targetSize = CGSize(width: 400, height: 400)
        
        print("   - 最適化前サイズ: \(image.size)")
        
        // アスペクト比を保ちながらリサイズ
        let resizedImage = resizeImage(image, to: targetSize)
        
        print("   - 最適化後サイズ: \(resizedImage.size)")
        
        return resizedImage
    }
    
    private func resizeImage(_ image: UIImage, to targetSize: CGSize) -> UIImage {
        let size = image.size
        
        // アスペクト比を計算
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        // より小さい比率を使用してアスペクト比を保持
        let ratio = min(widthRatio, heightRatio)
        
        // 新しいサイズを計算
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        // 画像を描画してリサイズ
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage ?? image
    }
    
    // MARK: - ヘルパーメソッド
    private func extractStoragePath(from url: URL) -> String? {
        // Firebase StorageのURLからファイルパスを抽出
        // 例: https://firebasestorage.googleapis.com/v0/b/bucket/o/profile_images%2Ffile.jpg
        let pathComponents = url.pathComponents
        
        if let oIndex = pathComponents.firstIndex(of: "o"),
           oIndex + 1 < pathComponents.count {
            let encodedPath = pathComponents[(oIndex + 1)...]
            let fullPath = encodedPath.joined(separator: "/")
            return fullPath.removingPercentEncoding
        }
        
        return nil
    }
}