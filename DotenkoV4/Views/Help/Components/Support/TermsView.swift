//
//  TermsView.swift
//  DotenkoV4
//
//  利用規約ビュー
//

import SwiftUI

struct TermsView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("利用規約の詳細は以下のリンクからご確認ください")
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite)
                .multilineTextAlignment(.center)
            
            termsButton
            
            lastUpdatedInfo
        }
        .padding(.vertical, 40)
    }
    
    private var termsButton: some View {
        Button {
            // SafariでWebページを開く
            if let url = URL(string: "https://dotenko.app/terms") {
                UIApplication.shared.open(url)
            }
        } label: {
            Label("利用規約を見る", systemImage: "doc.text.fill")
                .font(AppFonts.gothicHeadline(18))
                .foregroundColor(.black)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(AppGradients.logoGradient)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(color: AppColors.brightYellow.opacity(0.3), radius: 8)
        }
    }
    
    private var lastUpdatedInfo: some View {
        Text("最終更新日: 2024年1月1日")
            .font(AppFonts.gothicCaption(12))
            .foregroundColor(AppColors.cardWhite.opacity(0.6))
            .padding(.top, 20)
    }
}