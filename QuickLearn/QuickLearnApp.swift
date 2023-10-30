//
//  QuickLearnApp.swift
//  QuickLearn
//
//  Created by TheMoonThatRises on 10/28/23.
//

import SwiftUI
import SwiftData

@main
struct QuickLearnApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            LearnSet.self
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
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
