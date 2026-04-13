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
    @State private var showCompletionView = false

    private var profile: UserProfile? { profiles.first }
    private var todayTask: DailyTask? { todayTasks.first }
    private var level: KegelLevel { profile?.currentKegelLevel ?? .beginner }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background — design-v2: 165deg, #FEF2F6 → #F0E4F6 → #E8DEF4 → #E0D6F0
                LinearGradient(
                    stops: [
                        .init(color: Color(hex: "FEF2F6"), location: 0.0),
                        .init(color: Color(hex: "F0E4F6"), location: 0.35),
                        .init(color: Color(hex: "E8DEF4"), location: 0.65),
                        .init(color: Color(hex: "E0D6F0"), location: 1.0)
                    ],
                    startPoint: UnitPoint(x: 0.41, y: 0.0),
                    endPoint: UnitPoint(x: 0.59, y: 1.0)
                )
                .ignoresSafeArea()

                // Background decorations (.kg::before, ::after, .kg-arc)
                Circle()
                    .fill(Color.white.opacity(0.06))
                    .frame(width: 200, height: 200)
                    .offset(x: -60, y: 40)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                Circle()
                    .fill(Color.white.opacity(0.04))
                    .frame(width: 280, height: 280)
                    .offset(x: 80, y: -60)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

                Ellipse()
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    .frame(width: 200, height: 400)
                    .offset(x: 100, y: -50)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)

                VStack(spacing: 0) {
                    Spacer()

                    // Level indicator
                    levelBadge
                        .padding(.bottom, 10)

                    // Phase text — above the ring
                    phaseText
                        .padding(.bottom, 28)

                    // Main timer circle
                    timerCircle
                        .padding(.bottom, 32)

                    // Progress text (single, merged)
                    progressText
                        .padding(.bottom, 36)

                    // Control buttons
                    controlButtons

                    Spacer()
                }
                .padding(.horizontal, AppSpacing.pageHorizontal)
                .padding(.vertical, AppSpacing.pageVertical)
            }
            .navigationBarHidden(true)
            .onAppear {
                timer.configure(level: level)
            }
            .overlay {
                ExitConfirmationOverlay(
                    isPresented: $showExitConfirmation,
                    onExit: { dismiss() }
                )
            }
            .fullScreenCover(isPresented: $showCompletionView) {
                ExerciseCompletionView(exerciseName: "凯格尔运动") {
                    markTaskCompleted()
                    showCompletionView = false
                    dismiss()
                }
            }
            .onChange(of: timer.isCompleted) { _, completed in
                if completed {
                    triggerCompletionHaptic()
                    showCompletionView = true
                }
            }
        }
    }

    // MARK: - Level Badge
    private var levelBadge: some View {
        Text("\(level.displayName) · \(level.contractDuration)s 收缩 / \(level.relaxDuration)s 放松")
            .font(.custom("Nunito-Regular", size: 11))
            .tracking(2)
            .textCase(.uppercase)
            .foregroundStyle(Color.n300)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.5))
            .clipShape(Capsule())
    }

    // MARK: - Phase Text (above ring)
    private var phaseText: some View {
        Text(timer.phase == .contract ? "收缩骨盆底肌" : "放松休息")
            .font(.custom("NotoSerifSC-Regular", size: 26))
            .tracking(0.3)
            .foregroundStyle(timer.phase == .contract ? Color.primaryDark : Color.n500)
    }

    // MARK: - Timer Circle
    private var timerCircle: some View {
        ZStack {
            // Ring glow — design: inset -8px = 8px outward, box-shadow 0 0 30px
            Circle()
                .fill(Color.clear)
                .frame(width: 216, height: 216)
                .shadow(color: Color(hex: "C4A0DC").opacity(0.15), radius: 30, x: 0, y: 0)

            // Track ring (subtle)
            Circle()
                .stroke(Color(hex: "B7A8D6").opacity(0.2), lineWidth: 2)
                .frame(width: 200, height: 200)

            // Progress ring (thin, with glow)
            Circle()
                .trim(from: 0, to: timer.progress)
                .stroke(
                    Color.primary600,
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                )
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))
                .shadow(color: Color.primary600.opacity(0.3), radius: 30, x: 0, y: 0)
                .animation(.linear(duration: 0.1), value: timer.progress)

            // Frosted center — inset 12px from 200 = 176
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 176, height: 176)
                .overlay(
                    Circle()
                        .fill(Color.white.opacity(0.4))
                )
                .clipShape(Circle())

            // Content — number + 秒 label inside ring
            VStack(spacing: 4) {
                Text("\(timer.timeRemaining)")
                    .font(.custom("NotoSerifSC-Regular", size: 60))
                    .tracking(-1)
                    .foregroundStyle(Color.n900)
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.2), value: timer.timeRemaining)

                // 秒 label
                Text("秒")
                    .font(.custom("Nunito-Regular", size: 11))
                    .foregroundStyle(Color.n300)
            }
        }
    }

    // MARK: - Progress Text
    private var progressText: some View {
        Text("第 \(timer.completedSets + 1) 组 / 共 \(level.totalSets) 组")
            .font(.custom("Nunito-Regular", size: 12))
            .tracking(0.5)
            .foregroundStyle(Color.n300)
    }

    // MARK: - Control Buttons
    private var controlButtons: some View {
        HStack(spacing: 14) {
            // Pause/Resume button (semi-transparent white)
            Button(action: togglePause) {
                HStack {
                    Image(systemName: timer.isPaused ? "play.fill" : "pause.fill")
                    Text(timer.isPaused ? "继续" : "暂停")
                }
                .font(.custom("Nunito-SemiBold", size: 13))
                .tracking(0.3)
                .foregroundStyle(Color.n500)
                .padding(.horizontal, 32)
                .padding(.vertical, 13)
                .background(.ultraThinMaterial)
                .background(Color.white.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                )
            }

            // End button (purple solid)
            Button(action: { showExitConfirmation = true }) {
                HStack {
                    Image(systemName: "xmark")
                    Text("结束")
                }
                .font(.custom("Nunito-SemiBold", size: 13))
                .tracking(0.3)
                .foregroundStyle(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 13)
                .background(Color.primary600)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
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
