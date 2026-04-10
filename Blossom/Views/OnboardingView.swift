//
//  OnboardingView.swift
//  Blossom (如期)
//
//  首次启动预产期设置页面
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedDate = Calendar.current.date(
        byAdding: .month, value: 2, to: Date()
    ) ?? Date()
    @State private var animateIn = false
    
    var onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient.pageBackground
                .ignoresSafeArea()
            
            VStack(spacing: AppSpacing.xxxl) {
                Spacer()
                
                // Welcome icon
                VStack(spacing: 16) {
                    Text("🌸")
                        .font(.system(size: 72))
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : -20)
                    
                    Text("欢迎来到如期")
                        .font(AppFonts.pageTitle)
                        .foregroundStyle(Color.primaryDark)
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : -10)
                    
                    Text("请设置你的预产期，我们将为你定制孕期计划")
                        .font(AppFonts.bodyText)
                        .foregroundStyle(Color.n500)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .opacity(animateIn ? 1 : 0)
                }
                
                Spacer()
                
                // Date picker
                VStack(spacing: 12) {
                    Text("预产期")
                        .font(AppFonts.cardTitle)
                        .foregroundStyle(Color.n700)
                    
                    DatePicker(
                        "预产期",
                        selection: $selectedDate,
                        in: Date()...,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "zh-Hans"))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.lg)
                        .fill(.ultraThinMaterial)
                )
                .padding(.horizontal, AppSpacing.pageHorizontal)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 30)
                
                Spacer()
                
                // Confirm button
                Button(action: completeOnboarding) {
                    Text("开始我的孕期之旅")
                        .font(AppFonts.cardTitle)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: AppRadius.full)
                                .fill(LinearGradient.progressBar)
                        )
                }
                .padding(.horizontal, AppSpacing.pageHorizontal)
                .padding(.bottom, 40)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 20)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateIn = true
            }
        }
    }
    
    private func completeOnboarding() {
        // Create user profile with selected due date
        let profile = UserProfile(dueDate: selectedDate)
        modelContext.insert(profile)
        
        // Create today's daily task
        let todayTask = DailyTask(date: Date())
        modelContext.insert(todayTask)
        
        // Ensure data is persisted before transitioning
        try? modelContext.save()
        
        onComplete()
    }
}

#Preview {
    OnboardingView(onComplete: {})
        .modelContainer(for: [UserProfile.self, DailyTask.self], inMemory: true)
}
