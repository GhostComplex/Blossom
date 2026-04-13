//
//  NotificationPreRequestView.swift
//  Blossom (拾月)
//
//  Custom pre-request popup for notification permission.
//  Shown after user completes their first task.
//  Frosted glass card with bell icon, warm theme colors.
//
//  PRD §4.5.2
//

import SwiftUI

struct NotificationPreRequestView: View {
    let triggerSource: NotificationManager.PreRequestTriggerSource
    let onAccept: () -> Void
    let onDecline: () -> Void
    
    private var title: String {
        switch triggerSource {
        case .exercise:
            return "每天提醒你练习"
        case .hospitalBag:
            return "别忘了每天的小任务"
        }
    }
    
    private var body_text: String {
        switch triggerSource {
        case .exercise:
            return "每天练几分钟，和宝宝见面那天会更从容。"
        case .hospitalBag:
            return "我们会在合适的时候提醒你练习和准备。"
        }
    }
    
    var body: some View {
        ZStack {
            // Blur background overlay
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    // Don't dismiss on background tap
                }
            
            // Frosted glass card
            VStack(spacing: 0) {
                // Bell icon — semi-transparent pink-purple bg
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "F9B5C4").opacity(0.4),   // #8: pink 0.4
                                    Color(hex: "C4B5E0").opacity(0.5)    // #8: lavender 0.5
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)                    // #7: 64→52
                    
                    Image(systemName: "bell")                            // #12: bell.fill→bell (outline)
                        .font(.system(size: 22))                         // #10: 28→22
                        .foregroundStyle(Color(hex: "A87CC0"))           // #11: accent-dark
                }
                .padding(.bottom, 16)                                    // #9: margin-bottom 16
                
                // Title
                Text(title)
                    .font(.custom("NotoSerifSC-Regular", size: 20))
                    .foregroundStyle(Color.n900)
                    .padding(.bottom, 6)                                 // #14: margin-bottom 6
                
                // Description
                Text(body_text)
                    .font(.custom("Nunito-Regular", size: 13))
                    .foregroundStyle(Color.n300)                          // #17: n500→n300
                    .lineSpacing(3)                                      // #18: line-height 1.5 → ~3pt
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 22)                                // #19: margin-bottom 22
                
                // Buttons
                VStack(spacing: 8) {                                     // #22: 12→8
                    // Primary: Accept
                    Button(action: onAccept) {
                        Text("好的，提醒我")
                            .font(.custom("Nunito-SemiBold", size: 14))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)                      // #20: 14→13
                            .background(Color.primary600)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                            .shadow(color: Color(hex: "C4A0DC").opacity(0.2), radius: 12, x: 0, y: 4)  // #23
                    }
                    
                    // Secondary: Decline
                    Button(action: onDecline) {
                        Text("不了，谢谢")
                            .font(.custom("Nunito-Regular", size: 12))
                            .foregroundColor(Color.n300)                 // #26: n500→n300
                            .padding(.vertical, 10)                      // #24: padding 10
                    }
                }
            }
            .padding(.top, 32)                                           // #3: 32t
            .padding(.horizontal, 24)                                    // #3: 24 sides
            .padding(.bottom, 24)                                        // #3: 24b
            .frame(width: 280)                                           // #1: fixed 280
            .background(
                RoundedRectangle(cornerRadius: 24)                       // #2: 28→24
                    .fill(Color.white.opacity(0.7))                      // #4: 0.45→0.7
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                    )
                    .shadow(color: Color(hex: "3A2F50").opacity(0.08), radius: 48, x: 0, y: 16)  // #5
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)                       // #2: 28→24
                    .stroke(Color.white.opacity(0.7), lineWidth: 1)      // #6: 0.6→0.7
            )
        }
        .transition(.opacity.combined(with: .scale(scale: 0.9)))
    }
}

#Preview {
    ZStack {
        LinearGradient.pageBackground
            .ignoresSafeArea()
        
        NotificationPreRequestView(
            triggerSource: .exercise,
            onAccept: { print("accept") },
            onDecline: { print("decline") }
        )
    }
}
