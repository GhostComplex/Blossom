//
//  OnboardingView.swift
//  Blossom (拾月)
//
//  首次启动预产期设置页面
//  Design spec: ⑫ 首次使用 · 预产期设置
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedDate = Calendar.current.date(
        byAdding: .month, value: 2, to: Date()
    ) ?? Date()
    @State private var animateIn = false
    @State private var showDatePicker = false
    
    var onComplete: () -> Void
    
    // Formatted date components
    private var yearText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: selectedDate)
    }
    
    private var monthText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter.string(from: selectedDate)
    }
    
    private var dayText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient.pageBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // App Icon 花朵 + 呼吸动效
                BlossomFlowerIcon(size: 88)
                    .shadow(color: Color.primary600.opacity(0.25), radius: 16, y: 4)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : -20)
                .padding(.bottom, 24)
                
                // Title
                Text("欢迎来到拾月")
                    .font(.custom("NotoSerifSC-Regular", size: 28))
                    .foregroundStyle(Color.n900)
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : -10)
                    .padding(.bottom, 8)
                
                // Subtitle
                Text("告诉我们宝宝的预产期\n我们会陪你一起做好准备")
                    .font(.custom("Nunito-Regular", size: 13))
                    .foregroundStyle(Color.n500)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(animateIn ? 1 : 0)
                    .padding(.bottom, 32)
                
                // Date display card (glassmorphism)
                VStack(spacing: 0) {
                    // Label
                    Text("预产期")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.n500)
                        .padding(.bottom, 12)
                    
                    // Large date numbers
                    Button(action: { showDatePicker.toggle() }) {
                        HStack(spacing: 0) {
                            // Year
                            Text(yearText)
                                .font(.custom("NotoSerifSC-Regular", size: 20))
                                .foregroundStyle(Color.n900)
                            
                            Text(" 年 ")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.n300)
                            
                            // Month
                            Text(monthText)
                                .font(.custom("NotoSerifSC-Regular", size: 40))
                                .foregroundStyle(Color.primary600)
                            
                            Text(" 月 ")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.n300)
                            
                            // Day
                            Text(dayText)
                                .font(.custom("NotoSerifSC-Regular", size: 40))
                                .foregroundStyle(Color.primary600)
                            
                            Text(" 日")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.n300)
                        }
                    }
                    .accessibilityIdentifier("dateDisplay")
                    
                    // Hint
                    Text("点击选择日期")
                        .font(.custom("Nunito-Regular", size: 10))
                        .foregroundStyle(Color.n500)
                        .padding(.top, 10)
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.cardBg)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.accentPeach.opacity(0.18), lineWidth: 1)
                        )
                        .shadow(color: Color(hex: "C4B5E0").opacity(0.07), radius: 4, y: 2)
                )
                .padding(.horizontal, AppSpacing.pageHorizontal)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 30)
                
                .padding(.bottom, 24)
                
                // CTA Button
                Button(action: completeOnboarding) {
                    HStack {
                        Text("开始使用")
                            .font(.custom("Nunito-SemiBold", size: 14))
                        Text("→")
                            .font(.custom("Nunito-SemiBold", size: 14))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "C9A0DC"))
                    )
                    .shadow(color: Color(hex: "C4A0DC").opacity(0.2), radius: 16, y: 4)
                }
                .padding(.horizontal, AppSpacing.pageHorizontal)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 20)
                .padding(.bottom, 16)
                
                Spacer()
            }
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(selectedDate: $selectedDate)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateIn = true
            }
        }
    }
    
    private func completeOnboarding() {
        let profile = UserProfile(dueDate: selectedDate)
        modelContext.insert(profile)
        
        let todayTask = DailyTask(date: Date())
        modelContext.insert(todayTask)
        
        try? modelContext.save()
        
        onComplete()
    }
}

// MARK: - Date Picker Sheet

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("选择预产期")
                .font(.custom("NotoSerifSC-Regular", size: 20))
                .foregroundStyle(Color.n900)
                .padding(.top, 20)
            
            DatePicker(
                "预产期",
                selection: $selectedDate,
                in: Date()...,
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .environment(\.locale, Locale(identifier: "zh-Hans"))
            
            Button(action: { dismiss() }) {
                Text("确定")
                    .font(.custom("Nunito-SemiBold", size: 14))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.full)
                            .fill(LinearGradient.progressBar)
                    )
            }
            .padding(.horizontal, AppSpacing.pageHorizontal)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
        .modelContainer(for: [UserProfile.self, DailyTask.self], inMemory: true)
}
