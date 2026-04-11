//
//  ContentView.swift
//  Blossom (拾月)
//
//  Main entry: shows OnboardingView on first launch, then TabView.
//  Supports URL scheme: blossom://tab/{home|tasks|bag|knowledge}
//  Launch args: -skip-onboarding, -tab {home|tasks|bag|knowledge}
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @Query private var profiles: [UserProfile]
    @Query(sort: \DailyTask.date, order: .reverse) private var allTasks: [DailyTask]
    @StateObject private var notificationManager = NotificationManager.shared
    @State private var selectedTab = 0
    @State private var hasCompletedOnboarding = false
    @State private var didProcessLaunchArgs = false
    
    private var needsOnboarding: Bool {
        profiles.isEmpty && !hasCompletedOnboarding
    }
    
    private var todayTask: DailyTask? {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return allTasks.first { calendar.startOfDay(for: $0.date) == today }
    }
    
    var body: some View {
        ZStack {
            Group {
                if needsOnboarding {
                    OnboardingView {
                        hasCompletedOnboarding = true
                    }
                } else {
                    TabView(selection: $selectedTab) {
                        HomeView(selectedTab: $selectedTab)
                            .tabItem {
                                Label("首页", systemImage: "house.fill")
                            }
                            .tag(0)
                        
                        TasksView()
                            .tabItem {
                                Label("任务", systemImage: "checkmark.circle.fill")
                            }
                            .tag(1)
                        
                        HospitalBagView()
                            .tabItem {
                                Label("待产包", systemImage: "bag.fill")
                            }
                            .tag(2)
                        
                        KnowledgeView()
                            .tabItem {
                                Label("知识", systemImage: "book.fill")
                            }
                            .tag(3)
                    }
                    .tint(Color.primary600)
                }
            }
            
            // Notification pre-request overlay
            if notificationManager.shouldShowPreRequest {
                NotificationPreRequestView(
                    triggerSource: notificationManager.preRequestTriggerSource,
                    onAccept: {
                        withAnimation(.spring(response: 0.3)) {
                            notificationManager.acceptPreRequest()
                        }
                    },
                    onDecline: {
                        withAnimation(.spring(response: 0.3)) {
                            notificationManager.declinePreRequest()
                        }
                    }
                )
            }
        }
        .onOpenURL { url in
            handleDeepLink(url)
        }
        .onAppear {
            if !didProcessLaunchArgs {
                processLaunchArguments()
                didProcessLaunchArgs = true
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                notificationManager.onAppBecameActive(
                    profiles: profiles,
                    todayTask: todayTask
                )
            }
        }
    }
    
    // MARK: - Launch Arguments
    // Usage: xcrun simctl launch booted com.blossom.ruqi -skip-onboarding -tab tasks
    private func processLaunchArguments() {
        let args = ProcessInfo.processInfo.arguments
        
        // -skip-onboarding: create default profile and skip
        if args.contains("-skip-onboarding") {
            if profiles.isEmpty {
                let dueDate = Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 15))!
                let profile = UserProfile(dueDate: dueDate)
                modelContext.insert(profile)
                let task = DailyTask(date: Date())
                modelContext.insert(task)
            }
            hasCompletedOnboarding = true
        }
        
        // -reset-notification-state: clear notification UserDefaults for testing
        if args.contains("-reset-notification-state") {
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "notification_hasShownPreRequest")
            defaults.removeObject(forKey: "notification_hasCompletedFirstTask")
            defaults.removeObject(forKey: "notification_permissionGranted")
        }
        
        // -tab {name}: switch to specific tab
        if let tabIndex = args.firstIndex(of: "-tab"),
           tabIndex + 1 < args.count {
            let tabName = args[tabIndex + 1]
            switch tabName {
            case "home":      selectedTab = 0
            case "tasks":     selectedTab = 1
            case "bag":       selectedTab = 2
            case "knowledge": selectedTab = 3
            default: break
            }
        }
    }
    
    // MARK: - Deep Links
    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "blossom" else { return }
        
        if url.host == "skip-onboarding" {
            skipOnboarding()
            return
        }
        
        if url.host == "tab" {
            skipOnboarding()
            let tab = url.pathComponents.dropFirst().first ?? ""
            switch tab {
            case "home":      selectedTab = 0
            case "tasks":     selectedTab = 1
            case "bag":       selectedTab = 2
            case "knowledge": selectedTab = 3
            default: break
            }
        }
    }
    
    private func skipOnboarding() {
        if profiles.isEmpty {
            let dueDate = Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 15))!
            let profile = UserProfile(dueDate: dueDate)
            modelContext.insert(profile)
            let task = DailyTask(date: Date())
            modelContext.insert(task)
        }
        hasCompletedOnboarding = true
    }
}

#Preview {
    ContentView()
}
