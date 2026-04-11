//
//  LamazeExerciseView.swift
//  Blossom (拾月)
//
//  拉玛泽呼吸练习
//  - 3 种模式：学习模式 / 跟练模式 / 知识卡片
//  - 6 个阶段：清洁呼吸 → 胸式呼吸 → 节律呼吸 → 喘息呼吸 → 吹气呼吸 → 用力呼吸
//

import SwiftUI
import SwiftData

struct LamazeExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var allTasks: [DailyTask]
    
    private var todayTasks: [DailyTask] {
        allTasks.filter { Calendar.current.isDateInToday($0.date) }
    }
    
    @State private var selectedMode: LamazeMode?
    @State private var selectedStage: LamazeStage?
    @State private var showCompletionView = false
    
    private var todayTask: DailyTask? { todayTasks.first }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.pageBackground
                    .ignoresSafeArea()
                
                if let stage = selectedStage {
                    LamazePracticeView(stage: stage, onComplete: {
                        markTaskCompleted()
                        selectedStage = nil
                        selectedMode = nil
                        showCompletionView = true
                    }, onBack: {
                        selectedStage = nil
                    })
                } else if selectedMode == .practice {
                    stageSelectionView
                } else if selectedMode == .learn {
                    learningModeView
                } else {
                    modeSelectionView
                }
            }
            .navigationTitle("拉玛泽呼吸练习")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: handleBack) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.n700)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showCompletionView) {
            ExerciseCompletionView(exerciseName: "拉玛泽练习") {
                showCompletionView = false
                dismiss()
            }
        }
    }

    // MARK: - Mode Selection
    private var modeSelectionView: some View {
        VStack(spacing: AppSpacing.lg) {
            // Practice mode
            ModeCard(
                icon: "wind",
                title: "跟练模式",
                description: "跟随动画一起练习呼吸",
                color: Color.primary600
            ) {
                withAnimation { selectedMode = .practice }
            }
            
            // Learning mode
            ModeCard(
                icon: "book.fill",
                title: "学习模式",
                description: "查看 6 阶段呼吸法图文教程",
                color: Color.warmGold
            ) {
                withAnimation { selectedMode = .learn }
            }
            
            // Knowledge mode
            ModeCard(
                icon: "lightbulb.fill",
                title: "知识卡片",
                description: "了解拉玛泽分娩法原理",
                color: Color.success
            ) {
                // TODO: Navigate to knowledge tab
                dismiss()
            }
            
            Spacer(minLength: AppSpacing.lg)
        }
        .padding(.horizontal, AppSpacing.pageHorizontal)
        .padding(.top, AppSpacing.xl)
    }
    
    // MARK: - Stage Selection
    private var stageSelectionView: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                Text("选择练习阶段")
                    .font(AppFonts.sectionTitle)
                    .foregroundStyle(Color.n900)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, AppSpacing.lg)
                
                ForEach(LamazeStage.allCases, id: \.rawValue) { stage in
                    StageCard(stage: stage) {
                        withAnimation { selectedStage = stage }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.pageHorizontal)
            .padding(.bottom, AppSpacing.xxxl)
        }
    }
    
    // MARK: - Learning Mode
    private var learningModeView: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                Text("6 阶段呼吸法")
                    .font(AppFonts.sectionTitle)
                    .foregroundStyle(Color.n900)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, AppSpacing.lg)
                
                ForEach(LamazeStage.allCases, id: \.rawValue) { stage in
                    LearningCard(stage: stage)
                }
                
                // Disclaimer
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    Text("⚠️ 免责声明：本内容仅供参考，不构成医学建议。如有疑问，请咨询专业医生。")
                        .font(AppFonts.smallLabel)
                        .foregroundStyle(Color.n500)
                }
                .padding(.top, AppSpacing.lg)
            }
            .padding(.horizontal, AppSpacing.pageHorizontal)
            .padding(.bottom, AppSpacing.xxxl)
        }
    }
    
    // MARK: - Actions
    private func handleBack() {
        if selectedStage != nil {
            selectedStage = nil
        } else if selectedMode != nil {
            selectedMode = nil
        } else {
            dismiss()
        }
    }
    
    private func markTaskCompleted() {
        if let task = todayTask {
            task.lamazeCompleted = true
            task.lamazeCompletedAt = Date()
            
            // Notify NotificationManager
            NotificationManager.shared.onExerciseCompleted(
                kegelDone: task.kegelCompleted,
                lamazeDone: true
            )
        }
    }
}

