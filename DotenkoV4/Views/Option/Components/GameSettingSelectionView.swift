//
//  GameSettingSelectionView.swift
//  DotenkoV4
//
//  ゲーム設定選択モーダルビュー
//

import SwiftUI

/// ゲーム設定を変更するためのモーダルビュー
/// 選択肢を横スクロールで表示し、タップで選択できる
struct GameSettingSelectionView: View {
    // MARK: - Properties
    let setting: GameSettingType
    let gameSettings: GameSettings
    @Binding var isPresented: Bool
    
    @State private var selectedValue: Int
    
    // MARK: - Initializer
    init(setting: GameSettingType, gameSettings: GameSettings, isPresented: Binding<Bool>) {
        self.setting = setting
        self.gameSettings = gameSettings
        self._isPresented = isPresented
        self._selectedValue = State(initialValue: gameSettings.currentValue(for: setting))
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // 背景オーバーレイ（タップでモーダルを閉じる）
            backgroundOverlay
            
            // メインモーダルコンテンツ
            modalContent
        }
        .animation(.interpolatingSpring(stiffness: 300, damping: 25), value: isPresented)
    }
    
    // MARK: - Background Overlay
    private var backgroundOverlay: some View {
        Color.black.opacity(0.7)
            .ignoresSafeArea()
            .onTapGesture {
                dismiss()
            }
    }
    
    // MARK: - Modal Content
    private var modalContent: some View {
        VStack(spacing: 0) {
            titleSection
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 24)
            
            optionsSection
                .padding(.bottom, 24)
            
            buttonsSection
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
        .background(modalBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(modalBorder)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: -10)
        .frame(maxHeight: UIScreen.main.bounds.height * 0.45)
        .position(
            x: UIScreen.main.bounds.width / 2,
            y: UIScreen.main.bounds.height * 0.5
        )
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    // MARK: - Modal Background
    private var modalBackground: some View {
        LinearGradient(
            colors: [
                Color(red: 0.15, green: 0.2, blue: 0.15),
                Color(red: 0.08, green: 0.12, blue: 0.08)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - Modal Border
    private var modalBorder: some View {
        RoundedRectangle(cornerRadius: 24)
            .stroke(
                LinearGradient(
                    colors: [
                        AppColors.cardWhite.opacity(0.3),
                        AppColors.cardWhite.opacity(0.1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 1.5
            )
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        VStack(spacing: 12) {
            titleHeader
            settingDescription
            currentValueDisplay
        }
    }
    
    /// タイトルヘッダー（アイコンと設定名）
    private var titleHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: setting.icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(AppGradients.logoGradient)
            
            Text(setting.rawValue)
                .font(AppFonts.gothicHeadline(24))
                .fontWeight(.bold)
                .foregroundColor(AppColors.cardWhite)
        }
    }
    
    /// 設定の説明文
    private var settingDescription: some View {
        Text(setting.description)
            .font(AppFonts.gothicBody(14))
            .foregroundColor(AppColors.cardWhite.opacity(0.7))
            .multilineTextAlignment(.center)
    }
    
    /// 現在の設定値表示
    private var currentValueDisplay: some View {
        HStack(spacing: 8) {
            Text("現在の設定:")
                .font(AppFonts.gothicCaption(12))
                .foregroundColor(AppColors.cardWhite.opacity(0.6))
            
            Text(gameSettings.displayValue(
                for: setting,
                value: gameSettings.currentValue(for: setting)
            ))
            .font(AppFonts.gothicHeadline(16))
            .fontWeight(.bold)
            .foregroundStyle(AppGradients.logoGradient)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardWhite.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Options Section
    private var optionsSection: some View {
        let options = gameSettings.availableOptions(for: setting)
        
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(options, id: \.self) { value in
                    OptionButton(
                        value: value,
                        displayValue: gameSettings.displayValue(for: setting, value: value),
                        isSelected: selectedValue == value
                    ) {
                        selectOption(value)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .frame(height: 80)
    }
    
    // MARK: - Buttons Section
    private var buttonsSection: some View {
        HStack(spacing: 12) {
            cancelButton
            confirmButton
        }
    }
    
    /// キャンセルボタン
    private var cancelButton: some View {
        Button(action: dismiss) {
            Text("キャンセル")
                .font(AppFonts.gothicBody(16))
                .fontWeight(.medium)
                .foregroundColor(AppColors.cardWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppColors.cardWhite.opacity(0.3), lineWidth: 1)
                        )
                )
        }
    }
    
    /// 決定ボタン
    private var confirmButton: some View {
        Button(action: save) {
            Text("決定")
                .font(AppFonts.gothicBody(16))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppGradients.logoGradient)
                        .shadow(
                            color: AppColors.brightYellow.opacity(0.3),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                )
        }
    }
    
    // MARK: - Actions
    /// オプションを選択した時の処理
    private func selectOption(_ value: Int) {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedValue = value
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    /// モーダルを閉じる（キャンセル）
    private func dismiss() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        isPresented = false
    }
    
    /// 設定を保存してモーダルを閉じる
    private func save() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        gameSettings.updateValue(for: setting, value: selectedValue)
        isPresented = false
    }
}

// MARK: - Option Button Component
/// 選択肢を表示するボタンコンポーネント
struct OptionButton: View {
    // MARK: - Properties
    let value: Int
    let displayValue: String
    let isSelected: Bool
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            Text(displayValue)
                .font(AppFonts.gothicHeadline(18))
                .fontWeight(isSelected ? .bold : .medium)
                .foregroundColor(isSelected ? .black : AppColors.cardWhite)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(buttonBackground)
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .shadow(
                    color: isSelected ? AppColors.brightYellow.opacity(0.3) : Color.clear,
                    radius: 8,
                    x: 0,
                    y: 4
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Button Background
    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                isSelected ?
                AnyShapeStyle(AppGradients.logoGradient) :
                AnyShapeStyle(Color.black.opacity(0.3))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ?
                        Color.clear :
                        AppColors.cardWhite.opacity(0.2),
                        lineWidth: 1
                    )
            )
    }
}

#Preview {
    ZStack {
        AppGradients.primaryBackground
            .ignoresSafeArea()
        
        VStack {
            Button("Show Modal") {
                // Preview action
            }
        }
        .sheet(isPresented: .constant(true)) {
            GameSettingSelectionView(
                setting: .scoreLimit,
                gameSettings: GameSettings.shared,
                isPresented: .constant(true)
            )
        }
    }
}