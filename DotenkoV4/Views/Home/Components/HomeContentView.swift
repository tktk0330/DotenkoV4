//
//  HomeContentView.swift
//  DotenkoV4
//
//  ホームタブのコンテンツ（プレイヤー数選択、ゲームモード選択）
//

import SwiftUI

struct HomeContentView: View {
    @State private var selectedPlayerCount: Int = 3
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                // 上部スペース
                Spacer()
                    .frame(height: 20)
                
                // プロフィールセクション
                ProfileSectionView()
                
                // プレイヤー数選択
                PlayerCountSelectionView(
                    selectedPlayerCount: $selectedPlayerCount
                )
                
                // ゲームモード選択
                GameModeSelectionView()
                
                // 下部スペース
                Spacer()
                    .frame(height: 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

#Preview {
    HomeContentView()
        .background(AppGradients.primaryBackground)
}