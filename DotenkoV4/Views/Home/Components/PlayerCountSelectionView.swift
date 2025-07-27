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
                    PlayerCountButton(
                        count: count,
                        selectedPlayerCount: $selectedPlayerCount
                    )
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
                .font(AppFonts.gothicHeadline(18))
                .foregroundStyle(AppGradients.logoGradient)
            
            Spacer()
        }
    }
    
}

// MARK: - 個別プレイヤー数ボタンコンポーネント
struct PlayerCountButton: View {
    let count: Int
    @Binding var selectedPlayerCount: Int
    @State private var isPressed = false
    @State private var animatedScale: CGFloat = 1.0
    
    private var isSelected: Bool {
        selectedPlayerCount == count
    }
    
    var body: some View {
        Button(action: handleTap) {
            Text("\(count)")
                .font(AppFonts.gothicHeadline(22))
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .black : AppColors.cardWhite)
                .frame(width: 55, height: 55)
                .background(buttonBackground)
                .scaleEffect(animatedScale)
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, perform: {}) { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }
        .onChange(of: isSelected, initial: true) { _, newValue in
            if newValue {
                withAnimation(.interpolatingSpring(stiffness: 400, damping: 12)) {
                    animatedScale = 1.05
                }
            } else {
                animatedScale = 1.0
            }
        }
    }
    
    private func handleTap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        selectedPlayerCount = count
    }
    
    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(isSelected ? 
                AnyShapeStyle(AppGradients.logoGradient) : 
                AnyShapeStyle(Color.black.opacity(0.3)))
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.brightYellow, lineWidth: 2)
                        .blur(radius: 4)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardWhite.opacity(0.4), lineWidth: 1)
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
