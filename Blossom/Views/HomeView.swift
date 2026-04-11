//
//  HomeView.swift
//  Blossom (拾月)
//
//  Tab 1 - 首页：倒计时 + 今日任务入口
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query private var allTasks: [DailyTask]
    @Query private var bagItems: [HospitalBagItem]
    @Binding var selectedTab: Int
    @State private var showKegelExercise = false
    @State private var showLamazeExercise = false
    
    private var todayTasks: [DailyTask] {
        allTasks.filter { Calendar.current.isDateInToday($0.date) }
    }
    
    private var profile: UserProfile? { profiles.first }
    private var todayTask: DailyTask? { todayTasks.first }
    
    private var bagTotal: Int { bagItems.count }
    private var bagCompleted: Int { bagItems.filter { $0.isCompleted }.count }
    
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
            ensureBagItemsExist()
        }
        .fullScreenCover(isPresented: $showKegelExercise) {
            KegelExerciseView()
        }
        .fullScreenCover(isPresented: $showLamazeExercise) {
            LamazeExerciseView()
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
                    .foregroundStyle(Color.n900)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.5))
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
                    .foregroundStyle(Color.n900)
                
                Text("天")
                    .font(AppFonts.countdownUnit)
                    .foregroundStyle(Color.n700)
            }
            
            Divider()
                .background(Color.white.opacity(0.4))
            
            // 预产期信息
            if let profile = profile {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(Color.primaryDark)
                    Text("预产期 \(profile.dueDate, format: .dateTime.year().month().day())")
                        .font(AppFonts.caption)
                        .foregroundStyle(Color.n900)
                }
            }
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 28)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .fill(LinearGradient.countdownCard)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.xl)
                        .fill(.ultraThinMaterial)
                )
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .stroke(Color.white.opacity(0.6), lineWidth: 1)
        )
        .shadow(color: Color(hex: "C4B5E0").opacity(0.10), radius: 12, x: 0, y: 4)
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
                Button(action: { showKegelExercise = true }) {
                    TaskGridCard(
                        icon: "figure.strengthtraining.traditional",
                        title: "凯格尔运动",
                        subtitle: todayTask?.kegelCompleted == true ? "✓ 已完成" : "待完成",
                        isCompleted: todayTask?.kegelCompleted ?? false
                    )
                }
                .buttonStyle(.plain)
                
                Button(action: { showLamazeExercise = true }) {
                    TaskGridCard(
                        icon: "wind",
                        title: "拉玛泽练习",
                        subtitle: todayTask?.lamazeCompleted == true ? "✓ 已完成" : "待完成",
                        isCompleted: todayTask?.lamazeCompleted ?? false
                    )
                }
                .buttonStyle(.plain)
                
                Button(action: { selectedTab = 2 }) {
                    TaskGridCard(
                        icon: "bag.fill",
                        title: "待产包",
                        subtitle: "\(bagCompleted)/\(bagTotal) 项",
                        isCompleted: false
                    )
                }
                .buttonStyle(.plain)
                
                Button(action: { selectedTab = 3 }) {
                    TaskGridCard(
                        icon: "book.fill",
                        title: "分娩知识",
                        subtitle: "\(ArticleContent.allArticles.count) 篇待读",
                        isCompleted: false
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Hospital Bag Progress
    private var hospitalBagProgress: some View {
        let progress = bagTotal > 0 ? Double(bagCompleted) / Double(bagTotal) : 0
        let percent = Int(progress * 100)
        
        return VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("待产包准备进度")
                    .font(AppFonts.cardTitle)
                    .foregroundStyle(Color.n900)
                Spacer()
                Text("\(bagCompleted) / \(bagTotal)")
                    .font(AppFonts.bodyText)
                    .foregroundStyle(Color.n500)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: AppRadius.full)
                        .fill(Color.n200)
                        .frame(height: 7)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: AppRadius.full)
                        .fill(LinearGradient.progressBar)
                        .frame(width: geometry.size.width * progress, height: 7)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: 7)
            
            Text("\(percent)%")
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
    
    private func ensureBagItemsExist() {
        if bagItems.isEmpty {
            let defaultItems: [(String, String, Int, String)] = [
                ("证件类", "身份证", 2, "夫妻双方"),
                ("证件类", "准生证", 1, ""),
                ("证件类", "医保卡", 1, ""),
                ("证件类", "病历本", 1, ""),
                ("证件类", "产检报告", 1, "B超单、化验单"),
                ("妈妈用品", "月子服", 2, ""),
                ("妈妈用品", "哺乳文胸", 2, ""),
                ("妈妈用品", "一次性内裤", 10, ""),
                ("妈妈用品", "产褥垫", 2, "包"),
                ("妈妈用品", "产妇卫生巾", 2, "包"),
                ("妈妈用品", "吸奶器", 1, ""),
                ("妈妈用品", "防溢乳垫", 1, "盒"),
                ("妈妈用品", "乳头霜", 1, ""),
                ("妈妈用品", "束腹带", 1, ""),
                ("妈妈用品", "月子帽", 1, ""),
                ("妈妈用品", "月子鞋", 1, ""),
                ("妈妈用品", "吸管杯", 1, ""),
                ("妈妈用品", "保温杯", 1, ""),
                ("妈妈用品", "巧克力/红牛", 1, "补充能量"),
                ("妈妈用品", "护肤品", 1, "基础保湿"),
                ("妈妈用品", "产后修复用品", 1, ""),
                ("妈妈用品", "卫生纸", 2, "提"),
                ("妈妈用品", "湿巾", 2, "包"),
                ("妈妈用品", "餐具", 1, "碗筷勺"),
                ("妈妈用品", "梳子、发圈", 1, ""),
                ("宝宝用品", "纸尿裤 NB 号", 1, "包"),
                ("宝宝用品", "湿巾", 2, "包"),
                ("宝宝用品", "奶瓶", 2, "玻璃/PPSU"),
                ("宝宝用品", "奶粉（备用）", 1, "罐"),
                ("宝宝用品", "奶瓶刷", 1, ""),
                ("宝宝用品", "奶瓶清洁剂", 1, ""),
                ("宝宝用品", "婴儿衣服 NB 码", 3, "套"),
                ("宝宝用品", "包被", 2, ""),
                ("宝宝用品", "抱被", 1, ""),
                ("宝宝用品", "婴儿帽子", 2, ""),
                ("宝宝用品", "小毛巾", 5, ""),
                ("宝宝用品", "浴巾", 2, ""),
                ("宝宝用品", "隔尿垫", 2, ""),
                ("宝宝用品", "婴儿护臀膏", 1, ""),
                ("宝宝用品", "婴儿沐浴露", 1, ""),
                ("宝宝用品", "婴儿洗衣液", 1, ""),
                ("宝宝用品", "婴儿指甲剪", 1, ""),
                ("宝宝用品", "体温计", 1, ""),
                ("住院用品", "毛巾", 3, ""),
                ("住院用品", "拖鞋", 2, "双"),
                ("住院用品", "脸盆", 2, ""),
                ("住院用品", "牙刷牙膏", 1, "套"),
                ("住院用品", "洗发水沐浴露", 1, ""),
                ("住院用品", "纸巾", 3, "盒"),
                ("住院用品", "垃圾袋", 1, "卷"),
                ("其他用品", "手机充电器", 2, ""),
                ("其他用品", "充电宝", 1, ""),
                ("其他用品", "相机", 1, "记录宝宝出生"),
                ("其他用品", "笔记本、笔", 1, ""),
                ("其他用品", "零钱", 1, ""),
                ("其他用品", "红包", 1, "给医护人员"),
                ("其他用品", "靠垫", 1, "分娩时用"),
                ("其他用品", "大袋子", 1, "装东西回家"),
            ]
            for (index, item) in defaultItems.enumerated() {
                let bagItem = HospitalBagItem(
                    category: item.0,
                    name: item.1,
                    quantity: item.2,
                    note: item.3,
                    sortOrder: index
                )
                modelContext.insert(bagItem)
            }
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
                .font(.system(size: 20))
                .foregroundStyle(isCompleted ? Color.success : Color.primaryDark)
                .frame(width: 40, height: 40)
                .background(
                    isCompleted
                        ? Color.success.opacity(0.15)
                        : LinearGradient(
                            colors: [Color.accentPeach.opacity(0.5), Color.primary600.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                          )
                )
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
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
    HomeView(selectedTab: .constant(0))
        .modelContainer(for: [UserProfile.self, DailyTask.self], inMemory: true)
}
