//
//  AlertTypes.swift
//  CribAlert
//
//  Alert type definitions for safety alerts.
//  Uses observational language only - no medical claims.
//

import SwiftUI

// MARK: - Alert Types

enum AlertType: String, CaseIterable {
    case rolledOntoStomach = "Baby rolled onto stomach"
    case faceMayCovered = "Baby's face may be covered"
    case unusualStillness = "Unusual Stillness Detected"
    case cryingDetected = "Crying Detected"
    
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
    
    var severity: AlertSeverity {
        switch self {
        case .rolledOntoStomach, .faceMayCovered:
            return .high
        case .unusualStillness, .cryingDetected:
            return .medium
        }
    }
    
    var icon: String {
        switch self {
        case .rolledOntoStomach:
            return "arrow.turn.up.right"
        case .faceMayCovered:
            return "hand.raised.fill"
        case .unusualStillness:
            return "pause.circle.fill"
        case .cryingDetected:
            return "waveform"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .rolledOntoStomach, .faceMayCovered:
            return .alertAmber
        case .unusualStillness:
            return .white
        case .cryingDetected:
            return Color(red: 0.94, green: 0.97, blue: 1.0)
        }
    }
}

// MARK: - Alert Severity

enum AlertSeverity: String {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    
    var color: Color {
        switch self {
        case .high:
            return .alertRed
        case .medium:
            return .warningOrange
        case .low:
            return .accentBlue
        }
    }
}

// MARK: - Paused Reason

enum PausedReason: String {
    case cameraDisconnected = "The camera is not connected right now."
    case appClosed = "The camera app was closed."
    case batteryUnplugged = "Camera device battery is low."
    case networkLost = "Network connection lost."
    case lightingDegraded = "Lighting is too low for monitoring."
    case thermalThrottling = "Device needs to cool down."
}