// MARK: - Lamaze Mode
enum LamazeMode {
    case practice, learn, knowledge
}

// MARK: - Mode Card
struct ModeCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.lg) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        LinearGradient(
                            colors: [color.opacity(0.5), color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppFonts.cardTitle)
                        .foregroundStyle(Color.n900)
                    
                    Text(description)
                        .font(AppFonts.caption)
                        .foregroundStyle(Color.n500)
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

// MARK: - Stage Card
struct StageCard: View {
    let stage: LamazeStage
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.lg) {
                Text("\(stage.rawValue)")
                    .font(.custom("CormorantGaramond-Bold", size: 20))
                    .foregroundStyle(Color.primary600)
                    .frame(width: 44, height: 44)
                    .background(Color.accentLight)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(stage.displayName)
                        .font(AppFonts.cardTitle)
                        .foregroundStyle(Color.n900)
                    
                    Text(stage.description)
                        .font(AppFonts.caption)
                        .foregroundStyle(Color.n500)
                }
                
                Spacer()
                
                Text("开始")
                    .font(AppFonts.smallLabel)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.primary600)
                    .clipShape(Capsule())
            }
            .padding(AppSpacing.cardPadding)
            .glassCard()
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Learning Card
struct LearningCard: View {
    let stage: LamazeStage
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Text("\(stage.rawValue). \(stage.displayName)")
                        .font(AppFonts.cardTitle)
                        .foregroundStyle(Color.n900)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(Color.n500)
                }
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Text("适用时机")
                        .font(AppFonts.smallLabel)
                        .foregroundStyle(Color.primary600)
                    
                    Text(stage.description)
                        .font(AppFonts.bodyText)
                        .foregroundStyle(Color.n700)
                    
                    Divider()
                    
                    Text("呼吸节奏")
                        .font(AppFonts.smallLabel)
                        .foregroundStyle(Color.primary600)
                    
                    Text("吸气 \(Int(stage.breathingRhythm.inhale)) 秒 → 呼气 \(Int(stage.breathingRhythm.exhale)) 秒")
                        .font(AppFonts.bodyText)
                        .foregroundStyle(Color.n700)
                    
                    Text("重复 \(stage.cycleCount) 次")
                        .font(AppFonts.caption)
                        .foregroundStyle(Color.n500)
                }
                .padding(.top, 4)
            }
        }
        .padding(AppSpacing.cardPadding)
        .glassCard()
    }
}

// MARK: - Practice View
struct LamazePracticeView: View {
    let stage: LamazeStage
    let onComplete: () -> Void
    let onBack: () -> Void
    
    @StateObject private var timer = LamazeBreathingTimer()
    @State private var showCompletionAlert = false
    
    var body: some View {
        VStack(spacing: AppSpacing.xxxl) {
            Spacer()
            
            // Stage title
            Text("第 \(stage.rawValue) 阶段：\(stage.displayName)")
                .font(AppFonts.sectionTitle)
                .foregroundStyle(Color.n900)
            
            // Breathing animation
            breathingCircle
            
            // Breathing instruction
            Text(timer.phase == .inhale ? "🫁 深吸气..." : "💨 慢慢呼气...")
                .font(AppFonts.cardTitle)
                .foregroundStyle(timer.phase == .inhale ? Color.primary600 : Color.n500)
            
            Text("跟随圆圈\(timer.phase == .inhale ? "扩大吸气" : "缩小呼气")")
                .font(AppFonts.caption)
                .foregroundStyle(Color.n500)
            
            // Progress
            Text("还剩 \(stage.cycleCount - timer.completedCycles) 次呼吸")
                .font(AppFonts.bodyText)
                .foregroundStyle(Color.n500)
            
            Spacer()
            
            // Control buttons
            HStack(spacing: 20) {
                Button(action: {
                    timer.stop()
                    onBack()
                }) {
                    HStack {
                        Image(systemName: "xmark")
                        Text("结束")
                    }
                    .font(AppFonts.cardTitle)
                    .foregroundStyle(Color.n500)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.n100)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.full))
                }
                
