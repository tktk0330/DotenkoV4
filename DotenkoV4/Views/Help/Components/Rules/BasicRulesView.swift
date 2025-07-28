//
//  BasicRulesView.swift
//  DotenkoV4
//
//  基本ルール説明ビュー
//

import SwiftUI

struct BasicRulesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ruleSection(
                title: "ゲームの目的",
                content: "DOTENKOは、全てのカードを早く出し切ることを目指すカードゲームです。",
                imageName: "crown.fill"
            )
            
            ruleSection(
                title: "カードの強さ",
                content: "ジョーカー > 2 > A > K > Q > J > 10 > ... > 3\n同じ数字の場合は、スペード > ハート > ダイヤ > クラブの順で強さが決まります。"
            )
            
            // カードの強さのビジュアル表示
            cardStrengthVisual
            
            ruleSection(
                title: "革命",
                content: "同じ数字を4枚出すと革命が発生し、カードの強さが逆転します。\n革命中は 3 > 4 > ... > K > A > 2 > ジョーカーの順になります。",
                imageName: "arrow.triangle.2.circlepath"
            )
        }
    }
    
    private var cardStrengthVisual: some View {
        VStack(spacing: 12) {
            Text("最強カードの例")
                .font(AppFonts.gothicCaption(14))
                .foregroundColor(AppColors.cardWhite.opacity(0.8))
            
            HStack(spacing: 16) {
                // ジョーカー
                Image("joker")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                
                Text(">")
                    .font(AppFonts.gothicHeadline(24))
                    .foregroundColor(AppColors.brightYellow)
                
                // スペードの2
                Image("s02")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
            }
            .shadow(radius: 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.2))
        )
    }
    
    private func ruleSection(title: String, content: String, imageName: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let imageName = imageName {
                    Image(systemName: imageName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppColors.brightYellow)
                }
                
                Text(title)
                    .font(AppFonts.gothicHeadline(18))
                    .foregroundColor(AppColors.brightYellow)
            }
            
            Text(content)
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite)
                .lineSpacing(4)
        }
        .padding()
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