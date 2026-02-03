//
//  ToggleRow.swift
//  CribAlert
//
//  Toggle row component for settings lists.
//

import SwiftUI

struct ToggleRow: View {
    
    // MARK: - Properties
    
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String?
    @Binding var isOn: Bool
    
    // MARK: - Initialization
    
    init(
        icon: String,
        iconColor: Color = .primaryGreen,
        title: String,
        subtitle: String? = nil,
        isOn: Binding<Bool>
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self._isOn = isOn
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 32, height: 32)
                .background(iconColor.opacity(0.15))
                .cornerRadius(CornerRadius.medium)
            
            // Text content
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headlineSmall)
                    .foregroundColor(.textPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.primaryGreen)
        }
        .padding(Spacing.cardPadding)
        .background(Color.backgroundCard)
        .cornerRadius(CornerRadius.large)
    }
}

// MARK: - Navigation Row

struct NavigationRow: View {
    
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String?
    let action: () -> Void
    
    init(
        icon: String,
        iconColor: Color = .primaryGreen,
        title: String,
        subtitle: String? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
                    .frame(width: 32, height: 32)
                    .background(iconColor.opacity(0.15))
                    .cornerRadius(CornerRadius.medium)
                
                // Text content
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headlineSmall)
                        .foregroundColor(.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.cardPadding)
            .background(Color.backgroundCard)
            .cornerRadius(CornerRadius.large)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        ToggleRow(
            icon: "bell.fill",
            iconColor: .warningOrange,
            title: "Safety Alerts",
            subtitle: "You'll still be able to view live video.",
            isOn: .constant(true)
        )
        
        NavigationRow(
            icon: "slider.horizontal.3",
            iconColor: .accentBlue,
            title: "Alert Preferences",
            subtitle: "Sound, volume, and alert behavior."
        ) {
            print("Tapped")
        }
    }
    .padding()
    .background(Color.backgroundPrimary)
}
