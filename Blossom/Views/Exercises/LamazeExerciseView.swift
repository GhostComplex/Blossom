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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("拉玛泽呼吸练习")
                        .font(.custom("NotoSerifSC-Regular", size: 20))
                        .foregroundStyle(Color(hex: "3A2F50"))
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: handleBack) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.n500)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showCompletionView) {
            ExerciseCompletionView(exerciseName: "拉玛泽呼吸") {
                showCompletionView = false
                dismiss()
            }
        }
    }

    // MARK: - Mode Selection
    private var modeSelectionView: some View {
        VStack(spacing: 11) {
            // Practice mode
            ModeCard(
                icon: "wind",
                title: "跟练模式",
                description: "跟随动画一起练习呼吸",
                iconGradient: [Color(hex: "F9B5C4").opacity(0.5), Color(hex: "F9B5C4").opacity(0.8)]
            ) {
                withAnimation { selectedMode = .practice }
            }
            
            // Learning mode
            ModeCard(
                icon: "book.fill",
                title: "学习模式",
                description: "查看 6 阶段呼吸法教程",
                iconGradient: [Color(hex: "C4B5E0").opacity(0.5), Color(hex: "C4B5E0").opacity(0.8)]
            ) {
                withAnimation { selectedMode = .learn }
            }
            
            // Knowledge mode
            ModeCard(
                icon: "info.circle",
                title: "知识卡片",
                description: "了解拉玛泽分娩法原理",
                iconGradient: [Color(hex: "B8DCF5").opacity(0.5), Color(hex: "B8DCF5").opacity(0.8)]
            ) {
                // TODO: Navigate to knowledge tab
                dismiss()
            }
        }
        .padding(.horizontal, AppSpacing.pageHorizontal)
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, AppSpacing.sm)
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
                    Text("本内容仅供参考，不构成医学建议，请遵医嘱。")
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
    let iconGradient: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(
                            colors: iconGradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.custom("Nunito-Medium", size: 14))
                        .tracking(-0.1)
                        .foregroundStyle(Color.n900)

                    Text(description)
                        .font(.system(size: 10.5))
                        .foregroundStyle(Color.n300)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.n300)
            }
            .padding(20)
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
                    .font(.custom("NotoSerifSC-Bold", size: 20))
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
    @State private var hasStarted = false
    @State private var showExitConfirmation = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            if hasStarted {
                timerView
            } else {
                preparationView
            }

            Spacer()

            // Disclaimer
            Text("本内容仅供参考，不构成医学建议，请遵医嘱。")
                .font(.system(size: 10))
                .foregroundStyle(Color(hex: "AEA3C4").opacity(0.6))
                .padding(.bottom, 16)
        }
        .padding(.horizontal, AppSpacing.pageHorizontal)
        .onChange(of: timer.isCompleted) { _, completed in
            if completed {
                timer.stop()
                onComplete()
            }
        }
        .overlay {
            ExitConfirmationOverlay(
                isPresented: $showExitConfirmation,
                onContinue: { timer.configure(stage: stage) },
                onExit: { onBack() }
            )
        }
    }

    // MARK: - Preparation View
    private var preparationView: some View {
        VStack(spacing: 0) {
            // Level badge (#10: weight medium→regular, #11: color n500→n300)
            Text("拉玛泽呼吸练习 · 6 阶段")
                .font(.system(size: 11, weight: .regular))
                .tracking(2)
                .textCase(.uppercase)
                .foregroundStyle(Color(hex: "AEA3C4"))
                .padding(.bottom, 20)

            // Title
            Text("准备好了吗？")
                .font(.custom("NotoSerifSC-Regular", size: 22))
                .foregroundStyle(Color(hex: "3A2F50"))
                .padding(.bottom, 16)

            // Description
            Text("跟随动画练习呼吸节奏\n从清洁呼吸开始，逐步进阶")
                .font(.system(size: 12))
                .foregroundStyle(Color(hex: "AEA3C4"))
                .lineSpacing(12 * 0.6)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 240)
                .padding(.bottom, 32)

            // Ring
            ZStack {
                // Ring glow
                RadialGradient(
                    colors: [Color(hex: "C9A0DC").opacity(0.15), Color.clear],
                    center: .center,
                    startRadius: 40,
                    endRadius: 120
                )
                .frame(width: 240, height: 240)

                // Track ring (#3: 8→2)
                Circle()
                    .stroke(Color(hex: "B7A8D6").opacity(0.2), lineWidth: 2)
                    .frame(width: 200, height: 200)

                // Center text
                Text("6 阶段")
                    .font(.custom("NotoSerifSC-Regular", size: 18))
                    .foregroundStyle(Color(hex: "7A6E94"))
            }
            .padding(.bottom, 32)

            // Start button
            Button(action: {
                hasStarted = true
                timer.configure(stage: stage)
            }) {
                Text("开始练习")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 200)
                    .padding(.vertical, 14)
                    .background(Color(hex: "C9A0DC"))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Color(hex: "C4A0DC").opacity(0.2), radius: 16, x: 0, y: 4)
            }
        }
    }

    // MARK: - Timer View
    private var timerView: some View {
        VStack(spacing: 0) {
            // Stage label (#1: weight medium→regular, #2: color n500→n300, #3: bottom 12→10)
            Text("第 \(stage.rawValue) 阶段：\(stage.displayName)")
                .font(.system(size: 11, weight: .regular))
                .tracking(2)
                .textCase(.uppercase)
                .foregroundStyle(Color(hex: "AEA3C4"))
                .padding(.bottom, 10)

            // Phase instruction (#5: 22→26, #9: +tracking(0.3))
            Text(timer.phase == .inhale ? "深吸气..." : "慢慢呼气...")
                .font(.custom("NotoSerifSC-Regular", size: 26))
                .tracking(0.3)
                .foregroundStyle(Color(hex: "3A2F50"))
                .padding(.bottom, 28)

            // Hint text
            Text(timer.phase == .inhale ? "跟随圆圈扩大吸气" : "跟随圆圈缩小呼气")
                .font(.system(size: 12))
                .foregroundStyle(Color(hex: "AEA3C4"))
                .padding(.bottom, 24)

            // Ring timer
            ZStack {
                // Ring glow
                RadialGradient(
                    colors: [Color(hex: "C9A0DC").opacity(0.15), Color.clear],
                    center: .center,
                    startRadius: 40,
                    endRadius: 120
                )
                .frame(width: 240, height: 240)

                // Track ring (#1: 8→2)
                Circle()
                    .stroke(Color(hex: "B7A8D6").opacity(0.2), lineWidth: 2)
                    .frame(width: 200, height: 200)

                // Progress ring (#2: 8→2.5)
                Circle()
                    .trim(from: 0, to: timer.progress)
                    .stroke(Color(hex: "C9A0DC"), style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.3), value: timer.progress)

                // Center content
                VStack(spacing: 2) {
                    Text("\(timer.secondsRemaining)")
                        .font(.custom("NotoSerifSC-Regular", size: 48))
                        .foregroundStyle(Color(hex: "3A2F50"))
                        .contentTransition(.numericText())
                        .animation(.linear(duration: 0.1), value: timer.secondsRemaining)

                    Text("秒")
                        .font(.system(size: 11))
                        .foregroundStyle(Color(hex: "AEA3C4"))
                }
            }
            .padding(.bottom, 16)

            // Remaining count (#15: 13→12, #16: +tracking(0.5), #10: bottom 24→36)
            Text("还剩 \(stage.cycleCount - timer.completedCycles) 次呼吸")
                .font(.system(size: 12))
                .tracking(0.5)
                .foregroundStyle(Color(hex: "AEA3C4"))
                .padding(.bottom, 36)

            // Control buttons
            HStack(spacing: 14) {
                // End button
                Button(action: handleEndTap) {
                    HStack(spacing: 4) {
                        Text("✕")
                        Text("结束")
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .tracking(0.3)
                    .foregroundStyle(Color(hex: "7A6E94"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .padding(.horizontal, 32)
                    .background(Color.white.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.6), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                // Next stage button
                Button(action: nextStage) {
                    HStack(spacing: 4) {
                        Text("▶")
                        Text("下一阶段")
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .tracking(0.3)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .padding(.horizontal, 32)
                    .background(Color(hex: "C9A0DC"))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(.bottom, 20)
        }
    }

    // MARK: - Actions
    private func handleEndTap() {
        timer.stop()
        if timer.completedCycles > 0 {
            showExitConfirmation = true
        } else {
            hasStarted = false
        }
    }

    private func nextStage() {
        timer.stop()
        if let currentIndex = LamazeStage.allCases.firstIndex(of: stage),
           currentIndex < LamazeStage.allCases.count - 1 {
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
    @Published var completedCycles: Int = 0
    @Published var isCompleted: Bool = false
    @Published var secondsRemaining: Int = 0
    @Published var progress: Double = 1.0

    private var stage: LamazeStage = .chestBreathing
    private var countdownTimer: Timer?
    private var phaseTotalSeconds: Int = 0

    func configure(stage: LamazeStage) {
        self.stage = stage
        self.completedCycles = 0
        self.isCompleted = false
        startBreathing()
    }

    func stop() {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }

    private func startBreathing() {
        breatheIn()
    }

    private func breatheIn() {
        phase = .inhale
        phaseTotalSeconds = Int(stage.breathingRhythm.inhale)
        secondsRemaining = phaseTotalSeconds
        progress = 0.0

        // Light haptic
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        startCountdown()
    }

    private func breatheOut() {
        phase = .exhale
        phaseTotalSeconds = Int(stage.breathingRhythm.exhale)
        secondsRemaining = phaseTotalSeconds
        progress = 1.0

        startCountdown()
    }

    private func startCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    private func tick() {
        secondsRemaining -= 1

        if phase == .inhale {
            // Inhale: progress fills up from 0 to 1
            progress = Double(phaseTotalSeconds - secondsRemaining) / Double(phaseTotalSeconds)
        } else {
            // Exhale: progress empties from 1 to 0
            progress = Double(secondsRemaining) / Double(phaseTotalSeconds)
        }

        if secondsRemaining <= 0 {
            countdownTimer?.invalidate()
            countdownTimer = nil

            if phase == .inhale {
                breatheOut()
            } else {
                completeCycle()
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
        countdownTimer?.invalidate()
    }
}

#Preview {
    LamazeExerciseView()
        .modelContainer(for: [UserProfile.self, DailyTask.self], inMemory: true)
}
