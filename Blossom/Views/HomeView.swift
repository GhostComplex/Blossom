//
//  HomeView.swift
//  Blossom (如期)
//
//  Tab 1 - 首页：倒计时 + 今日任务入口
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query private var allTasks: [DailyTask]
    
    private var todayTasks: [DailyTask] {
        allTasks.filter { Calendar.current.isDateInToday($0.date) }
    }
    
    private var profile: UserProfile? { profiles.first }
    private var todayTask: DailyTask? { todayTasks.first }
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xxl) {
                // 顶部问候
                greetingHeader
                
                // 倒计时主卡片
                countdownCard
                
                // 今日任务 (2x2 Grid)
                taskGrid
                
                // 待产包进度
                hospitalBagProgress
            }
            .padding(.horizontal, AppSpacing.pageHorizontal)
            .padding(.vertical, AppSpacing.pageVertical)
        }
        .pageBackground()
        .onAppear {
            ensureProfileExists()
            ensureTodayTaskExists()
        }
    }
    
    // MARK: - Greeting Header
    private var greetingHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Date(), format: .dateTime.month().day().year())
                .font(AppFonts.caption)
                .foregroundStyle(Color.n500)
            
            Text(greetingText)
                .font(AppFonts.sectionTitle)
                .foregroundStyle(Color.n900)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "早上好"
        case 12..<18: return "下午好"
        case 18..<23: return "晚上好"
        default: return "夜深了，早点休息"
        }
    }
    
    // MARK: - Countdown Card
    private var countdownCard: some View {
        VStack(spacing: AppSpacing.lg) {
            // 孕周徽章
            if let profile = profile {
                let week = profile.currentPregnancyWeek
                Text("孕 \(week.week) 周 + \(week.day) 天")
                    .font(AppFonts.smallLabel)
                    .foregroundStyle(Color.n700)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.accentLight)
                    .clipShape(Capsule())
            }
            
            // 倒计时描述
            Text("距离与宝宝见面")
                .font(AppFonts.caption)
                .foregroundStyle(Color.n500)
            
            // 倒计时数字
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(profile?.daysUntilDue ?? 0)")
                    .font(AppFonts.countdownNumber)
                    .foregroundStyle(LinearGradient.countdownText)
                
                Text("天")
                    .font(AppFonts.countdownUnit)
                    .foregroundStyle(Color.n700)
            }
            
            Divider()
                .background(Color.n200)
            
            // 预产期信息
            if let profile = profile {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(Color.primary600)
                    Text("预产期 \(profile.dueDate, format: .dateTime.year().month().day())")
                        .font(AppFonts.caption)
                        .foregroundStyle(Color.n700)
                }
            }
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 28)
        .frame(maxWidth: .infinity)
        .glassCard(cornerRadius: AppRadius.xl)
    }
    
    // MARK: - Task Grid (2x2)
    private var taskGrid: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("今日任务")
                .font(AppFonts.cardTitle)
                .foregroundStyle(Color.n900)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: AppSpacing.cardSpacing),
                GridItem(.flexible(), spacing: AppSpacing.cardSpacing)
            ], spacing: AppSpacing.cardSpacing) {
                TaskGridCard(
                    icon: "figure.strengthtraining.traditional",
                    title: "凯格尔运动",
                    subtitle: todayTask?.kegelCompleted == true ? "✓ 已完成" : "待完成",
                    isCompleted: todayTask?.kegelCompleted ?? false
                )
                
                TaskGridCard(
                    icon: "wind",
                    title: "拉玛泽练习",
                    subtitle: todayTask?.lamazeCompleted == true ? "✓ 已完成" : "待完成",
                    isCompleted: todayTask?.lamazeCompleted ?? false
                )
                
                TaskGridCard(
                    icon: "bag.fill",
                    title: "待产包",
                    subtitle: "12/50 项",
                    isCompleted: false
                )
                
                TaskGridCard(
                    icon: "book.fill",
                    title: "分娩知识",
                    subtitle: "\(ArticleContent.allArticles.count) 篇待读",
                    isCompleted: false
                )
            }
        }
    }
    
    // MARK: - Hospital Bag Progress
    private var hospitalBagProgress: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("待产包准备进度")
                    .font(AppFonts.cardTitle)
                    .foregroundStyle(Color.n900)
                Spacer()
                Text("12 / 50")
                    .font(AppFonts.bodyText)
                    .foregroundStyle(Color.n500)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: AppRadius.full)
                        .fill(Color.n200)
                        .frame(height: 8)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: AppRadius.full)
                        .fill(LinearGradient.progressBar)
                        .frame(width: geometry.size.width * 0.24, height: 8)
                }
            }
            .frame(height: 8)
            
            Text("24%")
                .font(AppFonts.smallLabel)
                .foregroundStyle(Color.n500)
        }
        .padding(AppSpacing.cardPadding)
        .glassCard()
    }
    
    // MARK: - Data Setup
    private func ensureProfileExists() {
        if profiles.isEmpty {
            // Default: 预产期 2026年5月1日
            let dueDate = Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 1))!
            let profile = UserProfile(dueDate: dueDate)
            modelContext.insert(profile)
        }
    }
    
    private func ensureTodayTaskExists() {
        if todayTasks.isEmpty {
            let task = DailyTask(date: Date())
            modelContext.insert(task)
        }
    }
}

// MARK: - Task Grid Card
struct TaskGridCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let isCompleted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(isCompleted ? Color.success : Color.primaryDark)
                .frame(width: 44, height: 44)
                .background(isCompleted ? Color.success.opacity(0.15) : Color.accentLight)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppFonts.cardTitle)
                    .foregroundStyle(Color.n900)
                
                Text(subtitle)
                    .font(AppFonts.caption)
                    .foregroundStyle(isCompleted ? Color.success : Color.n500)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.cardPadding)
        .glassCard()
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [UserProfile.self, DailyTask.self], inMemory: true)
}
