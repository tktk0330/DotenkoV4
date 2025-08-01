//
//  MatchingView.swift
//  DotenkoV4
//
//  メインマッチング画面
//  - コンポーネントベースでリファクタリング済み
//  - GameManagerとの連携を管理
//

import SwiftUI
import SwiftData

// MARK: - メインマッチングビュー
struct MatchingView: View {
    // MARK: - プロパティ
    @StateObject private var gameManager = GameManager()
    @Environment(\.modelContext) private var modelContext
    @Query private var userProfiles: [UserProfile]
    @EnvironmentObject private var navigationManager: NavigationStateManager
    
    let matchingInfo: MatchingInfo
    
    // MARK: - 計算プロパティ
    private var currentProfile: UserProfile? {
        userProfiles.first
    }
    
    // MARK: - 初期化
    init(matchingInfo: MatchingInfo) {
        self.matchingInfo = matchingInfo
    }
    
    // MARK: - メインビュー
    var body: some View {
        ZStack {
            // 背景
            AppColors.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ヘッダー
                MatchingHeader(onBackTapped: handleBackTapped)
                
                // メインコンテンツ
                ScrollView {
                    VStack(spacing: 32) {
                        // プレイヤー情報セクション
                        PlayersSection(
                            matchingInfo: matchingInfo,
                            currentProfile: currentProfile
                        )
                        
                        // ゲーム開始ボタン
                        StartGameButton(onTapped: handleStartGame)
                        
                        Spacer(minLength: 100) // バナー広告スペース
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
    
    // MARK: - アクションメソッド
    
    /// 戻るボタンタップ時の処理
    private func handleBackTapped() {
        navigationManager.pop()
    }
    
    /// ゲーム開始ボタンタップ時の処理
    private func handleStartGame() {
        // GameManagerでゲーム開始
        gameManager.startNewGame(playerCount: matchingInfo.playerCount)
        
        // ゲーム画面に遷移
        navigationManager.push(GameView(gameManager: gameManager))
    }
}

// MARK: - プレビュー
#Preview {
    MatchingView(matchingInfo: MatchingInfo.defaultInfo(
        gameMode: "vs CPU",
        playerCount: 3
    ))
    .environmentObject(NavigationStateManager())
}