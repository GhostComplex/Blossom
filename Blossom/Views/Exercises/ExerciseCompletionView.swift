//
//  ExerciseCompletionView.swift
//  Blossom (拾月)
//
//  练习完成页 — 凯格尔/拉玛泽完成后展示
//  Design v2 PRD §6, §16
//
//  导航: 计时器完成 → fullScreenCover → 点击「返回首页」→ dismiss
//

import SwiftUI

struct ExerciseCompletionView: View {
    let exerciseName: String
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient.pageBackground
                .ignoresSafeArea()

            // Decorative halos
            decorativeHalos

            VStack(spacing: 28) {
                Spacer()

                // Frosted check circle
                checkCircle

                // Title
                Text("做得真棒")
                    .font(.custom("CormorantGaramond-Light", size: 28))
                    .foregroundStyle(Color.n900)

                // Body text
                Text("今日\(exerciseName)已完成，坚持就是最好的准备。")
                    .font(AppFonts.bodyText)
                    .foregroundStyle(Color.n500)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                // English hint
                Text("It's the moment you show up for you.")
                    .font(.custom("CormorantGaramond-Regular", size: 12))
                    .foregroundStyle(Color.n300)
                    .italic()

                Spacer()

                // Return button
                Button(action: onDismiss) {
                    Text("返回首页")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.primary600)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }

    // MARK: - Check Circle
    private var checkCircle: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(Color.primary600.opacity(0.12))
                .frame(width: 120, height: 120)
                .blur(radius: 20)

            // Frosted circle
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 80, height: 80)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                )
                .shadow(color: Color(hex: "C4B5E0").opacity(0.15), radius: 16, x: 0, y: 8)

            // Check icon
            Image(systemName: "checkmark")
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(Color.primary600)
        }
    }

    // MARK: - Decorative Halos
    private var decorativeHalos: some View {
        ZStack {
            // Top-right halo
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.accentPeach.opacity(0.25), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 120
                    )
                )
                .frame(width: 240, height: 240)
                .offset(x: 100, y: -200)

            // Bottom-left halo
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.primary600.opacity(0.15), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .frame(width: 200, height: 200)
                .offset(x: -80, y: 200)
        }
    }
}

#Preview {
    ExerciseCompletionView(exerciseName: "凯格尔运动") {
        print("dismiss")
    }
}
