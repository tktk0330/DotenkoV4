//
//  ErrorPopupView.swift
//  DotenkoV4
//
//  エラーポップアップビュー
//  ネットワークエラーや認証エラーを表示
//

import SwiftUI

struct ErrorPopupView: View {
    let error: Error
    let retryAction: (() -> Void)?
    let dismissAction: () -> Void
    
    var body: some View {
        ZStack {
            // 背景オーバーレイ
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    // 背景タップで閉じない（モーダル）
                }
            
            // ポップアップコンテンツ
            VStack(spacing: 20) {
                // エラーアイコン
                errorIcon
                
                // エラータイトル
                Text("エラーが発生しました")
                    .font(AppFonts.gothicHeadline(20))
                    .foregroundColor(AppColors.cardWhite)
                
                // エラーメッセージ
                Text(errorMessage)
                    .font(AppFonts.gothicBody(14))
                    .foregroundColor(AppColors.cardWhite.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // リカバリー提案
                if let suggestion = recoverySuggestion {
                    Text(suggestion)
                        .font(AppFonts.gothicCaption(12))
                        .foregroundColor(AppColors.brightYellow)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // アクションボタン
                actionButtons
            }
            .padding(24)
            .frame(maxWidth: 320)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColors.dotenkoGreen,
                                AppColors.dotenkoGreen.opacity(0.8)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppColors.hotRed, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 10)
        }
    }
    
    // MARK: - エラーアイコン
    private var errorIcon: some View {
        ZStack {
            Circle()
                .fill(AppColors.hotRed.opacity(0.2))
                .frame(width: 80, height: 80)
            
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(AppColors.hotRed)
        }
    }
    
    // MARK: - エラーメッセージ
    private var errorMessage: String {
        if let authError = error as? AuthManager.AuthError {
            return authError.errorDescription ?? "不明なエラーが発生しました"
        }
        return error.localizedDescription
    }
    
    // MARK: - リカバリー提案
    private var recoverySuggestion: String? {
        if let authError = error as? AuthManager.AuthError {
            return authError.recoverySuggestion
        }
        return nil
    }
    
    // MARK: - アクションボタン
    private var actionButtons: some View {
        HStack(spacing: 16) {
            // 閉じるボタン
            Button(action: dismissAction) {
                Text("閉じる")
                    .font(AppFonts.gothicBody(16))
                    .foregroundColor(AppColors.cardWhite)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.cardWhite.opacity(0.5), lineWidth: 1)
                            )
                    )
            }
            
            // リトライボタン（オプション）
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    Text("再試行")
                        .font(AppFonts.gothicBody(16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.brightYellow)
                        )
                }
            }
        }
    }
}

// MARK: - プレビュー
#Preview("ネットワークエラー") {
    ErrorPopupView(
        error: AuthManager.AuthError.networkError,
        retryAction: {
            print("リトライ")
        },
        dismissAction: {
            print("閉じる")
        }
    )
}

#Preview("認証エラー") {
    ErrorPopupView(
        error: AuthManager.AuthError.authenticationFailed,
        retryAction: nil,
        dismissAction: {
            print("閉じる")
        }
    )
}