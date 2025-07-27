//
//  HelpContentView.swift
//  DotenkoV4
//
//  ヘルプタブのコンテンツ
//

import SwiftUI

struct HelpContentView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                // 上部スペース
                Spacer()
                    .frame(height: 40)
                
                // ヘルプタイトル
                Text("HELP")
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
    HelpContentView()
        .background(AppGradients.primaryBackground)
}