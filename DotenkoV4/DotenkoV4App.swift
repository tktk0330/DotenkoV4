//
//  DotenkoV4App.swift
//  DotenkoV4
//
//  Created by Takuma Shinoda on 2025/07/27.
//

import SwiftUI
import SwiftData
import FirebaseCore
#if DEBUG
import Inject
#endif

// MARK: - Firebase設定用App Delegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Firebase初期化
        FirebaseApp.configure()
        return true
    }
}

@main
struct DotenkoV4App: App {
    #if DEBUG
    @ObserveInjection var inject
    #endif
    
    // Firebase App Delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // SwiftDataコンテナ
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self
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
            MainContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
