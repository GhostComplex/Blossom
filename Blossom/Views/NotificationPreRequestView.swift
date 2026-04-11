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
            VStack(spacing: 20) {
                // Bell icon — semi-transparent pink-purple bg
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.accentPeach.opacity(0.4), Color.primary600.opacity(0.25)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "bell.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(Color.primaryDark)
                }
                .padding(.top, 8)
                
                // Title
                Text(title)
                    .font(.custom("CormorantGaramond-Light", size: 20))
                    .foregroundStyle(Color.n900)
                
                // Description
                Text(body_text)
                    .font(AppFonts.bodyText)
                    .foregroundStyle(Color.n500)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                
                // Buttons
                VStack(spacing: 12) {
                    // Primary: Accept
                    Button(action: onAccept) {
                        Text("好的，提醒我")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.primary600)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                    }
                    
                    // Secondary: Decline
                    Button(action: onDecline) {
                        Text("不了，谢谢")
                            .font(AppFonts.bodyText)
                            .foregroundColor(Color.n500)
                    }
                }
                .padding(.top, 4)
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white.opacity(0.45))
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(.ultraThinMaterial)
                    )
                    .shadow(color: Color.black.opacity(0.12), radius: 24, x: 0, y: 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
            )
            .padding(.horizontal, 40)
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
