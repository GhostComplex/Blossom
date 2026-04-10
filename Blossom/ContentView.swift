//
//  ContentView.swift
//  Blossom (如期)
//
//  Main entry: shows OnboardingView on first launch, then TabView.
//  Supports URL scheme: blossom://tab/{home|tasks|bag|knowledge}
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var profiles: [UserProfile]
    @State private var selectedTab = 0
    @State private var hasCompletedOnboarding = false
    
    private var needsOnboarding: Bool {
        profiles.isEmpty && !hasCompletedOnboarding
    }
    
    var body: some View {
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
            .onOpenURL { url in
                handleDeepLink(url)
            }
        }
    }
    
    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "blossom",
              url.host == "tab" else { return }
        
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

#Preview {
    ContentView()
}
