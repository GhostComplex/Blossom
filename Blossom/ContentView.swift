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
                    ZStack(alignment: .bottom) {
                        // Content area
                        Group {
                            switch selectedTab {
                            case 0: HomeView(selectedTab: $selectedTab)
                            case 1: TasksView()
                            case 2: HospitalBagView()
                            case 3: KnowledgeView()
                            default: HomeView(selectedTab: $selectedTab)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                        // Custom Tab Bar
                        CustomTabBar(selectedTab: $selectedTab)
                    }
                    .ignoresSafeArea(.keyboard)
                    .onAppear {
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
    
    // MARK: - Navigation Bar Appearance
    private func configureNavigationBarAppearance() {
        // Large title: Cormorant Garamond Light (design spec: 400 but Light looks closer to mockup)
        let largeTitleFont = UIFont(name: "NotoSerifSC-Light", size: 28)
            ?? UIFont(name: "NotoSerifSC-Regular", size: 28)
            ?? UIFont.systemFont(ofSize: 28, weight: .light).withDesign(.serif)
            ?? UIFont.systemFont(ofSize: 28, weight: .light)
        
        // Inline title: Cormorant Garamond Light
        let inlineTitleFont = UIFont(name: "NotoSerifSC-Light", size: 17)
            ?? UIFont(name: "NotoSerifSC-Regular", size: 17)
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

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Int

    private struct TabItem {
        let icon: String
        let label: String
        let tag: Int
    }

    private let tabs: [TabItem] = [
        TabItem(icon: "house", label: "首页", tag: 0),
        TabItem(icon: "checkmark.circle", label: "任务", tag: 1),
        TabItem(icon: "bag", label: "待产包", tag: 2),
        TabItem(icon: "book", label: "知识", tag: 3),
    ]

    var body: some View {
        HStack {
            ForEach(tabs, id: \.tag) { tab in
                Button(action: { selectedTab = tab.tag }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 18, weight: .regular))
                            .imageScale(.medium)
                        Text(tab.label)
                            .font(AppFonts.tabLabel)
                    }
                    .foregroundStyle(selectedTab == tab.tag ? Color(hex: "A87CC0") : Color(hex: "AEA3C4"))
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier(tab.label)
                .accessibilityAddTraits(selectedTab == tab.tag ? [.isSelected] : [])
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 28)
        .background(
            ZStack {
                // Blur
                Rectangle()
                    .fill(.ultraThinMaterial)
                // Semi-transparent white
                Rectangle()
                    .fill(Color.white.opacity(0.35))
            }
        )
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.white.opacity(0.4))
                .frame(height: 1)
        }
    }
}
