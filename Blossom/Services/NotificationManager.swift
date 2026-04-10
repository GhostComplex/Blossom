//
//  NotificationManager.swift
//  Blossom (如期)
//
//  Manages local push notifications for daily reminders.
//  Uses UserNotifications framework (no backend needed).
//

import Foundation
import UserNotifications
import SwiftData

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    @Published var isDenied = false
    
    private let center = UNUserNotificationCenter.current()
    private let notificationIdentifier = "daily-reminder"
    
    // MARK: - Messages (rotated daily)
    
    private let messages: [(String, String)] = [
        ("🌸 今日提醒", "今天的凯格尔运动还没做哦，3 分钟就搞定"),
        ("🫁 呼吸练习", "来练习拉玛泽呼吸吧，为分娩做准备"),
        ("📋 待产包", "看看待产包还有什么没准备的？"),
    ]
    
    // Dynamic message with countdown
    private func countdownMessage(daysLeft: Int) -> (String, String) {
        ("💕 倒计时", "距离与宝宝见面还有 \(daysLeft) 天")
    }
    
    // MARK: - Permission
    
    func requestAuthorization() async {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            isAuthorized = granted
            isDenied = !granted
            
            if granted {
                await scheduleDaily()
            }
        } catch {
            isDenied = true
        }
    }
    
    func checkAuthorizationStatus() async {
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional:
            isAuthorized = true
            isDenied = false
        case .denied:
            isAuthorized = false
            isDenied = true
        case .notDetermined:
            isAuthorized = false
            isDenied = false
        @unknown default:
            break
        }
    }
    
    // MARK: - Schedule
    
    func scheduleDaily(hour: Int = 9, minute: Int = 0, daysLeft: Int? = nil) async {
        // Remove existing
        center.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
        
        guard isAuthorized else { return }
        
        // Pick a message
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let content = UNMutableNotificationContent()
        
        if let days = daysLeft, dayOfYear % 4 == 3 {
            // Every 4th day, show countdown
            let msg = countdownMessage(daysLeft: days)
            content.title = msg.0
            content.body = msg.1
        } else {
            let msg = messages[dayOfYear % messages.count]
            content.title = msg.0
            content.body = msg.1
        }
        
        content.sound = .default
        
        // Schedule for the specified time daily
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        
        do {
            try await center.add(request)
        } catch {
            // Silently fail — notification is non-critical
        }
    }
    
    func cancelAll() {
        center.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }
}
