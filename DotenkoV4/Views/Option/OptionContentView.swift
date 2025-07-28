//
//  OptionContentView.swift
//  DotenkoV4
//
//  Option画面のメインビュー
//

import SwiftUI

struct OptionContentView: View {
    @StateObject private var gameSettings = GameSettings.shared
    @State private var selectedSetting: GameSettingType?
    @State private var showingSettingModal = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // ヘッダー
                headerView
                
                // 設定カードグリッド
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(GameSettingType.allCases) { setting in
                        GameSettingCard(
                            setting: setting,
                            currentValue: gameSettings.currentValue(for: setting),
                            displayValue: gameSettings.displayValue(for: setting, value: gameSettings.currentValue(for: setting))
                        ) {
                            selectedSetting = setting
                            showingSettingModal = true
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
        }
        .overlay {
            if showingSettingModal, let setting = selectedSetting {
                GameSettingSelectionView(
                    setting: setting,
                    gameSettings: gameSettings,
                    isPresented: $showingSettingModal
                )
                .zIndex(1)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("OPTION")
                .font(AppFonts.elegantHeadline(36))
                .fontWeight(.bold)
                .foregroundStyle(AppGradients.logoGradient)
            
            Text("ゲーム設定")
                .font(AppFonts.gothicBody(14))
                .foregroundColor(AppColors.cardWhite.opacity(0.8))
        }
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
}

#Preview {
    OptionContentView()
        .background(AppGradients.primaryBackground)
}