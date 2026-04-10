//
//  SettingsView.swift
//  Blossom (如期)
//
//  App settings: notification time, about.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var profiles: [UserProfile]
    
    @StateObject private var notificationManager = NotificationManager.shared
    @State private var reminderHour: Int = 9
    @State private var reminderMinute: Int = 0
    @State private var showTimePicker = false
    
    private var profile: UserProfile? { profiles.first }
    
    private var daysLeft: Int? {
        guard let dueDate = profile?.dueDate else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Notification section
                Section {
                    if notificationManager.isDenied {
                        // Permission denied
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "bell.slash.fill")
                                    .foregroundStyle(Color.error)
                                Text("通知已关闭")
                                    .font(AppFonts.cardTitle)
                                    .foregroundStyle(Color.n700)
                            }
                            Text("请前往系统设置开启通知权限")
                                .font(AppFonts.smallLabel)
                                .foregroundStyle(Color.n500)
                            
                            Button("打开系统设置") {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .font(AppFonts.bodyText)
                            .foregroundStyle(Color.primary600)
                        }
                        .padding(.vertical, 4)
                    } else if notificationManager.isAuthorized {
                        // Authorized — show time picker
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundStyle(Color.primary600)
                            Text("每日提醒")
                                .font(AppFonts.cardTitle)
                                .foregroundStyle(Color.n700)
                            Spacer()
                            Button(String(format: "%02d:%02d", reminderHour, reminderMinute)) {
                                showTimePicker = true
                            }
                            .font(AppFonts.bodyText)
                            .foregroundStyle(Color.primary600)
                        }
                    } else {
                        // Not determined
                        Button {
                            Task {
                                await notificationManager.requestAuthorization()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "bell.badge.fill")
                                    .foregroundStyle(Color.warmGold)
                                Text("开启每日提醒")
                                    .font(AppFonts.cardTitle)
                                    .foregroundStyle(Color.n700)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(Color.n300)
                            }
                        }
                    }
                } header: {
                    Text("通知")
                }
                
                // Due date section
                if let profile = profile {
                    Section {
                        HStack {
                            Text("预产期")
                                .font(AppFonts.bodyText)
                                .foregroundStyle(Color.n700)
                            Spacer()
                            Text(profile.dueDate, style: .date)
                                .font(AppFonts.bodyText)
                                .foregroundStyle(Color.n500)
                        }
                    } header: {
                        Text("孕期信息")
                    }
                }
                
                // About section
                Section {
                    HStack {
                        Text("版本")
                            .font(AppFonts.bodyText)
                            .foregroundStyle(Color.n700)
                        Spacer()
                        Text("1.0.0")
                            .font(AppFonts.bodyText)
                            .foregroundStyle(Color.n500)
                    }
                } header: {
                    Text("关于")
                } footer: {
                    Text("如期 — 孕晚期倒计时 & 任务助手\n内容仅供参考，请遵医嘱")
                        .font(AppFonts.smallLabel)
                        .foregroundStyle(Color.n500)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                        .foregroundStyle(Color.primary600)
                }
            }
            .sheet(isPresented: $showTimePicker) {
                TimePickerSheet(hour: $reminderHour, minute: $reminderMinute) {
                    Task {
                        await notificationManager.scheduleDaily(
                            hour: reminderHour,
                            minute: reminderMinute,
                            daysLeft: daysLeft
                        )
                    }
                    // Persist the selected time
                    UserDefaults.standard.set(reminderHour, forKey: "reminderHour")
                    UserDefaults.standard.set(reminderMinute, forKey: "reminderMinute")
                }
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
            .task {
                await notificationManager.checkAuthorizationStatus()
                reminderHour = UserDefaults.standard.object(forKey: "reminderHour") as? Int ?? 9
                reminderMinute = UserDefaults.standard.object(forKey: "reminderMinute") as? Int ?? 0
            }
        }
    }
}

// MARK: - Time Picker Sheet

struct TimePickerSheet: View {
    @Binding var hour: Int
    @Binding var minute: Int
    var onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("设置提醒时间")
                .font(.system(size: 20, weight: .semibold, design: .serif))
                .foregroundStyle(Color.n900)
                .padding(.top, 20)
            
            DatePicker(
                "提醒时间",
                selection: $selectedDate,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .environment(\.locale, Locale(identifier: "zh-Hans"))
            
            Button {
                let components = Calendar.current.dateComponents([.hour, .minute], from: selectedDate)
                hour = components.hour ?? 9
                minute = components.minute ?? 0
                onSave()
                dismiss()
            } label: {
                Text("确定")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.full)
                            .fill(LinearGradient.progressBar)
                    )
            }
            .padding(.horizontal, AppSpacing.pageHorizontal)
            .padding(.bottom, 20)
        }
        .onAppear {
            // Initialize picker with current setting
            var components = DateComponents()
            components.hour = hour
            components.minute = minute
            if let date = Calendar.current.date(from: components) {
                selectedDate = date
            }
        }
    }
}
