//
//  HelpDetailPopupView.swift
//  DotenkoV4
//
//  Help項目の詳細ポップアップビュー
//

import SwiftUI

struct HelpDetailPopupView: View {
    let item: HelpItem
    @Binding var isPresented: Bool
    @State private var contentOpacity: Double = 0
    @State private var contentScale: CGFloat = 0.9
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // ヘッダー
                HStack {
                    Text(item.title)
                        .font(AppFonts.gothicHeadline(22))
                        .fontWeight(.bold)
                        .foregroundStyle(AppGradients.logoGradient)
                    
                    Spacer()
                    
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        withAnimation(.easeOut(duration: 0.3)) {
                            isPresented = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [AppColors.cardWhite.opacity(0.8), AppColors.cardWhite.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .background(
                                Circle()
                                    .fill(Color.black.opacity(0.2))
                                    .blur(radius: 2)
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .background(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.4),
                            Color.black.opacity(0.3)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                // コンテンツ
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        // アイコン
                        Image(systemName: item.icon)
                            .font(.system(size: 50, weight: .medium))
                            .foregroundStyle(AppGradients.logoGradient)
                            .padding(.top, 20)
                        
                        // メインコンテンツ
                        contentView
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                    }
                }
                .background(AppGradients.primaryBackground)
            }
            .frame(width: min(geometry.size.width * 0.9, 400))
            .frame(maxHeight: geometry.size.height * 0.8)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [
                                AppColors.cardWhite.opacity(0.3),
                                AppColors.cardWhite.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
            .scaleEffect(contentScale)
            .opacity(contentOpacity)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                contentOpacity = 1
                contentScale = 1
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch item.type {
        case .soundSettings:
            SoundSettingsView()
        case .vibrationSettings:
            VibrationSettingsView()
        case .basicRules:
            BasicRulesView()
        case .howToStart:
            HowToStartView()
        case .faq:
            FAQView()
        case .contact:
            ContactView()
        case .terms:
            TermsView()
        default:
            defaultContentView
        }
    }
    
    private var defaultContentView: some View {
        VStack(spacing: 20) {
            Text("この機能は現在開発中です")
                .font(AppFonts.gothicHeadline(18))
                .foregroundColor(AppColors.cardWhite)
                .multilineTextAlignment(.center)
            
            Image("back-1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .padding(.vertical, 40)
    }
}

#Preview {
    @Previewable @State var isPresented = true
    HelpDetailPopupView(
        item: HelpItem(
            title: "サウンド設定",
            icon: "speaker.wave.2.fill",
            type: .soundSettings
        ),
        isPresented: $isPresented
    )
}