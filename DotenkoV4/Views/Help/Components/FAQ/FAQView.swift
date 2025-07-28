//
//  FAQView.swift
//  DotenkoV4
//
//  よくある質問ビュー
//

import SwiftUI

struct FAQView: View {
    var body: some View {
        VStack(spacing: 20) {
            faqItem(
                question: "革命はいつ解除されますか？",
                answer: "ゲームが終了するまで続きます。ただし、再度4枚出しで革命を起こすと元に戻ります。"
            )
            
            faqItem(
                question: "ジョーカーは何枚でも出せますか？",
                answer: "ジョーカーは1枚ずつしか出せません。複数枚同時に出すことはできません。"
            )
            
            faqItem(
                question: "パスした後も出せますか？",
                answer: "場が流れるまではパスした後も出すことができます。"
            )
            
            faqItem(
                question: "8切りとは何ですか？",
                answer: "8を出すと強制的に場が流れるルールです。設定で有効/無効を切り替えられます。"
            )
        }
    }
    
    private func faqItem(question: String, answer: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.brightYellow)
                
                Text(question)
                    .font(AppFonts.gothicHeadline(16))
                    .foregroundColor(AppColors.cardWhite)
            }
            
            Text(answer)
                .font(AppFonts.gothicBody(15))
                .foregroundColor(AppColors.cardWhite.opacity(0.9))
                .lineSpacing(4)
                .padding(.leading, 28)
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