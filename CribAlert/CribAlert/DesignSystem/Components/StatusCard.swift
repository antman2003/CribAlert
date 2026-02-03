//
//  StatusCard.swift
//  CribAlert
//
//  Status card component for displaying monitoring status.
//

import SwiftUI

struct StatusCard: View {
    
    // MARK: - Properties
    
    let status: StatusType
    let message: String
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: status.icon)
                .font(.system(size: 20))
                .foregroundColor(status.iconColor)
            
            Text(message)
                .font(.headlineSmall)
                .foregroundColor(status.textColor)
            
            Spacer()
        }
        .padding(Spacing.cardPadding)
        .background(status.backgroundColor)
        .cornerRadius(CornerRadius.large)
    }
}

// MARK: - Status Types

enum StatusType {
    case normal      // Green - everything okay
    case paused      // Gray - monitoring paused
    case alert       // Amber - attention needed
    
    var icon: String {
        switch self {
        case .normal: return "checkmark.circle.fill"
        case .paused: return "info.circle.fill"
        case .alert: return "exclamationmark.triangle.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .normal: return .white
        case .paused: return .white.opacity(0.8)
        case .alert: return .warningOrange
        }
    }
    
    var textColor: Color {
        switch self {
        case .normal: return .white
        case .paused: return .white
        case .alert: return .textPrimary
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .normal: return .primaryGreen
        case .paused: return .backgroundPaused
        case .alert: return .alertAmber
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        StatusCard(status: .normal, message: "Liam's sleep looks normal")
        StatusCard(status: .paused, message: "Monitoring paused")
        StatusCard(status: .alert, message: "Attention may be needed")
    }
    .padding()
}
