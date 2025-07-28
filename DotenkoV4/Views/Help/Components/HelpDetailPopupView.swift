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

// MARK: - サウンド設定ビュー
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

// MARK: - バイブレーション設定ビュー
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
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.cardWhite.opacity(0.2), lineWidth: 1)
                    )
            )
            
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
                .padding()
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
    }
}

// MARK: - 基本ルールビュー
struct BasicRulesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ruleSection(
                title: "ゲームの目的",
                content: "DOTENKOは、全てのカードを早く出し切ることを目指すカードゲームです。",
                imageName: "crown.fill"
            )
            
            ruleSection(
                title: "カードの強さ",
                content: "ジョーカー > 2 > A > K > Q > J > 10 > ... > 3\n同じ数字の場合は、スペード > ハート > ダイヤ > クラブの順で強さが決まります。"
            )
            
            // カードの強さのビジュアル表示
            VStack(spacing: 12) {
                Text("最強カードの例")
                    .font(AppFonts.gothicCaption(14))
                    .foregroundColor(AppColors.cardWhite.opacity(0.8))
                
                HStack(spacing: 16) {
                    // ジョーカー
                    Image("joker")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                    
                    Text(">")
                        .font(AppFonts.gothicHeadline(24))
                        .foregroundColor(AppColors.brightYellow)
                    
                    // スペードの2
                    Image("s02")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                }
                .shadow(radius: 4)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.2))
            )
            
            ruleSection(
                title: "革命",
                content: "同じ数字を4枚出すと革命が発生し、カードの強さが逆転します。\n革命中は 3 > 4 > ... > K > A > 2 > ジョーカーの順になります。",
                imageName: "arrow.triangle.2.circlepath"
            )
        }
    }
    
    private func ruleSection(title: String, content: String, imageName: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let imageName = imageName {
                    Image(systemName: imageName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppColors.brightYellow)
                }
                
                Text(title)
                    .font(AppFonts.gothicHeadline(18))
                    .foregroundColor(AppColors.brightYellow)
            }
            
            Text(content)
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite)
                .lineSpacing(4)
        }
        .padding()
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

// MARK: - ゲームの始め方ビュー
struct HowToStartView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            stepCard(
                number: 1,
                title: "プレイヤー数を選択",
                content: "2〜5人でプレイできます。HOME画面でプレイヤー数を選択してください。",
                cardImages: ["back-1", "back-2", "back-3"]
            )
            
            stepCard(
                number: 2,
                title: "ルール設定",
                content: "ローカルルールや詳細設定を行います。初心者の方はデフォルト設定がおすすめです。"
            )
            
            stepCard(
                number: 3,
                title: "ゲーム開始",
                content: "「START」ボタンをタップしてゲームを開始します。カードが自動的に配られます。",
                cardImages: ["c03", "h10", "d08"]
            )
        }
    }
    
    private func stepCard(number: Int, title: String, content: String, cardImages: [String] = []) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                // ステップ番号
                Text("\(number)")
                    .font(AppFonts.gothicHeadline(24))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(AppGradients.logoGradient)
                    )
                
                Text(title)
                    .font(AppFonts.gothicHeadline(18))
                    .foregroundColor(AppColors.brightYellow)
            }
            
            Text(content)
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite)
                .lineSpacing(4)
            
            if !cardImages.isEmpty {
                HStack(spacing: -20) {
                    ForEach(cardImages.indices, id: \.self) { index in
                        Image(cardImages[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .shadow(radius: 4)
                            .rotationEffect(.degrees(Double(index - 1) * 10))
                            .zIndex(Double(cardImages.count - index))
                    }
                }
                .padding(.leading, 30)
                .padding(.top, 8)
            }
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

// MARK: - FAQビュー
struct FAQView: View {
    var body: some View {
        VStack(spacing: 20) {
            faqItem(
                question: "革命はいつ解除されますか？",
                answer: "ゲームが終了するまで続きます。ただし、再度4枚出しで革命を起こすと元に戻ります。"
            )
            
            faqItem(
                question: "ジョーカーは何枚でも出せますか？",
                answer: "ジョーカーは1枚ずつしか出せません。複数枚同時に出すことはできません。"
            )
            
            faqItem(
                question: "パスした後も出せますか？",
                answer: "場が流れるまではパスした後も出すことができます。"
            )
            
            faqItem(
                question: "8切りとは何ですか？",
                answer: "8を出すと強制的に場が流れるルールです。設定で有効/無効を切り替えられます。"
            )
        }
    }
    
    private func faqItem(question: String, answer: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.brightYellow)
                
                Text(question)
                    .font(AppFonts.gothicHeadline(16))
                    .foregroundColor(AppColors.cardWhite)
            }
            
            Text(answer)
                .font(AppFonts.gothicBody(15))
                .foregroundColor(AppColors.cardWhite.opacity(0.9))
                .lineSpacing(4)
                .padding(.leading, 28)
        }
        .padding()
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

// MARK: - お問い合わせビュー
struct ContactView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("お問い合わせやご要望は以下からお願いします")
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite)
                .multilineTextAlignment(.center)
            
            Button {
                // メールアプリを開く
                if let url = URL(string: "mailto:support@dotenko.app") {
                    UIApplication.shared.open(url)
                }
            } label: {
                Label("メールで問い合わせ", systemImage: "envelope.fill")
                    .font(AppFonts.gothicHeadline(18))
                    .foregroundColor(.black)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(AppGradients.logoGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(color: AppColors.brightYellow.opacity(0.3), radius: 8)
            }
            
            VStack(spacing: 8) {
                Text("Twitter: @dotenko_app")
                    .font(AppFonts.gothicBody(14))
                    .foregroundColor(AppColors.cardWhite.opacity(0.8))
                
                Text("対応時間: 平日 10:00-18:00")
                    .font(AppFonts.gothicCaption(12))
                    .foregroundColor(AppColors.cardWhite.opacity(0.6))
            }
            .padding(.top, 20)
        }
        .padding(.vertical, 40)
    }
}

// MARK: - 利用規約ビュー
struct TermsView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("利用規約の詳細は以下のリンクからご確認ください")
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite)
                .multilineTextAlignment(.center)
            
            Button {
                // SafariでWebページを開く
                if let url = URL(string: "https://dotenko.app/terms") {
                    UIApplication.shared.open(url)
                }
            } label: {
                Label("利用規約を見る", systemImage: "doc.text.fill")
                    .font(AppFonts.gothicHeadline(18))
                    .foregroundColor(.black)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(AppGradients.logoGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(color: AppColors.brightYellow.opacity(0.3), radius: 8)
            }
            
            Text("最終更新日: 2024年1月1日")
                .font(AppFonts.gothicCaption(12))
                .foregroundColor(AppColors.cardWhite.opacity(0.6))
                .padding(.top, 20)
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
