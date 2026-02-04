//
//  ActivityModels.swift
//  CribAlert
//
//  Shared models for activity tracking used across Monitor and History views.
//

import SwiftUI

// MARK: - Activity Item

struct ActivityItem: Identifiable {
    let id = UUID()
    let time: String
    let description: String
    let type: ActivityType
    let timestamp: Date
    
    init(time: String, description: String, type: ActivityType, timestamp: Date = Date()) {
        self.time = time
        self.description = description
        self.type = type
        self.timestamp = timestamp
    }
}

// MARK: - Activity Type

enum ActivityType {
    case movement
    case position
    case alert
    case info
    
    var color: Color {
        switch self {
        case .movement: return .primaryGreen
        case .position: return .accentBlue
        case .alert: return .warningOrange
        case .info: return .primaryGreen
        }
    }
}
