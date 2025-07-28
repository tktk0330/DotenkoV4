//
//  SoundSettingsView.swift
//  DotenkoV4
//
//  サウンド設定ビュー
//

import SwiftUI

struct SoundSettingsView: View {
    @AppStorage("bgmEnabled") private var bgmEnabled = true
    @AppStorage("seEnabled") private var seEnabled = true
    @AppStorage("bgmVolume") private var bgmVolume: Double = 0.7
    @AppStorage("seVolume") private var seVolume: Double = 0.8
    
    var body: some View {
        VStack(spacing: 24) {
            settingCard(title: "BGM設定") {
                VStack(spacing: 16) {
                    Toggle(isOn: $bgmEnabled) {
                        Label("BGMを有効にする", systemImage: "music.note")
                            .font(AppFonts.gothicBody(16))
                    }
                    .tint(AppColors.brightYellow)
                    
                    if bgmEnabled {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("音量: \(Int(bgmVolume * 100))%")
                                .font(AppFonts.gothicCaption(14))
                                .foregroundColor(AppColors.cardWhite.opacity(0.8))
                            
                            Slider(value: $bgmVolume, in: 0...1)
                                .tint(AppColors.brightYellow)
                        }
                    }
                }
            }
            
            settingCard(title: "効果音設定") {
                VStack(spacing: 16) {
                    Toggle(isOn: $seEnabled) {
                        Label("効果音を有効にする", systemImage: "speaker.wave.2")
                            .font(AppFonts.gothicBody(16))
                    }
                    .tint(AppColors.brightYellow)
                    
                    if seEnabled {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("音量: \(Int(seVolume * 100))%")
                                .font(AppFonts.gothicCaption(14))
                                .foregroundColor(AppColors.cardWhite.opacity(0.8))
                            
                            Slider(value: $seVolume, in: 0...1)
                                .tint(AppColors.brightYellow)
                        }
                    }
                }
            }
            
            // サンプルカード
            HStack(spacing: 12) {
                ForEach(["c01", "h07", "s13"], id: \.self) { cardName in
                    Image(cardName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                        .shadow(radius: 4)
                }
            }
            .padding(.top, 20)
        }
    }
    
    private func settingCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppFonts.gothicHeadline(18))
                .foregroundColor(AppColors.brightYellow)
            
            content()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardWhite.opacity(0.2), lineWidth: 1)
                )
        )
    }
}