                if timer.completedCycles < stage.cycleCount {
                    Button(action: nextStage) {
                        HStack {
                            Text("下一阶段")
                            Image(systemName: "chevron.right")
                        }
                        .font(AppFonts.cardTitle)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.primary600)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.full))
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, AppSpacing.pageHorizontal)
        .onAppear {
            timer.configure(stage: stage)
        }
        .onChange(of: timer.isCompleted) { _, completed in
            if completed {
                showCompletionAlert = true
            }
        }
        .alert("✓ 完成！", isPresented: $showCompletionAlert) {
            Button("继续下一阶段") { nextStage() }
            Button("结束练习") { onComplete() }
        } message: {
            Text("已完成 \(stage.displayName) 练习")
        }
    }
    
    // MARK: - Breathing Circle
    private var breathingCircle: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.primary600.opacity(0.3), Color.clear],
                        center: .center,
                        startRadius: 60,
                        endRadius: 140
                    )
                )
                .frame(width: 280, height: 280)
            
            // Main circle with breathing animation
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.accentLight, Color.accentPeach],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 160, height: 160)
                .scaleEffect(timer.scale)
                .opacity(timer.opacity)
                .animation(
                    .easeInOut(duration: timer.phase == .inhale ? stage.breathingRhythm.inhale : stage.breathingRhythm.exhale),
                    value: timer.scale
                )
            
            // Inner circle
            Circle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 80, height: 80)
                .scaleEffect(timer.scale)
                .animation(
                    .easeInOut(duration: timer.phase == .inhale ? stage.breathingRhythm.inhale : stage.breathingRhythm.exhale),
                    value: timer.scale
                )
        }
    }
    
    private func nextStage() {
        timer.stop()
        // Navigate to next stage or complete
        if let currentIndex = LamazeStage.allCases.firstIndex(of: stage),
           currentIndex < LamazeStage.allCases.count - 1 {
            // Would navigate to next stage - for now just complete
            onComplete()
        } else {
            onComplete()
        }
    }
}

// MARK: - Lamaze Breathing Timer
@MainActor
class LamazeBreathingTimer: ObservableObject {
    enum Phase {
        case inhale, exhale
    }
    
    @Published var phase: Phase = .inhale
    @Published var scale: CGFloat = 0.8
    @Published var opacity: Double = 0.6
    @Published var completedCycles: Int = 0
    @Published var isCompleted: Bool = false
    
    private var stage: LamazeStage = .chestBreathing
    private var timer: Timer?
    
    func configure(stage: LamazeStage) {
        self.stage = stage
        self.completedCycles = 0
        self.isCompleted = false
        startBreathing()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startBreathing() {
        breatheIn()
    }
    
    private func breatheIn() {
        phase = .inhale
        scale = 1.2
        opacity = 1.0
        
        // Light haptic
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: stage.breathingRhythm.inhale, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.breatheOut()
            }
        }
    }
    
    private func breatheOut() {
        phase = .exhale
        scale = 0.8
        opacity = 0.6
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: stage.breathingRhythm.exhale, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.completeCycle()
            }
        }
    }
    
    private func completeCycle() {
        completedCycles += 1
        
        if completedCycles >= stage.cycleCount {
            isCompleted = true
            // Success haptic
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } else {
            breatheIn()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

#Preview {
    LamazeExerciseView()
        .modelContainer(for: [UserProfile.self, DailyTask.self], inMemory: true)
}
