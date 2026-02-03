//
//  CribAlertApp.swift
//  CribAlert
//
//  Main entry point for the CribAlert baby sleep safety monitoring app.
//  This is a non-medical safety companion app - it does NOT monitor vital signs.
//

import SwiftUI

@main
struct CribAlertApp: App {
    
    // MARK: - App State
    
    /// Global app state shared across all views
    @StateObject private var appState = AppState()
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
