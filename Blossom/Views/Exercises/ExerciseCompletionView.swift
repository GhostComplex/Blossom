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
            // #1 — Background: custom completion gradient 165deg
            LinearGradient(
                colors: [
                    Color(hex: "FEF4F7"),
                    Color(hex: "F0E6F6"),
                    Color(hex: "E6EAF8"),
                    Color(hex: "E8F0FC")
                ],
                startPoint: UnitPoint(x: 0.36, y: 0),
                endPoint: UnitPoint(x: 0.64, y: 1)
            )
            .ignoresSafeArea()

            // Decorative halos (#24-25)
            decorativeHalos

            // justify-content: center — all content vertically centered
            VStack(spacing: 0) {
                // Frosted check circle (#2-7)
                checkCircle
                    .padding(.bottom, 28)

                // Title (#8-10)
                Text("做得真棒")
                    .font(.custom("NotoSerifSC-Regular", size: 30))
                    .tracking(-0.3)
                    .foregroundStyle(Color.n900)
                    .padding(.bottom, 10)

                // #16 — Merged body text (single Text)
                // #11 — font 14px Nunito-Light
                // #13 — weight light
                // #15 — line-height 1.6 → lineSpacing(8.4)
                Text("今天的\(exerciseName)已完成，坚持下去，和宝宝见面那天会更从容")
                    .font(.custom("Nunito-Regular", size: 14))
                    .fontWeight(.light)
                    .lineSpacing(8.4)
                    .foregroundStyle(Color.n500)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 44)

                // #21-23 — Return button (design order: sub → btn → hint)
                Button(action: onDismiss) {
                    Text("返回首页")
                        .font(.custom("Nunito-SemiBold", size: 14))
                        .tracking(0.3)
                        .foregroundStyle(.white)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 44)
                        .background(Color.primary600)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                }
                .shadow(color: Color(hex: "3A2F50").opacity(0.15), radius: 12, x: 0, y: 8)
                .padding(.bottom, 16)

                // #17-20 — English hint (below button per design)
                Text("It's the moment you show up for you.")
                    .font(.custom("Nunito-Italic", size: 11))
                    .fontWeight(.light)
                    .foregroundStyle(Color.n300)
                    .italic()
            }
            .frame(maxHeight: .infinity) // vertically centered
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

            // #2 — 72x72 circle
            // #3 — rgba(255,255,255,0.15) + blur(12)
            Circle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 72, height: 72)
                .blur(radius: 12)

            // #4 — 1.5px border rgba(196,160,220,0.3)
            Circle()
                .stroke(Color(hex: "C4A0DC").opacity(0.3), lineWidth: 1.5)
                .frame(width: 72, height: 72)

            // #7 — Check icon size 30
            Image(systemName: "checkmark")
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(Color.primary600)
        }
        // #6 — Double shadow
        .shadow(color: Color(hex: "C4A0DC").opacity(0.2), radius: 25, x: 0, y: 0)
        .shadow(color: Color(hex: "C4A0DC").opacity(0.1), radius: 50, x: 0, y: 0)
    }

    // MARK: - Decorative Halos
    private var decorativeHalos: some View {
        ZStack {
            // #24 — Halo 1: top:120px left:20px, 180x180, border rgba(196,160,220,0.08)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "C4A0DC").opacity(0.2), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 90
                    )
                )
                .overlay(
                    Circle()
                        .stroke(Color(hex: "C4A0DC").opacity(0.1), lineWidth: 1)
                )
                .frame(width: 180, height: 180)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(x: 20, y: 120)

            // #25 — Halo 2: bottom:140px right:10px, 140x140, border rgba(196,160,220,0.08)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "B8DCF5").opacity(0.2), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 70
                    )
                )
                .overlay(
                    Circle()
                        .stroke(Color(hex: "B8DCF5").opacity(0.08), lineWidth: 1)
                )
                .frame(width: 140, height: 140)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .offset(x: -10, y: -140)
        }
    }
}

#Preview {
    ExerciseCompletionView(exerciseName: "凯格尔运动") {
        print("dismiss")
    }
}
