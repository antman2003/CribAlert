//
//  PrimaryButton.swift
//  CribAlert
//
//  Primary CTA button component with green background.
//

import SwiftUI

struct PrimaryButton: View {
    
    // MARK: - Properties
    
    let title: String
    let icon: String?
    let isEnabled: Bool
    let action: () -> Void
    
    // MARK: - Initialization
    
    init(
        _ title: String,
        icon: String? = nil,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isEnabled = isEnabled
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xxs) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(.labelLarge)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(Spacing.buttonPadding)
            .background(isEnabled ? Color.primaryGreen : Color.primaryGreen.opacity(0.5))
            .cornerRadius(CornerRadius.large)
        }
        .disabled(!isEnabled)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        PrimaryButton("Start Setup") {
            print("Tapped")
        }
        
        PrimaryButton("Continue", icon: "arrow.right") {
            print("Tapped")
        }
        
        PrimaryButton("Disabled", isEnabled: false) {
            print("Tapped")
        }
    }
    .padding()
}
