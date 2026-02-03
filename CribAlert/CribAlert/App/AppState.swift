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
    
    /// Current monitoring status
    @Published var monitoringState: MonitoringState = .inactive
    
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

/// Represents the current state of the monitoring system
enum MonitoringState: Equatable {
    /// Monitoring is not active
    case inactive
    
    /// Monitoring is active and running normally
    case active
    
    /// Monitoring is paused due to an issue
    case paused(reason: PausedReason)
    
    /// A safety alert is currently being displayed
    case alerting(alertType: AlertType)
}

/// Reasons why monitoring might be paused
enum PausedReason: String, Equatable {
    case cameraDisconnected = "The camera is not connected right now."
    case appBackgrounded = "The app is running in the background."
    case lowBattery = "Battery is too low for monitoring."
    case thermalThrottling = "Device is too warm. Monitoring paused to cool down."
    case permissionDenied = "Camera permission is required for monitoring."
}

/// Types of safety alerts that can be triggered
enum AlertType: String, Equatable {
    case rolledOntoStomach = "Baby rolled onto stomach"
    case faceMayCovered = "Baby's face may be covered"
    case unusualStillness = "Unusual stillness detected"
    case cryingDetected = "Crying detected"
    
    /// Severity level of the alert
    var severity: AlertSeverity {
        switch self {
        case .rolledOntoStomach, .faceMayCovered:
            return .high
        case .unusualStillness, .cryingDetected:
            return .medium
        }
    }
    
    /// Description text shown on the alert
    var description: String {
        switch self {
        case .rolledOntoStomach:
            return "Please check your baby"
        case .faceMayCovered:
            return "Please check the sleep area to make sure your baby's face is clear."
        case .unusualStillness:
            return "We haven't seen normal movement for a while. This can happen during deep sleep. Please take a moment to check your baby."
        case .cryingDetected:
            return "Your baby sounds upset and may need you."
        }
    }
}

/// Alert severity levels
enum AlertSeverity {
    case high
    case medium
}
