//
//  Typography.swift
//  CribAlert
//
//  Design system typography tokens.
//  Uses system fonts (SF Pro) for iOS native feel.
//

import SwiftUI

// MARK: - Typography Styles

extension Font {
    
    // MARK: - Headings
    
    /// Large title (e.g., "Welcome to CribAlert")
    static let displayLarge = Font.system(size: 32, weight: .bold, design: .default)
    
    /// Screen titles
    static let displayMedium = Font.system(size: 28, weight: .bold, design: .default)
    
    /// Section headers
    static let headlineLarge = Font.system(size: 22, weight: .semibold, design: .default)
    
    /// Card titles
    static let headlineMedium = Font.system(size: 18, weight: .semibold, design: .default)
    
    /// List item titles
    static let headlineSmall = Font.system(size: 16, weight: .semibold, design: .default)
    
    // MARK: - Body Text
    
    /// Primary body text
    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)
    
    /// Secondary body text
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)
    
    /// Small body text
    static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)
    
    // MARK: - Labels
    
    /// Button labels
    static let labelLarge = Font.system(size: 17, weight: .semibold, design: .default)
    
    /// Secondary labels
    static let labelMedium = Font.system(size: 14, weight: .medium, design: .default)
    
    /// Small labels (badges, tags)
    static let labelSmall = Font.system(size: 12, weight: .medium, design: .default)
    
    // MARK: - Captions
    
    /// Helper text, timestamps
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    
    /// Very small text
    static let captionSmall = Font.system(size: 11, weight: .regular, design: .default)
}

// MARK: - Text Styles View Modifier

struct CribAlertTextStyle: ViewModifier {
    let font: Font
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}

extension View {
    
    /// Apply CribAlert text style
    func cribAlertText(_ font: Font, color: Color = .textPrimary) -> some View {
        modifier(CribAlertTextStyle(font: font, color: color))
    }
    
    /// Style for main headings
    func headingStyle() -> some View {
        self
            .font(.displayMedium)
            .foregroundColor(.textPrimary)
    }
    
    /// Style for body text
    func bodyStyle() -> some View {
        self
            .font(.bodyLarge)
            .foregroundColor(.textSecondary)
    }
    
    /// Style for captions and helper text
    func captionStyle() -> some View {
        self
            .font(.caption)
            .foregroundColor(.textTertiary)
    }
}
