//
//  ContentView.swift
//  Blossom (如期)
//
//  Main entry: shows OnboardingView on first launch, then TabView.
//  Supports URL scheme: blossom://tab/{home|tasks|bag|knowledge}
//  Launch args: -skip-onboarding, -tab {home|tasks|bag|knowledge}
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @State private var selectedTab = 0
    @State private var hasCompletedOnboarding = false
    @State private var didProcessLaunchArgs = false
    
    private var needsOnboarding: Bool {
        profiles.isEmpty && !hasCompletedOnboarding
    }
    
    var body: some View {
        Group {
            if needsOnboarding {
                OnboardingView {
                    hasCompletedOnboarding = true
                }
            } else {
                TabView(selection: $selectedTab) {
                    HomeView()
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
        .onOpenURL { url in
            handleDeepLink(url)
        }
        .onAppear {
            if !didProcessLaunchArgs {
                processLaunchArguments()
                didProcessLaunchArgs = true
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
