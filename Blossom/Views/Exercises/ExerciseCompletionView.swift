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
            // Custom 4-stop gradient (design spec)
            LinearGradient(
                stops: [
                    .init(color: Color(hex: "FEF4F7"), location: 0.0),
                    .init(color: Color(hex: "F0E6F6"), location: 0.3),
                    .init(color: Color(hex: "E6EAF8"), location: 0.6),
                    .init(color: Color(hex: "E8F0FC"), location: 1.0)
                ],
                startPoint: UnitPoint(x: 0.41, y: 0.0),
                endPoint: UnitPoint(x: 0.59, y: 1.0)
            )
            .ignoresSafeArea()

            // Decorative halos
            decorativeHalos

            VStack(spacing: 0) {
                Spacer()

                // Frosted check circle
                checkCircle

                // 28px gap (check circle margin-bottom)

                // Title
                Text("做得真棒")
                    .font(.custom("NotoSerifSC-Regular", size: 30))
                    .foregroundStyle(Color.n900)
                    .tracking(-0.3)
                    .padding(.top, 28)

                // 10px gap title→sub
                // Body text (merged two lines into one)
                Text("今天的\(exerciseName)已完成\n坚持下去，和宝宝见面那天会更从容")
                    .font(.custom("Nunito", size: 14))
                    .fontWeight(.light)
                    .foregroundStyle(Color.n500)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8.4)
                    .padding(.top, 10)
                    .padding(.horizontal, 36)

                // 44px gap sub→button

                // Return button
                Button(action: onDismiss) {
                    Text("返回首页")
                        .font(.custom("Nunito-SemiBold", size: 14))
                        .foregroundStyle(.white)
                        .tracking(0.3)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 44)
                        .background(Color.primary600)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                }
                .shadow(color: Color(hex: "3A2F50").opacity(0.15), radius: 12, x: 0, y: 8)
                .padding(.top, 44)

                // Hint below button, margin-top 16
                Text("It's the moment you show up for you.")
                    .font(.custom("Nunito-Italic", size: 11))
                    .fontWeight(.light)
                    .foregroundStyle(Color.n300)
                    .italic()
                    .padding(.top, 16)

                Spacer()
            }
            .padding(.horizontal, 36)
        }
    }

    // MARK: - Check Circle
    private var checkCircle: some View {
        ZStack {
            // Frosted circle — 72x72 with white 0.15 bg + ultraThinMaterial backdrop approximation
            Circle()
                .fill(.ultraThinMaterial.opacity(0.3))
                .frame(width: 72, height: 72)
                .overlay(
                    Circle()
                        .fill(Color.white.opacity(0.15))
                )
                .overlay(
                    Circle()
                        .stroke(Color(hex: "C4A0DC").opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: Color(hex: "C4A0DC").opacity(0.2), radius: 25, x: 0, y: 0)
                .shadow(color: Color(hex: "C4A0DC").opacity(0.1), radius: 50, x: 0, y: 0)

            // Check icon
            Image(systemName: "checkmark")
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(Color.primary600)
        }
    }

    // MARK: - Decorative Halos
    private var decorativeHalos: some View {
        GeometryReader { geo in
            // Halo 1: top:120px left:20px, 180x180
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(hex: "C4A0DC").opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 90
                    )
                )
                .frame(width: 180, height: 180)
                .overlay(
                    Circle()
                        .stroke(Color(hex: "C4A0DC").opacity(0.1), lineWidth: 1)
                )
                .position(x: 20 + 90, y: 120 + 90)

            // Halo 2: bottom:140px right:10px, 140x140
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 184/255, green: 220/255, blue: 245/255).opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 70
                    )
                )
                .frame(width: 140, height: 140)
                .overlay(
                    Circle()
                        .stroke(Color(red: 184/255, green: 220/255, blue: 245/255).opacity(0.08), lineWidth: 1)
                )
                .position(x: geo.size.width - 10 - 70, y: geo.size.height - 140 - 70)
        }
    }
}

#Preview {
    ExerciseCompletionView(exerciseName: "凯格尔运动") {
        print("dismiss")
    }
}
