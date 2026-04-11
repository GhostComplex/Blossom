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

// MARK: - UIFont Design Helper
extension UIFont {
    func withDesign(_ design: UIFontDescriptor.SystemDesign) -> UIFont? {
        guard let descriptor = fontDescriptor.withDesign(design) else { return nil }
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}

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
                                Label("首页", systemImage: "house")
                            }
                            .tag(0)
                        
                        TasksView()
                            .tabItem {
                                Label("任务", systemImage: "checkmark.circle")
                            }
                            .tag(1)
                        
                        HospitalBagView()
                            .tabItem {
                                Label("待产包", systemImage: "bag")
                            }
                            .tag(2)
                        
                        KnowledgeView()
                            .tabItem {
                                Label("知识", systemImage: "book")
                            }
                            .tag(3)
                    }
                    .tint(Color.primaryDark)
                    .onAppear {
                        configureTabBarAppearance()
                        configureNavigationBarAppearance()
                    }
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
    
    // MARK: - Tab Bar Appearance
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        // Semi-transparent background
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundEffect = blurEffect
        
        // Active / inactive colors
        let activeColor = UIColor(Color.primaryDark)
        let inactiveColor = UIColor(Color.n300)
        
        appearance.stackedLayoutAppearance.selected.iconColor = activeColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: activeColor]
        appearance.stackedLayoutAppearance.normal.iconColor = inactiveColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: inactiveColor]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    // MARK: - Navigation Bar Appearance
    private func configureNavigationBarAppearance() {
        // Large title: serif font (Cormorant Garamond style)
        let largeTitleFont = UIFont(name: "CormorantGaramond-Regular", size: 28)
            ?? UIFont.systemFont(ofSize: 28, weight: .light).withDesign(.serif)
            ?? UIFont.systemFont(ofSize: 28, weight: .light)
        
        // Inline title: serif font
        let inlineTitleFont = UIFont(name: "CormorantGaramond-Regular", size: 17)
            ?? UIFont.systemFont(ofSize: 17, weight: .light).withDesign(.serif)
            ?? UIFont.systemFont(ofSize: 17, weight: .light)
        
        let titleColor = UIColor(Color.n900)
        
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.largeTitleTextAttributes = [
            .font: largeTitleFont,
            .foregroundColor: titleColor
        ]
        navAppearance.titleTextAttributes = [
            .font: inlineTitleFont,
            .foregroundColor: titleColor
        ]
        
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
    }
}

#Preview {
    ContentView()
}
