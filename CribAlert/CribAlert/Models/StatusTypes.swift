//
//  StatusTypes.swift
//  CribAlert
//
//  Shared status types used across the app.
//

import SwiftUI

// MARK: - Movement Status

enum MovementStatus {
    case still
    case moving
    case unusual
    
    var displayValue: String {
        switch self {
        case .still: return "Still"
        case .moving: return "Moving"
        case .unusual: return "Unusual"
        }
    }
    
    var subtitle: String {
        switch self {
        case .still: return "Looks normal"
        case .moving: return "Active movement"
        case .unusual: return "Check on baby"
        }
    }
    
    var isNormal: Bool {
        switch self {
        case .still, .moving: return true
        case .unusual: return false
        }
    }
}

// MARK: - Position Status

enum PositionStatus {
    case onBack
    case onSide
    case onStomach
    case unknown
    
    var displayValue: String {
        switch self {
        case .onBack: return "On Back"
        case .onSide: return "On Side"
        case .onStomach: return "On Stomach"
        case .unknown: return "Unknown"
        }
    }
    
    var subtitle: String {
        switch self {
        case .onBack: return "Recommended sleep position"
        case .onSide: return "Side position detected"
        case .onStomach: return "Check on baby"
        case .unknown: return "Unable to detect"
        }
    }
    
    var isNormal: Bool {
        switch self {
        case .onBack, .onSide: return true
        case .onStomach, .unknown: return false
        }
    }
}

// MARK: - App Monitoring State (UI Level)

/// Represents the current state of the monitoring UI
enum AppMonitoringState: Equatable {
    /// Monitoring is not active
    case inactive
    
    /// Monitoring is active and running normally
    case active
    
    /// Monitoring is paused due to an issue
    case paused(reason: PausedReason)
    
    /// A safety alert is currently being displayed
    case alerting(alertType: AlertType)
}
