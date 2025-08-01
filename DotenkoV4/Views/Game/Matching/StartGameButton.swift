//
//  StartGameButton.swift
//  DotenkoV4
//
//  ゲーム開始ボタンコンポーネント
//  - プライマリアクションボタンのスタイル
//

import SwiftUI

// MARK: - ゲーム開始ボタン
struct StartGameButton: View {
    // MARK: - プロパティ
    let onTapped: () -> Void               // ボタンタップ処理
    
    // MARK: - ボディ
    var body: some View {
        Button(action: onTapped) {
            HStack {
                Image(systemName: "play.fill")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("ゲーム開始")
                    .font(AppFonts.gothicHeadline(18))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(AppGradients.logoGradient)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: AppColors.accentText.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - プレビュー
#Preview {
    VStack(spacing: 20) {
        StartGameButton(onTapped: {})
        
        StartGameButton(onTapped: {})
            .disabled(true)
    }
    .padding()
    .background(AppColors.primaryBackground)
}