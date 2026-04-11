//
//  KegelExerciseView.swift
//  Blossom (拾月)
//
//  凯格尔运动计时器
//  - 3 级训练（初级/中级/高级）
//  - 收缩:放松 = 1:2 比例
//  - 10 组为一个完整练习
//

import SwiftUI
import SwiftData

struct KegelExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query private var allTasks: [DailyTask]
    
    private var todayTasks: [DailyTask] {
        allTasks.filter { Calendar.current.isDateInToday($0.date) }
    }
    
    @StateObject private var timer = KegelTimer()
    @State private var showCompletionAlert = false
    @State private var showExitConfirmation = false
    
    private var profile: UserProfile? { profiles.first }
    private var todayTask: DailyTask? { todayTasks.first }
    private var level: KegelLevel { profile?.currentKegelLevel ?? .beginner }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient.pageBackground
                    .ignoresSafeArea()
                
                VStack(spacing: AppSpacing.xxxl) {
                    Spacer()
                    
                    // Level indicator
                    levelBadge
                    
                    // Main timer circle
                    timerCircle
                    
                    // Progress dots
                    progressDots
                    
                    // Progress text
                    progressText
                    
                    Spacer()
                    
                    // Control buttons
                    controlButtons
                }
                .padding(.horizontal, AppSpacing.pageHorizontal)
                .padding(.vertical, AppSpacing.pageVertical)
            }
            .navigationTitle("凯格尔运动")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: handleBack) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.n700)
                    }
                }
            }
            .onAppear {
                timer.configure(level: level)
            }
            .alert("确定要结束练习吗？", isPresented: $showExitConfirmation) {
                Button("继续练习", role: .cancel) { }
                Button("结束", role: .destructive) { dismiss() }
            } message: {
                Text("当前进度不会保存")
            }
            .alert("🎉 练习完成！", isPresented: $showCompletionAlert) {
                Button("太棒了") {
                    markTaskCompleted()
                    dismiss()
                }
            } message: {
                Text("今日凯格尔运动已完成")
            }
            .onChange(of: timer.isCompleted) { _, completed in
                if completed {
                    showCompletionAlert = true
                    triggerCompletionHaptic()
                }
            }
        }
    }
    
    // MARK: - Level Badge
    private var levelBadge: some View {
        Text("\(level.displayName) · \(level.contractDuration)s 收缩 / \(level.relaxDuration)s 放松")
            .font(AppFonts.caption)
            .foregroundStyle(Color.n700)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.accentLight)
            .clipShape(Capsule())
    }
    
    // MARK: - Timer Circle
    private var timerCircle: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(timer.phase == .contract ? Color.primary600.opacity(0.15) : Color.n300.opacity(0.1))
                .frame(width: 240, height: 240)
                .blur(radius: 20)
            
            // Main circle
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 220, height: 220)
                .overlay(
                    Circle()
                        .stroke(
                            timer.phase == .contract ? Color.primary600.opacity(0.25) : Color.n300.opacity(0.18),
                            lineWidth: 2
                        )
                )
                .shadow(color: Color(hex: "C4B5E0").opacity(0.13), radius: 16, x: 0, y: 12)
            
            // Progress ring
            Circle()
                .trim(from: 0, to: timer.progress)
                .stroke(
                    timer.phase == .contract ? Color.primary600 : Color.n500,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.1), value: timer.progress)
            
            // Content
            VStack(spacing: 8) {
                Text(timer.phase == .contract ? "收缩骨盆底肌" : "放松休息")
                    .font(AppFonts.caption)
                    .foregroundStyle(timer.phase == .contract ? Color.primary600 : Color.n500)
                
                Text("\(timer.timeRemaining)")
                    .font(.system(size: 80, weight: .bold, design: .serif))
                    .foregroundStyle(
                        timer.phase == .contract
                            ? LinearGradient.countdownText
                            : LinearGradient(colors: [Color.n500, Color.n300], startPoint: .top, endPoint: .bottom)
                    )
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.2), value: timer.timeRemaining)
            }
        }
    }
    
    // MARK: - Progress Dots
    private var progressDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<level.totalSets, id: \.self) { index in
                Circle()
                    .fill(index < timer.completedSets ? Color.primary600 : Color.n200)
                    .frame(width: 10, height: 10)
                    .animation(.easeInOut(duration: 0.3), value: timer.completedSets)
            }
        }
    }
    
    // MARK: - Progress Text
    private var progressText: some View {
        Text("还剩 \(level.totalSets - timer.completedSets) 组（共 \(level.totalSets) 组）")
            .font(AppFonts.bodyText)
            .foregroundStyle(Color.n500)
    }
    
    // MARK: - Control Buttons
    private var controlButtons: some View {
        HStack(spacing: 20) {
            // Pause/Resume button
            Button(action: togglePause) {
                HStack {
                    Image(systemName: timer.isPaused ? "play.fill" : "pause.fill")
                    Text(timer.isPaused ? "继续" : "暂停")
                }
                .font(AppFonts.cardTitle)
                .foregroundStyle(Color.n700)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.n100)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.full))
            }
            
            // End button
            Button(action: { showExitConfirmation = true }) {
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
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Actions
    private func handleBack() {
        if timer.completedSets > 0 {
            showExitConfirmation = true
        } else {
            dismiss()
        }
    }
    
    private func togglePause() {
        if timer.isPaused {
            timer.resume()
        } else {
            timer.pause()
        }
    }
    
    private func markTaskCompleted() {
        if let task = todayTask {
            task.kegelCompleted = true
            task.kegelCompletedAt = Date()
            task.kegelSets = level.totalSets
            
            // Notify NotificationManager
            NotificationManager.shared.onExerciseCompleted(
                kegelDone: true,
                lamazeDone: task.lamazeCompleted
            )
        }
    }
    
    private func triggerCompletionHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

// MARK: - Kegel Timer
@MainActor
class KegelTimer: ObservableObject {
    enum Phase {
        case contract, relax
    }
    
    @Published var phase: Phase = .contract
    @Published var timeRemaining: Int = 5
    @Published var completedSets: Int = 0
    @Published var isPaused: Bool = false
    @Published var isCompleted: Bool = false
    @Published var progress: Double = 1.0
    
    private var level: KegelLevel = .beginner
    private var timer: Timer?
    private var totalTime: Int = 5
    
    func configure(level: KegelLevel) {
        self.level = level
        self.timeRemaining = level.contractDuration
        self.totalTime = level.contractDuration
        self.progress = 1.0
        startTimer()
    }
    
    func pause() {
        isPaused = true
        timer?.invalidate()
    }
    
    func resume() {
        isPaused = false
        startTimer()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }
    
    private func tick() {
        guard !isPaused else { return }
        
        if timeRemaining > 0 {
            timeRemaining -= 1
            progress = Double(timeRemaining) / Double(totalTime)
            
            // Haptic feedback each second
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        } else {
            switchPhase()
        }
    }
    
    private func switchPhase() {
        // Medium haptic for phase switch
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if phase == .contract {
            // Switch to relax
            phase = .relax
            timeRemaining = level.relaxDuration
            totalTime = level.relaxDuration
            progress = 1.0
        } else {
            // Completed one set, switch to contract
            completedSets += 1
            
            if completedSets >= level.totalSets {
                // All sets completed
                timer?.invalidate()
                isCompleted = true
            } else {
                phase = .contract
                timeRemaining = level.contractDuration
                totalTime = level.contractDuration
                progress = 1.0
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

#Preview {
    KegelExerciseView()
        .modelContainer(for: [UserProfile.self, DailyTask.self], inMemory: true)
}
