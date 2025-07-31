//
//  BasicRulesView.swift
//  DotenkoV4
//
//  基本ルール説明ビュー
//

import SwiftUI

struct BasicRulesView: View {
    @State private var selectedSection: RuleSection? = .objective
    
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
            ForEach(RuleSection.allCases) { section in
                sectionTabButton(for: section)
            }
        }
        .background(tabsBackground)
    }
    
    private func sectionTabButton(for section: RuleSection) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedSection = section
            }
        } label: {
            tabButtonLabel(for: section)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func tabButtonLabel(for section: RuleSection) -> some View {
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
    
    private func tabIconStyle(for section: RuleSection) -> AnyShapeStyle {
        selectedSection == section ? AnyShapeStyle(AppGradients.logoGradient) : AnyShapeStyle(AppColors.cardWhite.opacity(0.5))
    }
    
    private func tabTextColor(for section: RuleSection) -> Color {
        selectedSection == section ? AppColors.brightYellow : AppColors.cardWhite.opacity(0.7)
    }
    
    private func tabButtonBackground(for section: RuleSection) -> some View {
        if selectedSection == section {
            let cornerRadius: CGFloat = 16
            let shape = getTabShape(for: section, cornerRadius: cornerRadius)
            
            return AnyView(
                shape
                    .fill(
                        LinearGradient(
                            colors: [Color.black.opacity(0.4), Color.black.opacity(0.2)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
        }
        return AnyView(Color.clear)
    }
    
    private func getTabShape(for section: RuleSection, cornerRadius: CGFloat) -> AnyShape {
        switch section {
        case .objective: // 最初のタブ（基本）- 左側のみ角丸
            return AnyShape(CustomTabShape(corners: [.topLeft, .bottomLeft], radius: cornerRadius))
        case .special: // 最後のタブ（特殊）- 右側のみ角丸
            return AnyShape(CustomTabShape(corners: [.topRight, .bottomRight], radius: cornerRadius))
        default: // 中間のタブ - 角丸なし
            return AnyShape(Rectangle())
        }
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
    private func sectionContent(for section: RuleSection) -> some View {
        switch section {
        case .objective:
            objectiveSection
        case .playRules:
            playRulesSection
        case .dotenkoRules:
            dotenkoRulesSection
        case .special:
            specialCardsSection
        }
    }
    
    // MARK: - 基本ルールセクション
    private var objectiveSection: some View {
        VStack(spacing: 20) {
            // ゲームの目的
            VStack(spacing: 16) {
                Image(systemName: "hands.sparkles.fill")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundStyle(AppGradients.logoGradient)
                
                Text("どてんこってなに？")
                    .font(AppFonts.gothicHeadline(28))
                    .fontWeight(.bold)
                    .foregroundStyle(AppGradients.logoGradient)
                
                VStack(spacing: 12) {
                    Text("どてんこは、トランプを使った足し算ゲームです！")
                        .font(AppFonts.gothicBody(18))
                        .foregroundColor(AppColors.cardWhite)
                        .multilineTextAlignment(.center)
                    
                    Text("場に出ているカードの数字と\n自分の手札の数字を全部足して\n同じになったら「どてんこ！」")
                        .font(AppFonts.gothicBody(16))
                        .foregroundColor(AppColors.cardWhite.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
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
            
            // ゲームの流れ
            VStack(alignment: .leading, spacing: 16) {
                Text("ゲームの流れ")
                    .font(AppFonts.gothicHeadline(20))
                    .foregroundColor(AppColors.brightYellow)
                
                ForEach(gameFlowSteps.indices, id: \.self) { index in
                    flowStepRow(index: index, step: gameFlowSteps[index])
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
            
            // 簡単な例
            VStack(spacing: 16) {
                Text("かんたんな例")
                    .font(AppFonts.gothicHeadline(20))
                    .foregroundColor(AppColors.brightYellow)
                
                VStack(spacing: 16) {
                    Text("場のカード")
                        .font(AppFonts.gothicBody(16))
                        .foregroundColor(AppColors.cardWhite.opacity(0.8))
                    
                    cardExample("10")
                    
                    Text("+")
                        .font(AppFonts.gothicHeadline(24))
                        .foregroundColor(AppColors.brightYellow)
                    
                    Text("自分の手札")
                        .font(AppFonts.gothicBody(16))
                        .foregroundColor(AppColors.cardWhite.opacity(0.8))
                    
                    HStack(spacing: 12) {
                        cardExample("♠3")
                        Text("+")
                            .font(AppFonts.gothicHeadline(20))
                            .foregroundColor(AppColors.brightYellow)
                        cardExample("♥7")
                    }
                    
                    Divider()
                        .background(AppColors.cardWhite.opacity(0.3))
                        .padding(.horizontal, 40)
                    
                    Text("3 + 7 = 10")
                        .font(AppFonts.gothicHeadline(24))
                        .fontWeight(.bold)
                        .foregroundStyle(AppGradients.logoGradient)
                    
                    Text("どてんこ成功！🎉")
                        .font(AppFonts.gothicBody(20))
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.brightYellow)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.2))
                )
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
        }
    }
    
    // MARK: - カードの出し方セクション
    private var playRulesSection: some View {
        VStack(spacing: 20) {
            Text("カードの出し方")
                .font(AppFonts.gothicHeadline(24))
                .fontWeight(.bold)
                .foregroundColor(AppColors.brightYellow)
            
            Text("カードを出すには5つの方法があるよ！")
                .font(AppFonts.gothicBody(16))
                .foregroundColor(AppColors.cardWhite.opacity(0.9))
            
            ForEach(playPatterns.indices, id: \.self) { index in
                playPatternCard(pattern: playPatterns[index])
            }
            
            // 覚えるコツ
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.brightYellow)
                    
                    Text("覚えるコツ")
                        .font(AppFonts.gothicHeadline(18))
                        .foregroundColor(AppColors.brightYellow)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    tipRow("数字が同じ = OK！")
                    tipRow("マーク（スート）が同じ = OK！")
                    tipRow("足し算で場の数字になる = OK！")
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.brightYellow.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.brightYellow.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - どてんこの詳細セクション
    private var dotenkoRulesSection: some View {
        VStack(spacing: 20) {
            // どてんこの説明
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "sparkles")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.brightYellow)
                    
                    Text("どてんこのやり方")
                        .font(AppFonts.gothicHeadline(22))
                        .foregroundColor(AppColors.brightYellow)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    dotenkoStep(
                        number: "1",
                        title: "計算する",
                        description: "場のカードの数字と、自分の手札の数字を全部足す"
                    )
                    
                    dotenkoStep(
                        number: "2",
                        title: "確認する",
                        description: "足した数が同じになったか確認"
                    )
                    
                    dotenkoStep(
                        number: "3",
                        title: "宣言する",
                        description: "同じになったら「どてんこ！」ボタンを押す"
                    )
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
            
            // 勝ち方の種類
            VStack(spacing: 16) {
                Text("3つの勝ち方")
                    .font(AppFonts.gothicHeadline(20))
                    .foregroundColor(AppColors.brightYellow)
                
                VStack(spacing: 12) {
                    winTypeCard(
                        title: "どてんこ",
                        description: "今の場のカードと手札の合計が一致！",
                        example: "場: 15、手札: 7+8 = 15",
                        color: AppColors.brightYellow,
                        icon: "star.fill"
                    )
                    
                    winTypeCard(
                        title: "しょてんこ",
                        description: "最初の場のカードと手札の合計が一致！",
                        example: "初期場: 10、手札: 4+6 = 10",
                        color: AppColors.vibrantOrange,
                        icon: "moon.stars.fill"
                    )
                    
                    winTypeCard(
                        title: "リベンジ",
                        description: "チャレンジゾーンで逆転勝利！",
                        example: "カードを引いて合計を合わせる",
                        color: AppColors.hotRed,
                        icon: "flame.fill"
                    )
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
            
            // ポイント計算
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "yensign.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.brightYellow)
                    
                    Text("ポイントの計算")
                        .font(AppFonts.gothicHeadline(20))
                        .foregroundColor(AppColors.brightYellow)
                }
                
                VStack(spacing: 12) {
                    Text("どてんこしたらポイントゲット！")
                        .font(AppFonts.gothicBody(16))
                        .foregroundColor(AppColors.cardWhite)
                    
                    HStack(spacing: 8) {
                        pointElement("最終数字", "15")
                        Text("×")
                            .font(AppFonts.gothicHeadline(18))
                            .foregroundColor(AppColors.brightYellow)
                        pointElement("レート", "10")
                        Text("×")
                            .font(AppFonts.gothicHeadline(18))
                            .foregroundColor(AppColors.brightYellow)
                        pointElement("ボーナス", "2")
                    }
                    
                    Text("= 300ポイント！")
                        .font(AppFonts.gothicHeadline(24))
                        .fontWeight(.bold)
                        .foregroundStyle(AppGradients.logoGradient)
                    
                    Divider()
                        .background(AppColors.cardWhite.opacity(0.3))
                    
                    VStack(spacing: 8) {
                        resultRow("どてんこした人", "+300ポイント", true)
                        resultRow("カードを出した人", "-300ポイント", false)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.2))
                )
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
        }
    }
    
    // MARK: - 特殊カードセクション
    private var specialCardsSection: some View {
        VStack(spacing: 20) {
            Text("特殊なカード")
                .font(AppFonts.gothicHeadline(24))
                .fontWeight(.bold)
                .foregroundColor(AppColors.brightYellow)
            
            // ジョーカー
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.brightYellow)
                    
                    Text("ジョーカー")
                        .font(AppFonts.gothicHeadline(20))
                        .foregroundColor(AppColors.brightYellow)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("ジョーカーは魔法のカード！")
                        .font(AppFonts.gothicBody(16))
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.cardWhite)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        jokerRule("数字は -1、0、+1 のどれかになる")
                        jokerRule("どのマーク（スート）としても使える")
                        jokerRule("どてんこしやすい数字に自動で変わる")
                    }
                    
                    Text("例: 場が10で手札がジョーカーと9なら、ジョーカーは1になる！")
                        .font(AppFonts.gothicCaption(14))
                        .foregroundColor(AppColors.brightYellow.opacity(0.8))
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                        )
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.brightYellow.opacity(0.3), lineWidth: 1)
                    )
            )
            
            // ボーナスカード
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.vibrantOrange)
                    
                    Text("ボーナスカード")
                        .font(AppFonts.gothicHeadline(20))
                        .foregroundColor(AppColors.vibrantOrange)
                }
                
                VStack(spacing: 12) {
                    bonusCard("1, 2, ジョーカー", "ポイント2倍！", "×2", AppColors.brightYellow)
                    bonusCard("♦3（ダイヤの3）", "数字が30になる！", "30", AppColors.vibrantOrange)
                    bonusCard("♠3, ♣3", "勝ち負けが逆転！", "⇄", AppColors.hotRed)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.vibrantOrange.opacity(0.3), lineWidth: 1)
                    )
            )
            
            // チャレンジゾーン
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.hotRed)
                    
                    Text("チャレンジゾーン")
                        .font(AppFonts.gothicHeadline(20))
                        .foregroundColor(AppColors.hotRed)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("逆転のチャンス！")
                        .font(AppFonts.gothicBody(16))
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.cardWhite)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        challengeRule("誰かがどてんこした後に発生")
                        challengeRule("手札の合計が足りない人が参加できる")
                        challengeRule("カードを引いて合計を合わせたら逆転勝利！")
                    }
                    
                    Text("例: どてんこ数字が20で、手札合計が15なら参加できる！")
                        .font(AppFonts.gothicCaption(14))
                        .foregroundColor(AppColors.hotRed.opacity(0.8))
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                        )
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.hotRed.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Helper Views
    private func flowStepRow(index: Int, step: (title: String, description: String)) -> some View {
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
    
    private func playPatternCard(pattern: PlayPattern) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("方法\(pattern.number)")
                    .font(AppFonts.gothicCaption(14))
                    .foregroundColor(AppColors.brightYellow)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(AppColors.brightYellow.opacity(0.2))
                    )
                
                Text(pattern.title)
                    .font(AppFonts.gothicBody(16))
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.cardWhite)
                
                Spacer()
            }
            
            Text(pattern.description)
                .font(AppFonts.gothicCaption(14))
                .foregroundColor(AppColors.cardWhite.opacity(0.8))
            
            if let example = pattern.example {
                VStack(alignment: .leading, spacing: 8) {
                    Text("例:")
                        .font(AppFonts.gothicCaption(12))
                        .foregroundColor(AppColors.brightYellow.opacity(0.8))
                    
                    Text(example)
                        .font(AppFonts.gothicCaption(13))
                        .foregroundColor(AppColors.cardWhite.opacity(0.9))
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                )
            }
            
            if let tip = pattern.tip {
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.brightYellow)
                    
                    Text(tip)
                        .font(AppFonts.gothicCaption(12))
                        .foregroundColor(AppColors.brightYellow.opacity(0.9))
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppColors.brightYellow.opacity(0.1))
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardWhite.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private func tipRow(_ text: String) -> some View {
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
    
    private func dotenkoStep(number: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(AppFonts.gothicHeadline(20))
                .fontWeight(.bold)
                .foregroundStyle(AppGradients.logoGradient)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .overlay(
                            Circle()
                                .stroke(AppColors.brightYellow.opacity(0.5), lineWidth: 1)
                        )
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(AppFonts.gothicBody(16))
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.brightYellow)
                
                Text(description)
                    .font(AppFonts.gothicCaption(14))
                    .foregroundColor(AppColors.cardWhite.opacity(0.9))
                    .lineSpacing(2)
            }
            
            Spacer()
        }
    }
    
    private func winTypeCard(title: String, description: String, example: String, color: Color, icon: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(AppFonts.gothicBody(16))
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                
                Text(description)
                    .font(AppFonts.gothicCaption(14))
                    .foregroundColor(AppColors.cardWhite.opacity(0.9))
                
                Text(example)
                    .font(AppFonts.gothicCaption(12))
                    .foregroundColor(color.opacity(0.8))
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
    
    private func cardExample(_ text: String) -> some View {
        Text(text)
            .font(AppFonts.gothicBody(18))
            .fontWeight(.semibold)
            .foregroundColor(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
            )
    }
    
    private func pointElement(_ label: String, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(AppFonts.gothicCaption(12))
                .foregroundColor(AppColors.cardWhite.opacity(0.7))
            
            Text(value)
                .font(AppFonts.gothicBody(18))
                .fontWeight(.semibold)
                .foregroundColor(AppColors.cardWhite)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.3))
        )
    }
    
    private func resultRow(_ player: String, _ points: String, _ isWin: Bool) -> some View {
        HStack {
            Text(player)
                .font(AppFonts.gothicBody(14))
                .foregroundColor(AppColors.cardWhite)
            
            Spacer()
            
            Text(points)
                .font(AppFonts.gothicBody(16))
                .fontWeight(.semibold)
                .foregroundColor(isWin ? AppColors.brightYellow : AppColors.hotRed)
        }
    }
    
    private func jokerRule(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "crown.fill")
                .font(.system(size: 12))
                .foregroundColor(AppColors.brightYellow.opacity(0.8))
                .padding(.top, 2)
            
            Text(text)
                .font(AppFonts.gothicBody(14))
                .foregroundColor(AppColors.cardWhite.opacity(0.9))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func bonusCard(_ card: String, _ effect: String, _ symbol: String, _ color: Color) -> some View {
        HStack {
            Text(card)
                .font(AppFonts.gothicBody(14))
                .foregroundColor(AppColors.cardWhite)
            
            Spacer()
            
            Text(effect)
                .font(AppFonts.gothicBody(14))
                .fontWeight(.semibold)
                .foregroundColor(color)
            
            Text(symbol)
                .font(AppFonts.gothicHeadline(18))
                .fontWeight(.bold)
                .foregroundColor(color)
                .frame(width: 30)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private func challengeRule(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "flame.fill")
                .font(.system(size: 12))
                .foregroundColor(AppColors.hotRed.opacity(0.8))
                .padding(.top, 2)
            
            Text(text)
                .font(AppFonts.gothicBody(14))
                .foregroundColor(AppColors.cardWhite.opacity(0.9))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: - Data
    private let gameFlowSteps = [
        (title: "カードをもらう", description: "最初に2枚のカードをもらいます"),
        (title: "5秒待つ", description: "みんながカードを見る時間です"),
        (title: "カードを出す", description: "ルールに従ってカードを出すか、山札から引きます"),
        (title: "どてんこチェック", description: "場の数字と手札の合計が同じか確認"),
        (title: "どてんこ宣言", description: "同じなら「どてんこ！」ボタンを押して勝利！")
    ]
    
    private struct PlayPattern {
        let number: Int
        let title: String
        let description: String
        let example: String?
        let tip: String?
    }
    
    private let playPatterns = [
        PlayPattern(
            number: 1,
            title: "同じ数字を出す",
            description: "場のカードと同じ数字なら、マークが違ってもOK！",
            example: "場に♠7があったら → ♥7を出せる",
            tip: "一番簡単な方法だよ！"
        ),
        PlayPattern(
            number: 2,
            title: "同じ数字を複数出す",
            description: "同じ数字を2枚以上持ってたら、まとめて出せる！",
            example: "場に♠7があったら → ♥7と♦7を一緒に出せる",
            tip: "まとめて出すと手札が減って有利！"
        ),
        PlayPattern(
            number: 3,
            title: "同じマークを出す",
            description: "場のカードと同じマーク（♠♥♦♣）なら、数字が違ってもOK！",
            example: "場に♠7があったら → ♠3や♠Kを出せる",
            tip: "マークを覚えておこう！"
        ),
        PlayPattern(
            number: 4,
            title: "同じマーク + 同じ数字",
            description: "場と同じマークのカードがあれば、同じ数字の他のカードも一緒に出せる！",
            example: "場に♠7があって、♠3と♥3を持ってたら → 両方出せる",
            tip: "最初に場と同じマークを選ぼう！"
        ),
        PlayPattern(
            number: 5,
            title: "足し算で出す",
            description: "複数のカードの合計が場の数字と同じなら出せる！",
            example: "場に13があったら → 6と7、または4と9を出せる",
            tip: "足し算が得意な人は有利！"
        )
    ]
}

// MARK: - Custom Tab Shape
struct CustomTabShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Rule Section Enum
enum RuleSection: String, CaseIterable, Identifiable {
    case objective = "基本"
    case playRules = "出し方"
    case dotenkoRules = "どてんこ"
    case special = "特殊"
    
    var id: String { rawValue }
    var title: String { rawValue }
    
    var icon: String {
        switch self {
        case .objective: return "flag.fill"
        case .playRules: return "rectangle.stack.fill"
        case .dotenkoRules: return "hands.sparkles.fill"
        case .special: return "star.fill"
        }
    }
}

#Preview {
    BasicRulesView()
        .padding()
        .background(AppGradients.primaryBackground)
}