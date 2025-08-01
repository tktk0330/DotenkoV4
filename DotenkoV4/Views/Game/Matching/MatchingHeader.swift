//
//  MatchingHeader.swift
//  DotenkoV4
//
//  マッチング画面ヘッダーコンポーネント
//  - 戻るボタンとタイトル表示
//

import SwiftUI

// MARK: - マッチングヘッダー
struct MatchingHeader: View {
    // MARK: - プロパティ
    let onBackTapped: () -> Void            // 戻るボタンタップ処理
    
    // MARK: - ボディ
    var body: some View {
        HStack {
            // 戻るボタン
            backButton
            
            Spacer()
            
            // タイトル
            titleText
            
            Spacer()
            
            // 右側スペース確保（視覚的バランス）
            backButton.opacity(0)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(AppColors.primaryBackground)
    }
    
    // MARK: - 戻るボタン
    private var backButton: some View {
        Button(action: onBackTapped) {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(AppColors.accentText)
        }
    }
    
    // MARK: - タイトルテキスト
    private var titleText: some View {
        Text("対戦準備")
            .font(AppFonts.gothicHeadline(20))
            .foregroundStyle(AppColors.primaryText)
    }
}

// MARK: - プレビュー
#Preview {
    MatchingHeader(onBackTapped: {})
        .background(AppColors.primaryBackground)
}