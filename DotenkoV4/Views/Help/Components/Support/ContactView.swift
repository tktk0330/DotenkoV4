//
//  ContactView.swift
//  DotenkoV4
//
//  お問い合わせビュー
//

import SwiftUI

struct ContactView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("お問い合わせやご要望は以下からお願いします")
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite)
                .multilineTextAlignment(.center)
            
            contactButton
            
            contactInfo
        }
        .padding(.vertical, 40)
    }
    
    private var contactButton: some View {
        Button {
            // メールアプリを開く
            if let url = URL(string: "mailto:support@dotenko.app") {
                UIApplication.shared.open(url)
            }
        } label: {
            Label("メールで問い合わせ", systemImage: "envelope.fill")
                .font(AppFonts.gothicHeadline(18))
                .foregroundColor(.black)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(AppGradients.logoGradient)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(color: AppColors.brightYellow.opacity(0.3), radius: 8)
        }
    }
    
    private var contactInfo: some View {
        VStack(spacing: 8) {
            Text("Twitter: @dotenko_app")
                .font(AppFonts.gothicBody(14))
                .foregroundColor(AppColors.cardWhite.opacity(0.8))
            
            Text("対応時間: 平日 10:00-18:00")
                .font(AppFonts.gothicCaption(12))
                .foregroundColor(AppColors.cardWhite.opacity(0.6))
        }
        .padding(.top, 20)
    }
}