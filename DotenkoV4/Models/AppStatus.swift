//
//  AppStatus.swift
//  DotenkoV4
//
//  Firestore app_status_master->app_status コレクションのデータモデル
//

import Foundation
import FirebaseFirestore

struct AppStatus: Codable {
    let maintenanceFlag: Bool
    let minIosVer: String
    
    // Firestoreのフィールド名マッピング
    enum CodingKeys: String, CodingKey {
        case maintenanceFlag = "maintenance_flag"
        case minIosVer = "min_ios_ver"
    }
    
    // デフォルト値を持つイニシャライザ
    init(
        maintenanceFlag: Bool = false,
        minIosVer: String = "1.0.0"
    ) {
        self.maintenanceFlag = maintenanceFlag
        self.minIosVer = minIosVer
    }
    
    // バージョン比較用メソッド
    func isCurrentVersionSupported(currentVersion: String) -> Bool {
        return compareVersions(currentVersion, minIosVer) >= 0
    }
    
    // バージョン文字列比較（例: "1.2.3" vs "1.1.0"）
    private func compareVersions(_ version1: String, _ version2: String) -> Int {
        let v1Components = version1.components(separatedBy: ".").compactMap { Int($0) }
        let v2Components = version2.components(separatedBy: ".").compactMap { Int($0) }
        
        let maxCount = max(v1Components.count, v2Components.count)
        
        for i in 0..<maxCount {
            let v1Value = i < v1Components.count ? v1Components[i] : 0
            let v2Value = i < v2Components.count ? v2Components[i] : 0
            
            if v1Value < v2Value {
                return -1
            } else if v1Value > v2Value {
                return 1
            }
        }
        
        return 0
    }
}