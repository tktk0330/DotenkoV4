//
//  PlayerCountSelectionView.swift
//  DotenkoV4
//
//  プレイヤー数選択コンポーネント
//

import SwiftUI

struct PlayerCountSelectionView: View {
    @Binding var selectedPlayerCount: Int
    
    var body: some View {
        VStack(spacing: 16) {
            headerView
            
            HStack(spacing: 12) {
                ForEach(2...5, id: \.self) { count in
                    playerCountButton(count: count)
                }
            }
        }
        .padding(20)
        .cardBackground()
    }
    
    // MARK: - ヘッダー
    private var headerView: some View {
        HStack {
            Image(systemName: "person.3.fill")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(AppGradients.logoGradient)
            
            Text("プレイヤー数")
                .font(AppFonts.elegantHeadline(18))
                .foregroundStyle(AppGradients.logoGradient)
            
            Spacer()
        }
    }
    
    
    // MARK: - プレイヤー数ボタン
    private func playerCountButton(count: Int) -> some View {
        Button(action: {
            withAnimation(.interpolatingSpring(stiffness: 400, damping: 12)) {
                selectedPlayerCount = count
            }
            // ハプティックフィードバック
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }) {
            Text("\(count)")
                .font(AppFonts.elegantHeadline(22))
                .fontWeight(.bold)
                .foregroundColor(selectedPlayerCount == count ? .black : AppColors.cardWhite)
                .frame(width: 55, height: 55)
                .background(buttonBackground(isSelected: selectedPlayerCount == count))
                .scaleEffect(selectedPlayerCount == count ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - ボタン背景
    private func buttonBackground(isSelected: Bool) -> some View {
        ZStack {
            if isSelected {
                // 選択時の背景
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppGradients.logoGradient)
                
                // グロー効果
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.brightYellow, lineWidth: 2)
                    .blur(radius: 4)
            } else {
                // 未選択時の背景
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardWhite.opacity(0.4), lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    @State var selectedPlayerCount = 3
    return PlayerCountSelectionView(
        selectedPlayerCount: $selectedPlayerCount
    )
    .background(AppGradients.primaryBackground)
    .padding()
}