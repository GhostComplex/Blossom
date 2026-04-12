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
                    Text("记录胎动")
                        .font(AppFonts.caption)
                        .foregroundStyle(Color.n500)
                    
                    // Counter display — frosted circle
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(Color.primary600.opacity(0.08))
                            .frame(width: 170, height: 170)
                            .blur(radius: 15)

                        // Frosted circle
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 140, height: 140)
                            .overlay(
                                Circle()
                                    .fill(Color.white.opacity(0.4))
                            )
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
                            )
                            .shadow(color: Color(hex: "C4B5E0").opacity(0.10), radius: 12, x: 0, y: 4)

                        // Number
                        Text("\(count)")
                            .font(.custom("CormorantGaramond-Light", size: 48))
                            .foregroundStyle(Color.n900)
                            .contentTransition(.numericText())
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: count)
                    }
                    
                    // +1 Button — 56px purple circle
                    Button(action: incrementCount) {
                        ZStack {
                            Circle()
                                .fill(Color.primary600)
                                .frame(width: 56, height: 56)
                                .shadow(color: Color.primary600.opacity(0.3), radius: 12, x: 0, y: 6)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .light))
                                .foregroundStyle(.white)
                        }
                    }
                    .accessibilityLabel("胎动加一")
                    .buttonStyle(ScaleButtonStyle())
                    
                    Text("感受到胎动时点击 +1")
                        .font(AppFonts.caption)
                        .foregroundStyle(Color.n500)
                    
                    Spacer()
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        // Cancel — frosted
                        Button(action: { dismiss() }) {
                            Text("取消")
                                .font(.custom("Nunito-SemiBold", size: 13))
                                .foregroundStyle(Color.n700)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(.ultraThinMaterial)
                                .background(Color.white.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppRadius.md)
                                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                                )
                        }
                        
                        // Finish — purple solid
                        Button(action: saveRecord) {
                            Text("完成")
                                .font(.custom("Nunito-SemiBold", size: 13))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(count > 0 ? Color.primary600 : Color.n300)
                                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
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
