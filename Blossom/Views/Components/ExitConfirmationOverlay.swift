//
//  ExitConfirmationOverlay.swift
//  Blossom (拾月)
//
//  Custom exit confirmation dialog for exercises
//  Replaces system .alert — shared by Kegel + Lamaze
//

import SwiftUI

struct ExitConfirmationOverlay: View {
    @Binding var isPresented: Bool
    var onContinue: () -> Void = {}
    var onExit: () -> Void

    var body: some View {
        if isPresented {
            ZStack {
                // Overlay mask: rgba(0,0,0,0.3)
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented = false
                        onContinue()
                    }

                // Dialog card
                VStack(spacing: 0) {
                    // Title: Noto Serif SC 18px weight:400 text-dark
                    Text("确定要结束练习吗？")
                        .font(.custom("NotoSerifSC-Regular", size: 18))
                        .foregroundStyle(Color(hex: "3A2F50"))

                    // Subtitle: 13px text-light, margin-bottom 24px
                    Text("当前进度不会保存")
                        .font(.custom("Nunito-Regular", size: 13))
                        .foregroundStyle(Color(hex: "AEA3C4"))
                        .padding(.top, 8)
                        .padding(.bottom, 24)

                    // Buttons: flex gap 12px
                    HStack(spacing: 12) {
                        // "继续练习": rgba(255,255,255,0.6) bg + border rgba(183,168,214,0.2)
                        Button(action: {
                            isPresented = false
                            onContinue()
                        }) {
                            Text("继续练习")
                                .font(.custom("Nunito-Medium", size: 14))
                                .foregroundStyle(Color(hex: "3A2F50"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(hex: "B7A8D6").opacity(0.2), lineWidth: 1)
                                )
                        }

                        // "结束": accent bg, white text, shadow
                        Button(action: {
                            isPresented = false
                            onExit()
                        }) {
                            Text("结束")
                                .font(.custom("Nunito-SemiBold", size: 14))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(hex: "C9A0DC"))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: Color(hex: "C4A0DC").opacity(0.15), radius: 4, y: 2)
                        }
                    }
                }
                .padding(28)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.white.opacity(0.85))
                )
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.7), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.12), radius: 20, y: 8)
                .padding(.horizontal, 40)
            }
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.2), value: isPresented)
        }
    }
}

#Preview {
    ZStack {
        Color(hex: "F0EAF5").ignoresSafeArea()
        ExitConfirmationOverlay(
            isPresented: .constant(true),
            onExit: {}
        )
    }
}
