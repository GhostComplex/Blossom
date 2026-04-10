//
//  FetalMovementCounterView.swift
//  Blossom (拾月)
//
//  胎动记录计数器
//

import SwiftUI
import SwiftData

struct FetalMovementCounterView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var count: Int = 0
    @State private var showSaveConfirmation = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.pageBackground
                    .ignoresSafeArea()
                
                VStack(spacing: AppSpacing.xxxl) {
                    Spacer()
                    
                    // Title
                    Text("胎动次数")
                        .font(AppFonts.caption)
                        .foregroundStyle(Color.n500)
                    
                    // Counter display
                    Text("\(count)")
                        .font(.system(size: 100, weight: .bold, design: .serif))
                        .foregroundStyle(LinearGradient.countdownText)
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: count)
                    
                    // +1 Button
                    Button(action: incrementCount) {
                        ZStack {
                            Circle()
                                .fill(Color.primary600)
                                .frame(width: 120, height: 120)
                                .shadow(color: Color.primary600.opacity(0.4), radius: 20, x: 0, y: 10)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 48, weight: .medium))
                                .foregroundStyle(.white)
                        }
                    }
                    .buttonStyle(ScaleButtonStyle())
                    
                    Text("感受到胎动时点击 +1")
                        .font(AppFonts.caption)
                        .foregroundStyle(Color.n500)
                    
                    Spacer()
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        Button(action: { dismiss() }) {
                            Text("取消")
                                .font(AppFonts.cardTitle)
                                .foregroundStyle(Color.n700)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.n100)
                                .clipShape(RoundedRectangle(cornerRadius: AppRadius.full))
                        }
                        
                        Button(action: saveRecord) {
                            Text("完成")
                                .font(AppFonts.cardTitle)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(count > 0 ? Color.primary600 : Color.n300)
                                .clipShape(RoundedRectangle(cornerRadius: AppRadius.full))
                        }
                        .disabled(count == 0)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, AppSpacing.pageHorizontal)
            }
            .navigationTitle("记录胎动")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }
                        .foregroundStyle(Color.n700)
                }
            }
            .alert("✓ 记录成功", isPresented: $showSaveConfirmation) {
                Button("好的") { dismiss() }
            } message: {
                Text("已记录 \(count) 次胎动")
            }
        }
    }
    
    private func incrementCount() {
        count += 1
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func saveRecord() {
        let record = FetalMovementRecord(count: count)
        modelContext.insert(record)
        
        // Success haptic
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        showSaveConfirmation = true
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

#Preview {
    FetalMovementCounterView()
        .modelContainer(for: FetalMovementRecord.self, inMemory: true)
}
