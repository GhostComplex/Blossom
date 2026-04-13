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
            VStack(spacing: 0) {
                // 顶部问候
                greetingHeader
                    .padding(.bottom, 22)   // #5: greeting margin-bottom 22

                // 倒计时主卡片
                countdownCard
                    .padding(.bottom, 20)   // #7: countdown margin-bottom 20

                // 今日任务 (2x2 Grid)
                taskGrid
                    .padding(.bottom, 14)   // #25: grid margin-bottom 14

                // 待产包进度
                hospitalBagProgress
            }
            .padding(.horizontal, AppSpacing.pageHorizontal)
            .padding(.vertical, AppSpacing.pageVertical)
        }
        .pageBackground()
        .overlay(
            // Decorative radial gradient orbs (design spec)
            ZStack {
                // Top-right pink orb
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: "F9B5C4").opacity(0.25), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 130
                        )
                    )
                    .frame(width: 260, height: 260)
                    .offset(x: 100, y: -80)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                
                // Bottom-left purple orb
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: "C4B5E0").opacity(0.2), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 110
                        )
                    )
                    .frame(width: 220, height: 220)
                    .offset(x: -80, y: 100)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
            .allowsHitTesting(false)
        )
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
                .font(.custom("Nunito-Regular", size: 12))   // #1: Nunito-Regular 12
                .foregroundStyle(Color.n300)                   // #2: n300
                .tracking(0.3)                                 // #3: letter-spacing 0.3

            Text(greetingText)
                .font(.custom("NotoSerifSC-Regular", size: 26))
                .foregroundStyle(Color.n900)
                .tracking(-0.3)                                // #4: letter-spacing -0.3
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
        VStack(spacing: 0) {
            // 孕周徽章
            if let profile = profile {
                let week = profile.currentPregnancyWeek
                Text("孕 \(week.week) 周 + \(week.day) 天")
                    .font(.custom("Nunito-Medium", size: 11))  // #8: Nunito-Medium 11
                    .foregroundStyle(Color.n500)                // #9: n500
                    .padding(.horizontal, 14)                   // #10: 14h
                    .padding(.vertical, 4)                      // #10: 4v
                    .background(Color.white.opacity(0.35))
                    .overlay(Capsule().stroke(Color.white.opacity(0.4), lineWidth: 1))
                    .clipShape(Capsule())
                    .padding(.bottom, 14)                       // #11: badge margin-bottom 14
            }

            // 倒计时描述
            Text("距离与宝宝见面")
                .font(.custom("Nunito-Regular", size: 13))     // #12: Nunito-Regular 13
                .foregroundStyle(Color.n500)
                .tracking(0.5)                                  // #13: letter-spacing 0.5

            // 倒计时数字
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(profile?.daysUntilDue ?? 0)")
                    .font(.custom("NotoSerifSC-Light", size: 72)) // #14: NotoSerifSC-Light
                    .foregroundStyle(Color.n900)
                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2) // #15: text-shadow
                    .tracking(-2)                                  // #17: letter-spacing -2

                Text("天")
                    .font(AppFonts.countdownUnit)
                    .foregroundStyle(Color.n500)                   // #18: n500
                    .tracking(2)                                   // #19: letter-spacing 2
            }
            .padding(.top, 6)                                      // #16: 6px above number
            .padding(.bottom, 2)                                   // #16: 2px below number

            // #23: Divider REMOVED

            // 预产期信息
            if let profile = profile {
                HStack {
                    Text("预产期 \(profile.dueDate, format: .dateTime.year().month().day())")
                        .font(.custom("Nunito-Regular", size: 11)) // #20: Nunito-Regular 11
                        .foregroundStyle(Color.n300)                // #21: n300
                }
                .padding(.top, 10)                                  // #22: margin-top 10
            }
        }
        .padding(.top, 28)                                          // #6: top 28
        .padding(.horizontal, 24)                                   // #6: horizontal 24
        .padding(.bottom, 24)                                       // #6: bottom 24
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                // Blur layer
                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .fill(.ultraThinMaterial)
                    .opacity(0.6)
                // Gradient overlay
                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .fill(LinearGradient.countdownCard)
            }
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
        )
        .overlay(
            // Decorative glow orbs (design .cd-card::before / ::after)
            ZStack {
                // Right-top glow: 100×100, white 0.2, offset top:-30 right:-20
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .offset(x: 20, y: -30)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                // Left-bottom glow: 60×60, white 0.15, offset bottom:-20 left:30
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 60, height: 60)
                    .offset(x: 30, y: 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
            .allowsHitTesting(false)
        )
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
        .shadow(color: Color(hex: "C4A0DC").opacity(0.12), radius: 20, x: 0, y: 8)
    }
    
    // MARK: - Task Grid (2x2)
    private var taskGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 11),     // #24: gap 11
            GridItem(.flexible(), spacing: 11)      // #24: gap 11
        ], spacing: 11) {                           // #24: gap 11
                Button(action: { showKegelExercise = true }) {
                    TaskGridCard(
                        icon: "figure.strengthtraining.traditional",
                        title: "凯格尔运动",
                        subtitle: todayTask?.kegelCompleted == true ? "✓ 已完成" : "待完成",
                        isCompleted: todayTask?.kegelCompleted ?? false,
                        iconGradient: [Color(hex: "F9B5C4"), Color(hex: "E8A0B8")]
                    )
                }
                .buttonStyle(.plain)
                
                Button(action: { showLamazeExercise = true }) {
                    TaskGridCard(
                        icon: "wind",
                        title: "拉玛泽呼吸",
                        subtitle: todayTask?.lamazeCompleted == true ? "✓ 已完成" : "待完成",
                        isCompleted: todayTask?.lamazeCompleted ?? false,
                        iconGradient: [Color(hex: "C4B5E0"), Color(hex: "B6A0D2")]
                    )
                }
                .buttonStyle(.plain)
                
                Button(action: { selectedTab = 2 }) {
                    TaskGridCard(
                        icon: "bag",
                        title: "待产包",
                        subtitle: "\(bagCompleted)/\(bagTotal) 项",
                        isCompleted: false,
                        iconGradient: [Color(hex: "B8DCF5"), Color(hex: "ABC2E6")]
                    )
                }
                .buttonStyle(.plain)
                
                Button(action: { selectedTab = 3 }) {
                    TaskGridCard(
                        icon: "book",
                        title: "分娩知识",
                        subtitle: "\(ArticleContent.allArticles.count) 篇待读",
                        isCompleted: false,
                        iconGradient: [Color(hex: "C9A0DC"), Color(hex: "BB8DCE")]
                    )
                }
                .buttonStyle(.plain)
            }
        }
    // MARK: - Hospital Bag Progress
    private var hospitalBagProgress: some View {
        let progress = bagTotal > 0 ? Double(bagCompleted) / Double(bagTotal) : 0

        return VStack(alignment: .leading, spacing: 7) {           // #40: header spacing 7
            HStack {
                Text("待产包准备进度")
                    .font(.custom("Nunito-SemiBold", size: 12))
                    .foregroundStyle(Color.n900)
                Spacer()
                Text("\(bagCompleted) / \(bagTotal)")
                    .font(.custom("Nunito-Medium", size: 12))
                    .foregroundStyle(Color.primary600)              // #39: primary600
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 3)              // #41: radius 3
                        .fill(Color(hex: "C4B5E0").opacity(0.12))
                        .frame(height: 7)

                    // Progress
                    RoundedRectangle(cornerRadius: 3)              // #41: radius 3
                        .fill(LinearGradient.progressBar)
                        .frame(width: geometry.size.width * progress, height: 7)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: 7)
            // #42: percent text REMOVED
        }
        .padding(.vertical, 14)                                    // #35: vertical 14
        .padding(.horizontal, 16)                                   // #35: horizontal 16
        // Custom glass card: #36 radius 18, #37 border 0.65, #38 shadow radius 12 opacity 0.06
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .opacity(0.7)
        )
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.3))
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.65), lineWidth: 1)   // #37: border 0.65
        )
        .shadow(color: Color(hex: "C4B5E0").opacity(0.06), radius: 12, x: 0, y: 2) // #38: shadow
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
    var iconGradient: [Color] = [Color(hex: "F9B5C4"), Color(hex: "E8A0B8")]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(isCompleted ? Color.success : .white)
                .frame(width: 40, height: 40)
                .background(
                    Group {
                        if isCompleted {
                            Color.success.opacity(0.15)
                        } else {
                            LinearGradient(
                                colors: [
                                    iconGradient[0].opacity(0.5),  // #31: start opacity 0.5
                                    iconGradient[1].opacity(0.8)   // #31: end opacity 0.8
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 13))     // #29: radius 13
                .padding(.bottom, 9)                                // #30: icon margin-bottom 9

            Text(title)
                .font(AppFonts.cardTitle)
                .foregroundStyle(Color.n900)
                .tracking(-0.1)                                     // #32: letter-spacing -0.1
                .padding(.bottom, 2)                                // #33: title margin-bottom 2

            Text(subtitle)
                .font(.custom("Nunito-Regular", size: 10.5))
                .foregroundStyle(isCompleted ? Color.success : Color.n300) // #34: n300
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)                                                // #26: padding 15
        .glassCard()                                                // #27/#28: glassCard matches design
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
        .modelContainer(for: [UserProfile.self, DailyTask.self], inMemory: true)
}
