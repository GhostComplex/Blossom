//
//  OnboardingView.swift
//  Blossom (拾月)
//
//  首次启动预产期设置页面
//  Design spec: ④ 首次使用 · 预产期设置 + ④-b 日期选择态
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedYear: Int
    @State private var selectedMonth: Int
    @State private var selectedDay: Int
    @State private var animateIn = false
    @State private var showDatePicker = false
    
    var onComplete: () -> Void
    
    // Date ranges
    private let years: [Int]
    private let months = Array(1...12)
    
    private var days: [Int] {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        if let date = calendar.date(from: components),
           let range = calendar.range(of: .day, in: .month, for: date) {
            return Array(range)
        }
        return Array(1...31)
    }
    
    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        let calendar = Calendar.current
        let defaultDate = calendar.date(byAdding: .month, value: 2, to: Date()) ?? Date()
        let currentYear = calendar.component(.year, from: Date())
        self.years = Array((currentYear - 1)...(currentYear + 2))
        self._selectedYear = State(initialValue: calendar.component(.year, from: defaultDate))
        self._selectedMonth = State(initialValue: calendar.component(.month, from: defaultDate))
        self._selectedDay = State(initialValue: calendar.component(.day, from: defaultDate))
    }
    
    private var selectedDate: Date {
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        components.day = selectedDay
        return Calendar.current.date(from: components) ?? Date()
    }
    
    // Formatted date components
    private var yearText: String {
        String(format: "%04d", selectedYear)
    }
    
    private var monthText: String {
        String(format: "%02d", selectedMonth)
    }
    
    private var dayText: String {
        String(format: "%02d", selectedDay)
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient.pageBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Fixed top padding — flower/title/subtitle stay at same position
                // regardless of card height (default vs picker state)
                Color.clear.frame(height: 0)
                    .padding(.top, 120)
                
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
                
                // Date card — two states
                Group {
                    if showDatePicker {
                        datePickerCard
                    } else {
                        dateDisplayCard
                    }
                }
                .padding(.bottom, 24)
                
                // CTA Button — same position for both states
                if showDatePicker {
                    Button(action: confirmDate) {
                        Text("确定")
                            .font(.custom("Nunito-SemiBold", size: 14))
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
                } else {
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
                }
                
                Spacer()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showDatePicker)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateIn = true
            }
        }
    }
    
    // MARK: - Default State: Date Display Card
    
    private var dateDisplayCard: some View {
        VStack(spacing: 0) {
            // Label
            Text("预产期")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color.n300)
                .padding(.bottom, 10)
            
            // Large date numbers
            Button(action: { showDatePicker = true }) {
                HStack(spacing: 0) {
                    Text(yearText)
                        .font(.custom("NotoSerifSC-Regular", size: 20))
                        .foregroundStyle(Color.n900)
                    
                    Text(" 年 ")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.n300)
                    
                    Text(monthText)
                        .font(.custom("NotoSerifSC-Regular", size: 40))
                        .foregroundStyle(Color(hex: "A87CC0"))
                    
                    Text(" 月 ")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.n300)
                    
                    Text(dayText)
                        .font(.custom("NotoSerifSC-Regular", size: 40))
                        .foregroundStyle(Color(hex: "A87CC0"))
                    
                    Text(" 日")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.n300)
                }
            }
            .accessibilityIdentifier("dateDisplay")
            
            // Hint
            Text("点击选择日期")
                .font(.custom("Nunito-Regular", size: 10))
                .foregroundStyle(Color.n300)
                .padding(.top, 8)
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 22)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
        .padding(.horizontal, AppSpacing.pageHorizontal)
        .opacity(animateIn ? 1 : 0)
        .offset(y: animateIn ? 0 : 30)
    }
    
    // MARK: - Selection State: Custom Wheel Picker
    
    private var datePickerCard: some View {
        VStack(spacing: 0) {
            // Label
            Text("选择预产期")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color.n300)
                .padding(.bottom, 10)
            
            // Custom wheel area — design: flex row with year/月/day labels between columns
            ZStack {
                // Highlight bar — centered vertically
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "C4A0DC").opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "C4A0DC").opacity(0.12), lineWidth: 1)
                    )
                    .frame(height: 36)
                    .padding(.horizontal, 12)
                
                // Three columns with labels between them
                HStack(spacing: 8) {
                    // Year column
                    DragWheelColumn(
                        items: years.map { "\($0)" },
                        selectedIndex: Binding(
                            get: { years.firstIndex(of: selectedYear) ?? 0 },
                            set: { selectedYear = years[$0] }
                        )
                    )
                    
                    // 年 label
                    Text("年")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.n300)
                    
                    // Month column
                    DragWheelColumn(
                        items: months.map { "\($0)" },
                        selectedIndex: Binding(
                            get: { months.firstIndex(of: selectedMonth) ?? 0 },
                            set: { selectedMonth = months[$0] }
                        )
                    )
                    
                    // 月 label
                    Text("月")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.n300)
                    
                    // Day column
                    DragWheelColumn(
                        items: days.map { "\($0)" },
                        selectedIndex: Binding(
                            get: {
                                let idx = days.firstIndex(of: selectedDay) ?? 0
                                return min(idx, days.count - 1)
                            },
                            set: { selectedDay = days[$0] }
                        )
                    )
                    
                    // 日 label
                    Text("日")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.n300)
                }
                .padding(.horizontal, 12)
            }
            .frame(height: 120)
            .clipped()
            
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 22)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
        .padding(.horizontal, AppSpacing.pageHorizontal)
        .opacity(animateIn ? 1 : 0)
        .offset(y: animateIn ? 0 : 30)
    }
    
    // MARK: - Shared Card Background
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 22)
            .fill(Color.cardBg)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.accentPeach.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: Color(hex: "C4B5E0").opacity(0.08), radius: 16, y: 2)
    }
    
    // MARK: - Actions
    
    private func confirmDate() {
        let maxDay = days.last ?? 31
        if selectedDay > maxDay {
            selectedDay = maxDay
        }
        showDatePicker = false
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

#Preview {
    OnboardingView(onComplete: {})
        .modelContainer(for: [UserProfile.self, DailyTask.self], inMemory: true)
}
