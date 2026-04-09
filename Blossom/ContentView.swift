//
//  ContentView.swift
//  Blossom (如期)
//
//  Main TabView with 4 tabs: Home, Tasks, Hospital Bag, Knowledge
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
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

#Preview {
    ContentView()
}
