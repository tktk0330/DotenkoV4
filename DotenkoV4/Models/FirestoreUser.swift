//
//  FirestoreUser.swift
//  DotenkoV4
//
//  Firestore users コレクションのデータモデル
//

import Foundation
import FirebaseFirestore

struct FirestoreUser: Codable {
    let uid: String
    var displayName: String
    var iconUrl: String?
    var lastLoginAt: Date
    var createdAt: Date
    
    // Firestoreのフィールド名マッピング
    enum CodingKeys: String, CodingKey {
        case uid
        case displayName = "display_name"
        case iconUrl = "icon_url"
        case lastLoginAt = "last_login_at"
        case createdAt = "created_at"
    }
    
    // デフォルト値を持つイニシャライザ
    init(
        uid: String,
        displayName: String = "ゲスト",
        iconUrl: String? = nil,
        lastLoginAt: Date = Date(),
        createdAt: Date = Date()
    ) {
        self.uid = uid
        self.displayName = displayName
        self.iconUrl = iconUrl
        self.lastLoginAt = lastLoginAt
        self.createdAt = createdAt
    }
    
    // Firestoreに保存する辞書形式に変換
    var asDictionary: [String: Any] {
        return [
            "uid": uid,
            "display_name": displayName,
            "icon_url": iconUrl as Any,
            "last_login_at": Timestamp(date: lastLoginAt),
            "created_at": Timestamp(date: createdAt)
        ]
    }
}