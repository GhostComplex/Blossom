//
//  BlossomApp.swift
//  Blossom (如期)
//
//  Created by SuperCrew on 2026/4/9.
//

import SwiftUI
import SwiftData

@main
struct BlossomApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
            DailyTask.self,
            HospitalBagItem.self,
            FetalMovementRecord.self,
            KnowledgeArticle.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
