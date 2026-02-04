//
//  AppState.swift
//  CribAlert
//
//  Global application state management.
//  Handles onboarding completion, monitoring status, and user preferences.
//

import SwiftUI
import Combine

/// Global state object shared across the app
@MainActor
final class AppState: ObservableObject {
    
    // MARK: - Onboarding State
    
    /// Whether the user has accepted the safety disclaimer
    @AppStorage("hasAcceptedDisclaimer") var hasAcceptedDisclaimer: Bool = false
    
    /// Whether the user has completed the initial setup flow
    @AppStorage("hasCompletedSetup") var hasCompletedSetup: Bool = false
    
    // MARK: - Baby Profile
    
    /// Baby's name for personalized alerts
    @AppStorage("babyName") var babyName: String = ""
    
    /// Optional sleep location (e.g., "Nursery", "Bedroom")
    @AppStorage("sleepLocation") var sleepLocation: String = ""
    
    // MARK: - Monitoring State
    
    /// Current monitoring status (UI level)
    @Published var monitoringState: AppMonitoringState = .inactive
    
    /// Whether safety alerts are enabled
    @AppStorage("safetyAlertsEnabled") var safetyAlertsEnabled: Bool = true
    
    // MARK: - Alert Preferences
    
    /// Selected alert sound identifier
    @AppStorage("alertSoundId") var alertSoundId: String = "calm_chime"
    
    /// Alert volume (0.0 to 1.0)
    @AppStorage("alertVolume") var alertVolume: Double = 0.75
    
    /// Override silent mode for alerts
    @AppStorage("overrideSilentMode") var overrideSilentMode: Bool = true
    
    /// Selected vibration pattern identifier
    @AppStorage("vibrationPatternId") var vibrationPatternId: String = "heartbeat"
    
    // MARK: - Computed Properties
    
    /// Whether the app should show onboarding
    var shouldShowOnboarding: Bool {
        !hasAcceptedDisclaimer || !hasCompletedSetup
    }
    
    /// Display name for the baby (defaults to "Baby" if not set)
    var displayBabyName: String {
        babyName.isEmpty ? "Baby" : babyName
    }
    
    // MARK: - Methods
    
    /// Reset all onboarding state (for testing or re-setup)
    func resetOnboarding() {
        hasAcceptedDisclaimer = false
        hasCompletedSetup = false
        babyName = ""
        sleepLocation = ""
    }
    
    /// Complete the disclaimer acceptance
    func acceptDisclaimer() {
        hasAcceptedDisclaimer = true
    }
    
    /// Complete the setup flow
    func completeSetup() {
        hasCompletedSetup = true
    }
}

// MARK: - Monitoring State Enum
// Note: AlertType, AlertSeverity, and PausedReason are defined in Models/AlertTypes.swift
// Note: MonitoringState (for service) is defined in Services/MonitoringService.swift
// Note: MovementStatus and PositionStatus are defined in Models/StatusTypes.swift
