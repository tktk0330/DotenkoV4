//
//  OptionContentView.swift
//  DotenkoV4
//
//  Option画面のメインビュー
//

import SwiftUI

/// ゲーム設定オプション画面のメインビュー
/// グリッドレイアウトで設定カードを表示し、モーダルで設定変更が可能
struct OptionContentView: View {
    // MARK: - Properties
    @StateObject private var gameSettings = GameSettings.shared
    @State private var selectedSetting: GameSettingType?
    @State private var showingSettingModal = false
    
    // MARK: - Constants
    private let gridColumns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    private let cardSpacing: CGFloat = 16
    private let horizontalPadding: CGFloat = 16
    
    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                headerView
                settingCardsGrid
            }
        }
        .overlay {
            if showingSettingModal, let setting = selectedSetting {
                settingModal(for: setting)
            }
        }
    }
    
    // MARK: - Header View
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
    
    // MARK: - Setting Cards Grid
    private var settingCardsGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: cardSpacing) {
            ForEach(GameSettingType.allCases) { setting in
                GameSettingCard(
                    setting: setting,
                    currentValue: gameSettings.currentValue(for: setting),
                    displayValue: gameSettings.displayValue(
                        for: setting,
                        value: gameSettings.currentValue(for: setting)
                    )
                ) {
                    showSettingModal(for: setting)
                }
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.bottom, 30)
    }
    
    // MARK: - Setting Modal
    private func settingModal(for setting: GameSettingType) -> some View {
        GameSettingSelectionView(
            setting: setting,
            gameSettings: gameSettings,
            isPresented: $showingSettingModal
        )
        .zIndex(1)
    }
    
    // MARK: - Actions
    /// 設定モーダルを表示する
    private func showSettingModal(for setting: GameSettingType) {
        selectedSetting = setting
        showingSettingModal = true
    }
}

#Preview {
    OptionContentView()
        .background(AppGradients.primaryBackground)
}