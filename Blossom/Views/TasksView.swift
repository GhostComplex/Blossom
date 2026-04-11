//
//  TasksView.swift
//  Blossom (拾月)
//
//  Tab 2 - 任务：凯格尔 + 拉玛泽 + 胎动记录
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query private var allTasks: [DailyTask]
    @Query(sort: \FetalMovementRecord.timestamp, order: .reverse)
    private var allMovements: [FetalMovementRecord]
    
    private var todayTasks: [DailyTask] {
        allTasks.filter { Calendar.current.isDateInToday($0.date) }
    }
    private var todayMovements: [FetalMovementRecord] {
        allMovements.filter { Calendar.current.isDateInToday($0.timestamp) }
    }
    
    @State private var showKegelExercise = false
    @State private var showLamazeExercise = false
    @State private var showFetalMovementCounter = false
    
    private var profile: UserProfile? { profiles.first }
    private var todayTask: DailyTask? { todayTasks.first }
    
    private var completedTaskCount: Int {
        var count = 0
        if todayTask?.kegelCompleted == true { count += 1 }
        if todayTask?.lamazeCompleted == true { count += 1 }
        if !todayMovements.isEmpty { count += 1 }
        return count
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xxl) {
                    // 顶部统计
                    headerSection
                    
                    // 任务列表
                    VStack(spacing: AppSpacing.md) {
                        kegelTaskCard
                        lamazeTaskCard
                        fetalMovementCard
                    }
                }
                .padding(.horizontal, AppSpacing.pageHorizontal)
                .padding(.vertical, AppSpacing.pageVertical)
            }
            .pageBackground()
            .navigationTitle("任务")
            .navigationBarTitleDisplayMode(.large)
            .fullScreenCover(isPresented: $showKegelExercise) {
                KegelExerciseView()
            }
            .fullScreenCover(isPresented: $showLamazeExercise) {
                LamazeExerciseView()
            }
            .sheet(isPresented: $showFetalMovementCounter) {
                FetalMovementCounterView()
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Text("今天完成 \(completedTaskCount) / 3 个任务")
                .font(AppFonts.caption)
                .foregroundStyle(Color.n500)
            Spacer()
        }
    }
    
    // MARK: - Kegel Task Card
    private var kegelTaskCard: some View {
        Button(action: { showKegelExercise = true }) {
            HStack(spacing: AppSpacing.lg) {
                // Icon
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 18))
                    .foregroundStyle(todayTask?.kegelCompleted == true ? Color.success : .white)
                    .frame(width: 44, height: 44)
                    .background(
                        todayTask?.kegelCompleted == true
                        ? AnyShapeStyle(Color.success.opacity(0.15))
                        : AnyShapeStyle(LinearGradient(
                            colors: [Color(hex: "F9B5C4"), Color(hex: "E8A0B8")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("凯格尔运动")
                            .font(AppFonts.cardTitle)
                            .foregroundStyle(Color.n900)
                        
                        if todayTask?.kegelCompleted == true {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.success)
                        }
                    }
                    
                    if let profile = profile {
                        Text("\(profile.currentKegelLevel.displayName) · \(profile.currentKegelLevel.contractDuration)秒收缩 - \(profile.currentKegelLevel.relaxDuration)秒放松 × 10")
                            .font(AppFonts.caption)
                            .foregroundStyle(Color.n500)
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
            HStack(spacing: AppSpacing.lg) {
                // Icon
                Image(systemName: "wind")
                    .font(.system(size: 18))
                    .foregroundStyle(todayTask?.lamazeCompleted == true ? Color.success : .white)
                    .frame(width: 44, height: 44)
                    .background(
                        todayTask?.lamazeCompleted == true
                        ? AnyShapeStyle(Color.success.opacity(0.15))
                        : AnyShapeStyle(LinearGradient(
                            colors: [Color(hex: "D4BCE8"), Color(hex: "B7A8D6")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("拉玛泽呼吸练习")
                            .font(AppFonts.cardTitle)
                            .foregroundStyle(Color.n900)
                        
                        if todayTask?.lamazeCompleted == true {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.success)
                        }
                    }
                    
                    Text("6 阶段呼吸法，跟练模式")
                        .font(AppFonts.caption)
                        .foregroundStyle(Color.n500)
                    
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
    
    // MARK: - Fetal Movement Card
    private var fetalMovementCard: some View {
        Button(action: { showFetalMovementCounter = true }) {
            HStack(spacing: AppSpacing.lg) {
                // Icon
                Image(systemName: "heart")
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "C9A0DC"), Color(hex: "B088CC")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("胎动记录（可选）")
                        .font(AppFonts.cardTitle)
                        .foregroundStyle(Color.n900)
                    
                    if todayMovements.isEmpty {
                        Text("今天还没有记录")
                            .font(AppFonts.caption)
                            .foregroundStyle(Color.n500)
                    } else {
                        Text("今天记录 \(todayMovements.count) 次")
                            .font(AppFonts.caption)
                            .foregroundStyle(Color.n500)
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
        .modelContainer(for: [UserProfile.self, DailyTask.self, FetalMovementRecord.self], inMemory: true)
}
