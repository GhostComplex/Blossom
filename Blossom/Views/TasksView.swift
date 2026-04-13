//
//  TasksView.swift
//  Blossom (拾月)
//
//  Tab 2 - 任务：凯格尔 + 拉玛泽
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query private var allTasks: [DailyTask]
    
    private var todayTasks: [DailyTask] {
        allTasks.filter { Calendar.current.isDateInToday($0.date) }
    }
    
    @State private var showKegelExercise = false
    @State private var showLamazeExercise = false
    
    private var profile: UserProfile? { profiles.first }
    private var todayTask: DailyTask? { todayTasks.first }
    
    private var completedTaskCount: Int {
        var count = 0
        if todayTask?.kegelCompleted == true { count += 1 }
        if todayTask?.lamazeCompleted == true { count += 1 }
        return count
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // 自定义标题
                    HStack {
                        Text("任务")
                            .font(.custom("NotoSerifSC-Regular", size: 24))
                            .foregroundStyle(Color(hex: "3A2F50"))
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 6)

                    // 顶部统计
                    headerSection

                    // 任务列表
                    VStack(spacing: 11) {
                        kegelTaskCard
                        lamazeTaskCard
                    }
                }
                .padding(.horizontal, AppSpacing.pageHorizontal)
                .padding(.vertical, AppSpacing.pageVertical)
            }
            .pageBackground()
            .toolbar(.hidden, for: .navigationBar)
            .fullScreenCover(isPresented: $showKegelExercise) {
                KegelExerciseView()
            }
            .fullScreenCover(isPresented: $showLamazeExercise) {
                LamazeExerciseView()
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Text("今天完成 \(completedTaskCount) / 2 个任务")
                .font(AppFonts.caption)
                .foregroundStyle(Color.n300)
            Spacer()
        }
        .padding(.bottom, 16)
    }
    
    // MARK: - Kegel Task Card
    private var kegelTaskCard: some View {
        Button(action: { showKegelExercise = true }) {
            HStack(spacing: 14) {
                // Icon
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 18))
                    .foregroundStyle(todayTask?.kegelCompleted == true ? Color.success : .white)
                    .frame(width: 40, height: 40)
                    .background(
                        todayTask?.kegelCompleted == true
                        ? AnyShapeStyle(Color.success.opacity(0.15))
                        : AnyShapeStyle(LinearGradient(
                            colors: [Color(hex: "F9B5C4").opacity(0.5), Color(hex: "F9B5C4").opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 13))

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("凯格尔运动")
                            .font(AppFonts.cardTitle)
                            .tracking(-0.1)
                            .foregroundStyle(Color.n900)
                        
                        if todayTask?.kegelCompleted == true {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.success)
                        }
                    }
                    
                    if let profile = profile {
                        Text("\(profile.currentKegelLevel.displayName) · \(profile.currentKegelLevel.contractDuration)秒收缩 - \(profile.currentKegelLevel.relaxDuration)秒放松 × 10")
                            .font(AppFonts.caption)
                            .foregroundStyle(Color.n300)
                    }
                    
                    if let completedAt = todayTask?.kegelCompletedAt {
                        Text("今天 \(completedAt, format: .dateTime.hour().minute()) 完成")
                            .font(AppFonts.smallLabel)
                            .foregroundStyle(Color.success)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.n300)
            }
            .padding(AppSpacing.cardPadding)
            .glassCard()
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Lamaze Task Card
    private var lamazeTaskCard: some View {
        Button(action: { showLamazeExercise = true }) {
            HStack(spacing: 14) {
                // Icon
                Image(systemName: "wind")
                    .font(.system(size: 18))
                    .foregroundStyle(todayTask?.lamazeCompleted == true ? Color.success : .white)
                    .frame(width: 40, height: 40)
                    .background(
                        todayTask?.lamazeCompleted == true
                        ? AnyShapeStyle(Color.success.opacity(0.15))
                        : AnyShapeStyle(LinearGradient(
                            colors: [Color(hex: "C4B5E0").opacity(0.5), Color(hex: "C4B5E0").opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 13))

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("拉玛泽呼吸练习")
                            .font(AppFonts.cardTitle)
                            .tracking(-0.1)
                            .foregroundStyle(Color.n900)
                        
                        if todayTask?.lamazeCompleted == true {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.success)
                        }
                    }
                    
                    Text("6 阶段呼吸法，跟练模式")
                        .font(AppFonts.caption)
                        .foregroundStyle(Color.n300)
                    
                    if let completedAt = todayTask?.lamazeCompletedAt {
                        Text("今天 \(completedAt, format: .dateTime.hour().minute()) 完成")
                            .font(AppFonts.smallLabel)
                            .foregroundStyle(Color.success)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.n300)
            }
            .padding(AppSpacing.cardPadding)
            .glassCard()
        }
        .buttonStyle(.plain)
    }
    
}

#Preview {
    TasksView()
        .modelContainer(for: [UserProfile.self, DailyTask.self], inMemory: true)
}
