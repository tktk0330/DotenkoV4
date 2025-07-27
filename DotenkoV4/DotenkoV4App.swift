//
//  DotenkoV4App.swift
//  DotenkoV4
//
//  Created by Takuma Shinoda on 2025/07/27.
//

import SwiftUI
import SwiftData
#if DEBUG
import Inject
#endif

@main
struct DotenkoV4App: App {
    #if DEBUG
    @ObserveInjection var inject
    #endif
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
