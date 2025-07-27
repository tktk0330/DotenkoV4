//
//  OptionContentView.swift
//  DotenkoV4
//
//  オプションタブのコンテンツ
//

import SwiftUI

struct OptionContentView: View {
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                // 上部スペース
                Spacer()
                    .frame(height: 40)
                
                // オプションタイトル
                Text("OPTION")
                    .font(AppFonts.elegantHeadline(32))
                    .foregroundStyle(AppGradients.logoGradient)
                
                // 下部スペース
                Spacer()
                    .frame(height: 40)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    OptionContentView()
        .background(AppGradients.primaryBackground)
}