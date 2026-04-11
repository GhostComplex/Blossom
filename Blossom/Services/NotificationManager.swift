//
//  NotificationManager.swift
//  Blossom (拾月)
//
//  Manages local push notifications:
//  - Daily 17:00 exercise reminders (smart: only if tasks incomplete)
//  - 7-day comeback reminder for hospital bag
//  - Pre-request popup flow before iOS system permission
//
//  PRD §4.5
//

import Foundation
import UserNotifications
import SwiftData

@MainActor
final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    // MARK: - Published State
    @Published var shouldShowPreRequest = false
    @Published var preRequestTriggerSource: PreRequestTriggerSource = .exercise
    
    /// Trigger source for pre-request popup — determines which copy to show
    enum PreRequestTriggerSource {
        case exercise      // 凯格尔/拉玛泽
        case hospitalBag   // 待产包
    }
    
    // MARK: - UserDefaults Keys
    private let kHasShownPreRequest = "notification_hasShownPreRequest"
    private let kHasCompletedFirstTask = "notification_hasCompletedFirstTask"
    private let kLastAppOpenDate = "notification_lastAppOpenDate"
    private let kNotificationPermissionGranted = "notification_permissionGranted"
    
    // MARK: - Notification Identifiers
    private let dailyReminderID = "daily-exercise-reminder"
    private let dailyReminderTomorrowID = "daily-exercise-reminder-tomorrow"
    private let comebackReminderID = "comeback-reminder"
    
    // MARK: - Notification Copy
    private let copyBothIncomplete = "今天的凯格尔和拉玛泽还没做哦，花几分钟练一下吧"
    private let copyKegelOnly = "今天的凯格尔运动还没做，3 分钟就搞定"
    private let copyLamazeOnly = "今天的拉玛泽呼吸还没练，为分娩做准备吧"
    private let copyComeback = "好久没来了，看看待产包还有什么没准备的？"
    
    private init() {}
    
    // MARK: - First Task Completion Check
    
    /// Called when user completes any task for the first time.
    /// Shows pre-request popup if conditions are met.
    func onTaskCompleted(source: PreRequestTriggerSource = .exercise) {
        let defaults = UserDefaults.standard
        
        // Mark that user has completed at least one task
        if !defaults.bool(forKey: kHasCompletedFirstTask) {
            defaults.set(true, forKey: kHasCompletedFirstTask)
        }
        
        // Show pre-request if never shown before
        if !defaults.bool(forKey: kHasShownPreRequest) {
            preRequestTriggerSource = source
            shouldShowPreRequest = true
        }
    }
    
    /// Called when user taps "好的，提醒我" on pre-request popup
    func acceptPreRequest() {
        UserDefaults.standard.set(true, forKey: kHasShownPreRequest)
        shouldShowPreRequest = false
        
        // Request iOS system permission
        requestSystemPermission()
    }
    
    /// Called when user taps "不了，谢谢" on pre-request popup
    func declinePreRequest() {
        UserDefaults.standard.set(true, forKey: kHasShownPreRequest)
        shouldShowPreRequest = false
    }
    
    // MARK: - System Permission
    
    private func requestSystemPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            Task { @MainActor in
                UserDefaults.standard.set(granted, forKey: self.kNotificationPermissionGranted)
                if granted {
                    // Permission granted — schedule notifications
                    // We need a modelContext, so this will be called from refreshNotifications
                }
            }
        }
    }
    
    // MARK: - App Lifecycle
    
    /// Called every time App becomes active.
    /// Refreshes notification registrations based on current state.
    func onAppBecameActive(profiles: [UserProfile], todayTask: DailyTask?) {
        // Record last open date
        UserDefaults.standard.set(Date(), forKey: kLastAppOpenDate)
        
        // Check if past due date — stop all notifications
        if let profile = profiles.first {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let dueDate = calendar.startOfDay(for: profile.dueDate)
            if today > dueDate {
                cancelAllNotifications()
                return
            }
        }
        
        // Check permission status
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            Task { @MainActor in
                if settings.authorizationStatus == .authorized {
                    self.refreshDailyNotification(todayTask: todayTask)
                    self.refreshTomorrowNotification()
                    self.refreshComebackReminder()
                } else {
                    // Permission revoked or denied — cancel everything
                    UserDefaults.standard.set(false, forKey: self.kNotificationPermissionGranted)
                    self.cancelAllNotifications()
                }
            }
        }
    }
    
    // MARK: - Daily 17:00 Reminder
    
    /// Register or update today's 17:00 notification based on task status
    private func refreshDailyNotification(todayTask: DailyTask?) {
        let center = UNUserNotificationCenter.current()
        
        // Remove existing today notification
        center.removePendingNotificationRequests(withIdentifiers: [dailyReminderID])
        
        guard let task = todayTask else {
            // No task record — register with both-incomplete copy
            scheduleDailyNotification(id: dailyReminderID, body: copyBothIncomplete, forToday: true)
            return
        }
        
        let kegelDone = task.kegelCompleted
        let lamazeDone = task.lamazeCompleted
        
        if kegelDone && lamazeDone {
            // Both done — no notification needed
            return
        }
        
        let body: String
        if !kegelDone && !lamazeDone {
            body = copyBothIncomplete
        } else if !kegelDone {
            body = copyKegelOnly
        } else {
            body = copyLamazeOnly
        }
        
        // Only schedule if 17:00 hasn't passed yet
        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 17
        components.minute = 0
        components.second = 0
        
        if let targetTime = calendar.date(from: components), now < targetTime {
            scheduleDailyNotification(id: dailyReminderID, body: body, forToday: true)
        }
    }
    
    /// Pre-register tomorrow's 17:00 notification with default merged copy
    private func refreshTomorrowNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [dailyReminderTomorrowID])
        scheduleDailyNotification(id: dailyReminderTomorrowID, body: copyBothIncomplete, forToday: false)
    }
    
    private func scheduleDailyNotification(id: String, body: String, forToday: Bool) {
        let content = UNMutableNotificationContent()
        content.title = "今日任务提醒"
        content.body = body
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 17
        dateComponents.minute = 0
        
        if !forToday {
            // Schedule for tomorrow
            let calendar = Calendar.current
            if let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) {
                let tomorrowComponents = calendar.dateComponents([.year, .month, .day], from: tomorrow)
                dateComponents.year = tomorrowComponents.year
                dateComponents.month = tomorrowComponents.month
                dateComponents.day = tomorrowComponents.day
            }
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("[NotificationManager] Failed to schedule \(id): \(error)")
            }
        }
    }
    
    // MARK: - Task Completion Cancellation
    
    /// Called when user completes a task. Cancel today's notification if all done.
    func onExerciseCompleted(kegelDone: Bool, lamazeDone: Bool) {
        // Also trigger pre-request check
        onTaskCompleted(source: .exercise)
        
        if kegelDone && lamazeDone {
            // Both done — cancel today's notification
            UNUserNotificationCenter.current().removePendingNotificationRequests(
                withIdentifiers: [dailyReminderID]
            )
        } else {
            // Update today's notification with correct copy
            let body: String
            if !kegelDone && !lamazeDone {
                body = copyBothIncomplete
            } else if !kegelDone {
                body = copyKegelOnly
            } else {
                body = copyLamazeOnly
            }
            
            // Re-schedule with updated copy
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [dailyReminderID])
            
            let calendar = Calendar.current
            let now = Date()
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.hour = 17
            components.minute = 0
            
            if let targetTime = calendar.date(from: components), now < targetTime {
                scheduleDailyNotification(id: dailyReminderID, body: body, forToday: true)
            }
        }
    }
    
    // MARK: - 7-Day Comeback Reminder
    
    private func refreshComebackReminder() {
        let center = UNUserNotificationCenter.current()
        
        // Cancel existing comeback reminder
        center.removePendingNotificationRequests(withIdentifiers: [comebackReminderID])
        
        // Register new one for 7 days from now
        let content = UNMutableNotificationContent()
        content.title = "好久不见"
        content.body = copyComeback
        content.sound = .default
        
        // 7 days from now
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 7 * 24 * 60 * 60,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: comebackReminderID,
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("[NotificationManager] Failed to schedule comeback: \(error)")
            }
        }
    }
    
    // MARK: - Cleanup
    
    private func cancelAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
}
