//
//  HowToStartView.swift
//  DotenkoV4
//
//  操作方法を詳しく説明するビュー
//

import SwiftUI

struct HowToStartView: View {
    @State private var selectedSection: OperationSection? = .gameStart
    
    var body: some View {
        VStack(spacing: 20) {
            // セクションタブ
            sectionTabs
            
            // 選択されたセクションの内容
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    if let section = selectedSection {
                        sectionContent(for: section)
                    }
                }
                .padding(.vertical, 10)
            }
        }
    }
    
    // MARK: - Section Tabs
    private var sectionTabs: some View {
        HStack(spacing: 0) {
            ForEach(OperationSection.allCases) { section in
                sectionTabButton(for: section)
            }
        }
        .background(tabsBackground)
    }
    
    private func sectionTabButton(for section: OperationSection) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedSection = section
            }
        } label: {
            tabButtonLabel(for: section)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func tabButtonLabel(for section: OperationSection) -> some View {
        VStack(spacing: 8) {
            Image(systemName: section.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(tabIconStyle(for: section))
            
            Text(section.title)
                .font(AppFonts.gothicCaption(12))
                .foregroundColor(tabTextColor(for: section))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(tabButtonBackground(for: section))
    }
    
    private func tabIconStyle(for section: OperationSection) -> AnyShapeStyle {
        selectedSection == section ? AnyShapeStyle(AppGradients.logoGradient) : AnyShapeStyle(AppColors.cardWhite.opacity(0.5))
    }
    
    private func tabTextColor(for section: OperationSection) -> Color {
        selectedSection == section ? AppColors.brightYellow : AppColors.cardWhite.opacity(0.7)
    }
    
    private func tabButtonBackground(for section: OperationSection) -> AnyShapeStyle {
        if selectedSection == section {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color.black.opacity(0.4), Color.black.opacity(0.2)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        return AnyShapeStyle(Color.clear)
    }
    
    private var tabsBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.black.opacity(0.3))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardWhite.opacity(0.2), lineWidth: 1)
            )
    }
    
    // MARK: - Section Content
    @ViewBuilder
    private func sectionContent(for section: OperationSection) -> some View {
        switch section {
        case .gameStart:
            gameStartSection
        case .cardOperation:
            cardOperationSection
        case .dotenkoOperation:
            dotenkoOperationSection
        case .tips:
            tipsSection
        }
    }
    
    // MARK: - ゲーム開始セクション
    private var gameStartSection: some View {
        VStack(spacing: 20) {
            // ゲーム開始の説明
            VStack(spacing: 16) {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundStyle(AppGradients.logoGradient)
                
                Text("ゲームの始め方")
                    .font(AppFonts.gothicHeadline(28))
                    .fontWeight(.bold)
                    .foregroundStyle(AppGradients.logoGradient)
                
                Text("どてんこゲームの始め方をわかりやすく説明するよ！")
                    .font(AppFonts.gothicBody(16))
                    .foregroundColor(AppColors.cardWhite.opacity(0.9))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColors.brightYellow.opacity(0.1),
                                Color.black.opacity(0.3)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppColors.brightYellow.opacity(0.5), lineWidth: 2)
                    )
            )
            .shadow(color: AppColors.brightYellow.opacity(0.2), radius: 10)
            
            // ゲーム開始手順
            VStack(alignment: .leading, spacing: 16) {
                Text("ゲーム開始手順")
                    .font(AppFonts.gothicHeadline(20))
                    .foregroundColor(AppColors.brightYellow)
                
                ForEach(gameStartSteps.indices, id: \.self) { index in
                    operationStepRow(index: index, step: gameStartSteps[index])
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
            
            // プレイヤー設定
            VStack(spacing: 16) {
                Text("プレイヤー設定")
                    .font(AppFonts.gothicHeadline(20))
                    .foregroundColor(AppColors.brightYellow)
                
                VStack(spacing: 12) {
                    settingCard(
                        title: "プレイヤー数",
                        description: "2〜4人でプレイできるよ",
                        icon: "person.2.fill",
                        color: AppColors.vibrantOrange
                    )
                    
                    settingCard(
                        title: "ゲームレベル",
                        description: "初心者・普通・上級者から選択",
                        icon: "star.fill",
                        color: AppColors.brightYellow
                    )
                    
                    settingCard(
                        title: "ラウンド数",
                        description: "5回・10回・15回から選択",
                        icon: "clock.fill",
                        color: AppColors.hotRed
                    )
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
        }
    }
    
    // MARK: - カード操作セクション
    private var cardOperationSection: some View {
        VStack(spacing: 20) {
            Text("カードの操作方法")
                .font(AppFonts.gothicHeadline(24))
                .fontWeight(.bold)
                .foregroundColor(AppColors.brightYellow)
            
            Text("画面のどこを触ればいいか詳しく説明するよ！")
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite.opacity(0.9))
            
            // 基本操作
            VStack(spacing: 16) {
                operationHeader("基本操作", "手.tap.fill")
                
                VStack(spacing: 12) {
                    operationCard(
                        title: "カードを選ぶ",
                        description: "出したいカードを指でタップ",
                        detail: "カードが光ったら選択完了！",
                        icon: "hand.tap.fill",
                        color: AppColors.brightYellow
                    )
                    
                    operationCard(
                        title: "カードを出す",
                        description: "「カードを出す」ボタンをタップ",
                        detail: "選んだカードが場に出るよ",
                        icon: "arrow.up.circle.fill",
                        color: AppColors.vibrantOrange
                    )
                    
                    operationCard(
                        title: "カードを引く",
                        description: "「カードを引く」ボタンをタップ",
                        detail: "山札からカードがもらえる",
                        icon: "plus.circle.fill",
                        color: AppColors.hotRed
                    )
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
            
            // 複数選択
            VStack(spacing: 16) {
                operationHeader("複数選択", "rectangle.stack.fill")
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("同じ数字やマークのカードをまとめて出せるよ！")
                        .font(AppFonts.gothicBody(16))
                        .foregroundColor(AppColors.cardWhite)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        multiSelectTip("1. 最初のカードをタップ")
                        multiSelectTip("2. 次のカードをタップ")
                        multiSelectTip("3. 光ったカードを確認")
                        multiSelectTip("4. 「カードを出す」ボタンをタップ")
                    }
                    
                    Text("💡 コツ: 同じ数字なら全部選べる！")
                        .font(AppFonts.gothicCaption(14))
                        .foregroundColor(AppColors.brightYellow)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppColors.brightYellow.opacity(0.1))
                        )
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
        }
    }
    
    // MARK: - どてんこ操作セクション
    private var dotenkoOperationSection: some View {
        VStack(spacing: 20) {
            Text("どてんこの操作")
                .font(AppFonts.gothicHeadline(24))
                .fontWeight(.bold)
                .foregroundColor(AppColors.brightYellow)
            
            Text("どてんこボタンの使い方を覚えよう！")
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite.opacity(0.9))
            
            // どてんこボタン
            VStack(spacing: 16) {
                operationHeader("どてんこボタン", "hands.sparkles.fill")
                
                VStack(spacing: 16) {
                    // ボタンの見た目
                    VStack(spacing: 12) {
                        Text("どてんこ！")
                            .font(AppFonts.gothicHeadline(24))
                            .fontWeight(.bold)
                            .foregroundStyle(AppGradients.logoGradient)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.black.opacity(0.3))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(AppGradients.buttonBorderGradient, lineWidth: 3)
                                    )
                            )
                            .shadow(color: AppColors.brightYellow.opacity(0.3), radius: 10)
                        
                        Text("↑ こんなボタンが表示されるよ")
                            .font(AppFonts.gothicCaption(14))
                            .foregroundColor(AppColors.cardWhite.opacity(0.8))
                    }
                    
                    Divider()
                        .background(AppColors.cardWhite.opacity(0.3))
                    
                    // 使い方
                    VStack(alignment: .leading, spacing: 12) {
                        dotenkoOperationStep("1", "計算する", "場の数字と手札の合計を確認")
                        dotenkoOperationStep("2", "確認する", "数字が同じになったかチェック")
                        dotenkoOperationStep("3", "押す", "「どてんこ！」ボタンをタップ")
                        dotenkoOperationStep("4", "勝利", "成功したらポイントゲット！")
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
            
            // 注意点
            VStack(spacing: 16) {
                operationHeader("注意点", "exclamationmark.triangle.fill")
                
                VStack(spacing: 12) {
                    warningCard(
                        title: "早押し勝負！",
                        description: "他のプレイヤーより早くボタンを押そう",
                        icon: "timer.fill"
                    )
                    
                    warningCard(
                        title: "計算間違いに注意",
                        description: "間違って押すとマイナスポイント",
                        icon: "minus.circle.fill"
                    )
                    
                    warningCard(
                        title: "チャンスを逃すな",
                        description: "どてんこのチャンスは何度でもある",
                        icon: "arrow.clockwise.circle.fill"
                    )
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
        }
    }
    
    // MARK: - コツとヒントセクション
    private var tipsSection: some View {
        VStack(spacing: 20) {
            Text("上手になるコツ")
                .font(AppFonts.gothicHeadline(24))
                .fontWeight(.bold)
                .foregroundColor(AppColors.brightYellow)
            
            Text("プロからのアドバイス！")
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite.opacity(0.9))
            
            // 基本のコツ
            VStack(spacing: 16) {
                tipHeader("基本のコツ", "lightbulb.fill")
                
                VStack(spacing: 12) {
                    ForEach(basicTips.indices, id: \.self) { index in
                        tipCard(tip: basicTips[index])
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
            
            // 上級者のコツ
            VStack(spacing: 16) {
                tipHeader("上級者のコツ", "star.fill")
                
                VStack(spacing: 12) {
                    ForEach(advancedTips.indices, id: \.self) { index in
                        tipCard(tip: advancedTips[index])
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
            
            // よくある失敗
            VStack(spacing: 16) {
                tipHeader("よくある失敗", "xmark.circle.fill")
                
                VStack(spacing: 12) {
                    ForEach(commonMistakes.indices, id: \.self) { index in
                        mistakeCard(mistake: commonMistakes[index])
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
        }
    }
    
    // MARK: - Helper Views
    private func operationStepRow(index: Int, step: (title: String, description: String)) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Text("\(index + 1)")
                .font(AppFonts.gothicHeadline(18))
                .fontWeight(.bold)
                .foregroundStyle(AppGradients.logoGradient)
                .frame(width: 30, height: 30)
                .background(
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .overlay(
                            Circle()
                                .stroke(AppColors.brightYellow.opacity(0.5), lineWidth: 1)
                        )
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(step.title)
                    .font(AppFonts.gothicBody(16))
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.cardWhite)
                
                Text(step.description)
                    .font(AppFonts.gothicCaption(14))
                    .foregroundColor(AppColors.cardWhite.opacity(0.8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func settingCard(title: String, description: String, icon: String, color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppFonts.gothicBody(16))
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.cardWhite)
                
                Text(description)
                    .font(AppFonts.gothicCaption(14))
                    .foregroundColor(AppColors.cardWhite.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private func operationHeader(_ title: String, _ icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.brightYellow)
            
            Text(title)
                .font(AppFonts.gothicHeadline(20))
                .foregroundColor(AppColors.brightYellow)
            
            Spacer()
        }
    }
    
    private func operationCard(title: String, description: String, detail: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Text(title)
                    .font(AppFonts.gothicBody(16))
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.cardWhite)
                
                Spacer()
            }
            
            Text(description)
                .font(AppFonts.gothicBody(14))
                .foregroundColor(AppColors.cardWhite.opacity(0.8))
            
            Text(detail)
                .font(AppFonts.gothicCaption(12))
                .foregroundColor(color.opacity(0.8))
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color.opacity(0.1))
                )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardWhite.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private func multiSelectTip(_ text: String) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(AppColors.brightYellow)
                .frame(width: 6, height: 6)
            
            Text(text)
                .font(AppFonts.gothicBody(14))
                .foregroundColor(AppColors.cardWhite)
            
            Spacer()
        }
    }
    
    private func dotenkoOperationStep(_ number: String, _ title: String, _ description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(AppFonts.gothicHeadline(16))
                .fontWeight(.bold)
                .foregroundStyle(AppGradients.logoGradient)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .overlay(
                            Circle()
                                .stroke(AppColors.brightYellow.opacity(0.5), lineWidth: 1)
                        )
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppFonts.gothicBody(14))
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.brightYellow)
                
                Text(description)
                    .font(AppFonts.gothicCaption(12))
                    .foregroundColor(AppColors.cardWhite.opacity(0.8))
            }
            
            Spacer()
        }
    }
    
    private func warningCard(title: String, description: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.hotRed)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppFonts.gothicBody(14))
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.cardWhite)
                
                Text(description)
                    .font(AppFonts.gothicCaption(12))
                    .foregroundColor(AppColors.cardWhite.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(AppColors.hotRed.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppColors.hotRed.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private func tipHeader(_ title: String, _ icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.brightYellow)
            
            Text(title)
                .font(AppFonts.gothicHeadline(20))
                .foregroundColor(AppColors.brightYellow)
            
            Spacer()
        }
    }
    
    private func tipCard(tip: GameTip) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: tip.icon)
                    .font(.system(size: 20))
                    .foregroundColor(tip.color)
                
                Text(tip.title)
                    .font(AppFonts.gothicBody(16))
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.cardWhite)
                
                Spacer()
            }
            
            Text(tip.content)
                .font(AppFonts.gothicBody(14))
                .foregroundColor(AppColors.cardWhite.opacity(0.8))
                .lineSpacing(2)
            
            if let example = tip.example {
                Text("例: \(example)")
                    .font(AppFonts.gothicCaption(12))
                    .foregroundColor(tip.color.opacity(0.8))
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(tip.color.opacity(0.1))
                    )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(tip.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private func mistakeCard(mistake: CommonMistake) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.hotRed)
                
                Text(mistake.title)
                    .font(AppFonts.gothicBody(16))
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.cardWhite)
                
                Spacer()
            }
            
            Text(mistake.problem)
                .font(AppFonts.gothicBody(14))
                .foregroundColor(AppColors.cardWhite.opacity(0.8))
            
            Text("解決法: \(mistake.solution)")
                .font(AppFonts.gothicCaption(12))
                .foregroundColor(AppColors.brightYellow.opacity(0.8))
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppColors.brightYellow.opacity(0.1))
                )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.hotRed.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Data
    private let gameStartSteps = [
        (title: "アプリを開く", description: "どてんこアプリのアイコンをタップ"),
        (title: "プレイボタンを押す", description: "「START GAME」ボタンをタップ"),
        (title: "設定を選ぶ", description: "プレイヤー数やレベルを選択"),
        (title: "ゲーム開始", description: "すべて設定したらゲームスタート！")
    ]
    
    private struct GameTip {
        let title: String
        let content: String
        let example: String?
        let icon: String
        let color: Color
    }
    
    private let basicTips = [
        GameTip(
            title: "手札をよく見る",
            content: "自分の手札の数字を覚えておこう。足し算しやすい組み合わせを見つけるのがコツ！",
            example: "7と3を持ってたら、場に10が来たときすぐ気づける",
            icon: "eye.fill",
            color: AppColors.brightYellow
        ),
        GameTip(
            title: "場の数字を記憶",
            content: "最初の場のカードと現在の場のカード、両方覚えておこう。しょてんこのチャンス！",
            example: "最初が8、現在が12なら、どちらでもどてんこできる",
            icon: "brain.head.profile",
            color: AppColors.vibrantOrange
        ),
        GameTip(
            title: "マークを活用",
            content: "数字だけでなく、マーク（♠♥♦♣）も重要。同じマークなら数字が違ってもカードを出せる！",
            example: "♠7が場にあったら、♠3でも♠Kでも出せる",
            icon: "suit.spade.fill",
            color: AppColors.hotRed
        )
    ]
    
    private let advancedTips = [
        GameTip(
            title: "複数カードを狙う",
            content: "同じ数字やマークのカードを複数枚まとめて出すと、手札が一気に減らせて有利！",
            example: "♥5、♦5、♣5を持ってたら、場に5が来たときまとめて出す",
            icon: "rectangle.stack.fill",
            color: AppColors.brightYellow
        ),
        GameTip(
            title: "他の人の手札をチェック",
            content: "他のプレイヤーの手札の枚数を見て、誰が勝ちそうかを予想しよう。",
            example: "手札が少ない人がいたら、その人を警戒する",
            icon: "person.2.fill",
            color: AppColors.vibrantOrange
        ),
        GameTip(
            title: "ジョーカーを有効活用",
            content: "ジョーカーは-1、0、+1のどれにでもなる万能カード。どてんこしやすい数字に調整しよう！",
            example: "手札が9でジョーカーがあるなら、場が8、9、10のどれでもどてんこできる",
            icon: "crown.fill",
            color: AppColors.hotRed
        )
    ]
    
    private struct CommonMistake {
        let title: String
        let problem: String
        let solution: String
    }
    
    private let commonMistakes = [
        CommonMistake(
            title: "計算ミス",
            problem: "足し算を間違えて、どてんこじゃないのにボタンを押してしまう",
            solution: "ゆっくりでも正確に計算。指を使って数えてもOK！"
        ),
        CommonMistake(
            title: "カード選択ミス",
            problem: "出したいカードと違うカードを選んでしまう",
            solution: "カードが光ったら、もう一度確認してから「カードを出す」を押す"
        ),
        CommonMistake(
            title: "ルール忘れ",
            problem: "同じマークで出せることを忘れて、カードを引いてしまう",
            solution: "カードを引く前に、本当に出せるカードがないか確認する"
        ),
        CommonMistake(
            title: "どてんこのタイミング",
            problem: "どてんこできるのに気づかず、次のターンに進んでしまう",
            solution: "毎回手札の合計を確認する習慣をつける"
        )
    ]
}

// MARK: - Operation Section Enum
enum OperationSection: String, CaseIterable, Identifiable {
    case gameStart = "開始方法"
    case cardOperation = "カード操作"
    case dotenkoOperation = "どてんこ操作"
    case tips = "コツ"
    
    var id: String { rawValue }
    var title: String { rawValue }
    
    var icon: String {
        switch self {
        case .gameStart: return "play.circle.fill"
        case .cardOperation: return "hand.tap.fill"
        case .dotenkoOperation: return "hands.sparkles.fill"
        case .tips: return "lightbulb.fill"
        }
    }
}

#Preview {
    HowToStartView()
        .padding()
        .background(AppGradients.primaryBackground)
}