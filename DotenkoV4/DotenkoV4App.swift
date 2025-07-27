//
//  DotenkoV4App.swift
//  DotenkoV4
//
//  Created by Takuma Shinoda on 2025/07/27.
//

import SwiftUI
#if DEBUG
import Inject
#endif

@main
struct DotenkoV4App: App {
    #if DEBUG
    @ObserveInjection var inject
    #endif

    var body: some Scene {
        WindowGroup {
            MainContentView()
        }
    }
}
