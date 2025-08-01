//
//  PlayersSection.swift
//  DotenkoV4
//
//  プレイヤー情報セクションコンポーネント
//  - プレイヤーリストの表示
//  - Phase 1テストモードの注意書き表示
//

import SwiftUI
import SwiftData

// MARK: - プレイヤーセクション
struct PlayersSection: View {
    // MARK: - プロパティ
    let matchingInfo: MatchingInfo           // マッチング情報
    let currentProfile: UserProfile?         // 現在のユーザープロフィール
    
    // MARK: - ボディ
    var body: some View {
        VStack(spacing: 24) {
            // セクションタイトル
            sectionTitle
            
            // プレイヤーリスト
            playersList
            
            // Phase 1 注意書き
            if matchingInfo.isVsCPUMode {
                phase1NoticeView
            }
        }
        .padding(24)
        .cardBackground()
    }
    
    // MARK: - セクションタイトル
    private var sectionTitle: some View {
        HStack {
            Image(systemName: "person.3.fill")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(AppGradients.logoGradient)
            
            Text("参加プレイヤー")
                .font(AppFonts.gothicHeadline(22))
                .foregroundStyle(AppColors.primaryText)
            
            Spacer()
            
            playerCountBadge
        }
    }
    
    // MARK: - プレイヤー数バッジ
    private var playerCountBadge: some View {
        Text("\(matchingInfo.playerCount)/\(matchingInfo.playerCount)")
            .font(AppFonts.gothicBody(16))
            .foregroundStyle(AppColors.accentText)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.accentText.opacity(0.2))
            )
    }
    
    // MARK: - プレイヤーリスト
    private var playersList: some View {
        VStack(spacing: 12) {
            ForEach(1...matchingInfo.playerCount, id: \.self) { index in
                PlayerInfoRow(
                    playerNumber: index,
                    isMainPlayer: index == 1,
                    userProfile: currentProfile
                )
            }
        }
    }
    
    // MARK: - Phase 1 注意書き
    private var phase1NoticeView: some View {
        VStack(spacing: 12) {
            // 区切り線
            Rectangle()
                .fill(AppGradients.logoGradient)
                .frame(height: 1)
                .opacity(0.3)
            
            // 注意書き内容
            HStack(spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(AppColors.accentText)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Phase 1: テストプレイモード")
                        .font(AppFonts.gothicBody(16))
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.primaryText)
                    
                    Text("全プレイヤーを手動で操作して、ゲームロジックを確認します")
                        .font(AppFonts.gothicCaption(14))
                        .foregroundStyle(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - プレビュー
#Preview {
    PlayersSection(
        matchingInfo: MatchingInfo(
            gameMode: "vs CPU",
            playerCount: 3,
            rounds: 10,
            jokerCount: 2,
            gameRate: 10
        ),
        currentProfile: nil
    )
    .background(AppColors.primaryBackground)
}