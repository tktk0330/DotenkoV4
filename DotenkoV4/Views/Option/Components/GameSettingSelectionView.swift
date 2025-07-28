//
//  GameSettingSelectionView.swift
//  DotenkoV4
//
//  ゲーム設定選択モーダルビュー
//

import SwiftUI

struct GameSettingSelectionView: View {
    let setting: GameSettingType
    let gameSettings: GameSettings
    @Binding var isPresented: Bool
    
    @State private var selectedValue: Int
    
    init(setting: GameSettingType, gameSettings: GameSettings, isPresented: Binding<Bool>) {
        self.setting = setting
        self.gameSettings = gameSettings
        self._isPresented = isPresented
        self._selectedValue = State(initialValue: gameSettings.currentValue(for: setting))
    }
    
    var body: some View {
        ZStack {
            // 背景（タップで閉じる）
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            // モーダルコンテンツ
            VStack(spacing: 0) {
                // タイトルセクション
                titleSection
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                
                // 選択肢セクション
                optionsSection
                    .padding(.bottom, 24)
                
                // ボタンセクション
                buttonsSection
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.15, green: 0.2, blue: 0.15),
                                Color(red: 0.08, green: 0.12, blue: 0.08)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
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
            )
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: -10)
            .frame(maxHeight: UIScreen.main.bounds.height * 0.45)
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.5)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
        .animation(.interpolatingSpring(stiffness: 300, damping: 25), value: isPresented)
    }
    
    // MARK: - タイトルセクション
    private var titleSection: some View {
        VStack(spacing: 12) {
            // アイコンとタイトル
            HStack(spacing: 12) {
                Image(systemName: setting.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(AppGradients.logoGradient)
                
                Text(setting.rawValue)
                    .font(AppFonts.gothicHeadline(24))
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.cardWhite)
            }
            
            // 説明文
            Text(setting.description)
                .font(AppFonts.gothicBody(14))
                .foregroundColor(AppColors.cardWhite.opacity(0.7))
                .multilineTextAlignment(.center)
            
            // 現在の値
            HStack(spacing: 8) {
                Text("現在の設定:")
                    .font(AppFonts.gothicCaption(12))
                    .foregroundColor(AppColors.cardWhite.opacity(0.6))
                
                Text(gameSettings.displayValue(for: setting, value: gameSettings.currentValue(for: setting)))
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
    }
    
    // MARK: - 選択肢セクション
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
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedValue = value
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .frame(height: 80)
    }
    
    // MARK: - ボタンセクション
    private var buttonsSection: some View {
        HStack(spacing: 12) {
            // キャンセルボタン
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
            
            // 決定ボタン
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
                            .shadow(color: AppColors.brightYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
            }
        }
    }
    
    // MARK: - Actions
    private func dismiss() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        isPresented = false
    }
    
    private func save() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        gameSettings.updateValue(for: setting, value: selectedValue)
        isPresented = false
    }
}

// MARK: - 選択肢ボタン
struct OptionButton: View {
    let value: Int
    let displayValue: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(displayValue)
                .font(AppFonts.gothicHeadline(18))
                .fontWeight(isSelected ? .bold : .medium)
                .foregroundColor(isSelected ? .black : AppColors.cardWhite)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
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
                )
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