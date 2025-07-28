//
//  HowToStartView.swift
//  DotenkoV4
//
//  ゲームの始め方説明ビュー
//

import SwiftUI

struct HowToStartView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            stepCard(
                number: 1,
                title: "プレイヤー数を選択",
                content: "2〜5人でプレイできます。HOME画面でプレイヤー数を選択してください。",
                cardImages: ["back-1", "back-2", "back-3"]
            )
            
            stepCard(
                number: 2,
                title: "ルール設定",
                content: "ローカルルールや詳細設定を行います。初心者の方はデフォルト設定がおすすめです。"
            )
            
            stepCard(
                number: 3,
                title: "ゲーム開始",
                content: "「START」ボタンをタップしてゲームを開始します。カードが自動的に配られます。",
                cardImages: ["c03", "h10", "d08"]
            )
        }
    }
    
    private func stepCard(number: Int, title: String, content: String, cardImages: [String] = []) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                // ステップ番号
                Text("\(number)")
                    .font(AppFonts.gothicHeadline(24))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(AppGradients.logoGradient)
                    )
                
                Text(title)
                    .font(AppFonts.gothicHeadline(18))
                    .foregroundColor(AppColors.brightYellow)
            }
            
            Text(content)
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite)
                .lineSpacing(4)
            
            if !cardImages.isEmpty {
                HStack(spacing: -20) {
                    ForEach(cardImages.indices, id: \.self) { index in
                        Image(cardImages[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .shadow(radius: 4)
                            .rotationEffect(.degrees(Double(index - 1) * 10))
                            .zIndex(Double(cardImages.count - index))
                    }
                }
                .padding(.leading, 30)
                .padding(.top, 8)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardWhite.opacity(0.2), lineWidth: 1)
                )
        )
    }
}