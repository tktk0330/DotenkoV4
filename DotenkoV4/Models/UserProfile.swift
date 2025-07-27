//
//  UserProfile.swift
//  DotenkoV4
//
//  ユーザープロファイルデータモデル（SwiftData）
//  匿名認証ユーザーの基本情報を管理
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    // MARK: - プロパティ
    var firebaseUID: String
    var displayName: String
    var iconName: String
    var iconUrl: String?  // Firestoreから取得したアイコンURL
    var createdAt: Date
    var lastLoginAt: Date
    
    // MARK: - イニシャライザ
    init(
        firebaseUID: String,
        displayName: String = "ゲスト",
        iconName: String = "person.circle.fill",
        iconUrl: String? = nil,
        createdAt: Date = Date(),
        lastLoginAt: Date = Date()
    ) {
        self.firebaseUID = firebaseUID
        self.displayName = displayName
        self.iconName = iconName
        self.iconUrl = iconUrl
        self.createdAt = createdAt
        self.lastLoginAt = lastLoginAt
    }
    
    // MARK: - メソッド
    func updateLastLogin() {
        self.lastLoginAt = Date()
    }
    
    func updateDisplayName(_ newName: String) {
        self.displayName = newName
    }
    
    func updateIcon(_ iconName: String) {
        self.iconName = iconName
    }
}

// MARK: - デフォルトアイコンリスト
extension UserProfile {
    static let defaultIcons = [
        "person.circle.fill",
        "star.circle.fill",
        "heart.circle.fill",
        "suit.spade.fill",
        "suit.heart.fill",
        "suit.diamond.fill",
        "suit.club.fill",
        "crown.fill",
        "sparkles"
    ]
}