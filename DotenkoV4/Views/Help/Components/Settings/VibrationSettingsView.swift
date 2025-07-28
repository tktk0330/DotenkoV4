//
//  VibrationSettingsView.swift
//  DotenkoV4
//
//  バイブレーション設定ビュー
//

import SwiftUI

struct VibrationSettingsView: View {
    @AppStorage("vibrationEnabled") private var vibrationEnabled = true
    @AppStorage("vibrationIntensity") private var vibrationIntensity: Double = 0.7
    
    var body: some View {
        VStack(spacing: 24) {
            Toggle(isOn: $vibrationEnabled) {
                Label("バイブレーションを有効にする", systemImage: "iphone.radiowaves.left.and.right")
                    .font(AppFonts.gothicBody(16))
            }
            .tint(AppColors.brightYellow)
            .padding()
            .background(settingBackground)
            
            if vibrationEnabled {
                VStack(alignment: .leading, spacing: 12) {
                    Text("バイブレーション強度")
                        .font(AppFonts.gothicHeadline(18))
                        .foregroundColor(AppColors.brightYellow)
                    
                    HStack {
                        Text("弱")
                            .font(AppFonts.gothicCaption(14))
                            .foregroundColor(AppColors.cardWhite.opacity(0.6))
                        
                        Slider(value: $vibrationIntensity, in: 0...1) { _ in
                            // フィードバック
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                        .tint(AppColors.brightYellow)
                        
                        Text("強")
                            .font(AppFonts.gothicCaption(14))
                            .foregroundColor(AppColors.cardWhite.opacity(0.6))
                    }
                    
                    testButton
                }
                .padding()
                .background(settingBackground)
            }
        }
    }
    
    private var settingBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.black.opacity(0.3))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardWhite.opacity(0.2), lineWidth: 1)
            )
    }
    
    private var testButton: some View {
        Button {
            // テストバイブレーション
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        } label: {
            HStack {
                Image(systemName: "hand.tap.fill")
                Text("テスト")
            }
            .font(AppFonts.gothicBody(16))
            .foregroundColor(.black)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(AppGradients.logoGradient)
            .clipShape(Capsule())
        }
        .padding(.top, 8)
    }
}