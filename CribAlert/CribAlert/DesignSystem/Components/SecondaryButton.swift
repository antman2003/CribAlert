//
//  SecondaryButton.swift
//  CribAlert
//
//  Secondary button component with white/outlined style.
//

import SwiftUI

struct SecondaryButton: View {
    
    // MARK: - Properties
    
    let title: String
    let icon: String?
    let style: SecondaryButtonStyle
    let action: () -> Void
    
    // MARK: - Initialization
    
    init(
        _ title: String,
        icon: String? = nil,
        style: SecondaryButtonStyle = .outlined,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
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
            .foregroundColor(style.foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(Spacing.buttonPadding)
            .background(style.backgroundColor)
            .cornerRadius(CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
        }
    }
}

// MARK: - Button Styles

enum SecondaryButtonStyle {
    case outlined      // White with gray border
    case filled        // White/light gray filled
    case dark          // Dark/black filled (for alerts)
    case text          // Text only, no background
    
    var backgroundColor: Color {
        switch self {
        case .outlined: return .white
        case .filled: return .backgroundSecondary
        case .dark: return .textPrimary
        case .text: return .clear
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .outlined: return .textPrimary
        case .filled: return .textPrimary
        case .dark: return .white
        case .text: return .accentBlue
        }
    }
    
    var borderColor: Color {
        switch self {
        case .outlined: return .borderLight
        case .filled: return .clear
        case .dark: return .clear
        case .text: return .clear
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .outlined: return 1
        default: return 0
        }
    }
}

// MARK: - Text Link Button

struct TextLinkButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    init(_ title: String, color: Color = .accentBlue, action: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.bodyMedium)
                .foregroundColor(color)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        SecondaryButton("I am checking", style: .outlined) {
            print("Tapped")
        }
        
        SecondaryButton("Sign in", style: .filled) {
            print("Tapped")
        }
        
        SecondaryButton("View live camera", icon: "video.fill", style: .dark) {
            print("Tapped")
        }
        
        TextLinkButton("Mark as okay") {
            print("Tapped")
        }
        
        TextLinkButton("Skip", color: .textSecondary) {
            print("Tapped")
        }
    }
    .padding()
}
