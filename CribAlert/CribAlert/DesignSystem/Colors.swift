//
//  Colors.swift
//  CribAlert
//
//  Design system color tokens matching the UI designs.
//  All colors are defined here for consistency across the app.
//

import SwiftUI

// MARK: - Color Extensions

extension Color {
    
    // MARK: - Primary Colors
    
    /// Primary green used for CTA buttons and positive states
    /// Hex: #00D26A (Bright green)
    static let primaryGreen = Color(red: 0.0, green: 0.824, blue: 0.416)
    
    /// Accent blue used for links, toggles, and secondary actions
    /// Hex: #3B82F6 (Bright blue)
    static let accentBlue = Color(red: 0.231, green: 0.510, blue: 0.965)
    
    // MARK: - Alert Colors
    
    /// Amber/cream background for high severity alerts
    /// Hex: #FEF3C7
    static let alertAmber = Color(red: 0.996, green: 0.953, blue: 0.780)
    
    /// Light blue background for crying alerts
    /// Hex: #EFF6FF
    static let alertBlue = Color(red: 0.937, green: 0.965, blue: 1.0)
    
    /// Warning orange for medium severity indicators
    /// Hex: #F59E0B
    static let warningOrange = Color(red: 0.961, green: 0.620, blue: 0.043)
    
    /// Dark red for alert labels (SAFETY ALERT text)
    /// Hex: #991B1B
    static let alertRed = Color(red: 0.600, green: 0.106, blue: 0.106)
    
    // MARK: - Text Colors
    
    /// Primary text color (dark gray)
    /// Hex: #1F2937
    static let textPrimary = Color(red: 0.122, green: 0.161, blue: 0.216)
    
    /// Secondary text color (medium gray)
    /// Hex: #6B7280
    static let textSecondary = Color(red: 0.420, green: 0.447, blue: 0.502)
    
    /// Tertiary/muted text color (light gray)
    /// Hex: #9CA3AF
    static let textTertiary = Color(red: 0.612, green: 0.639, blue: 0.686)
    
    // MARK: - Background Colors
    
    /// Primary background (light gray-white)
    /// Hex: #F9FAFB
    static let backgroundPrimary = Color(red: 0.976, green: 0.980, blue: 0.984)
    
    /// Card/surface background (white)
    /// Hex: #FFFFFF
    static let backgroundCard = Color.white
    
    /// Secondary background (light gray)
    /// Hex: #F3F4F6
    static let backgroundSecondary = Color(red: 0.953, green: 0.957, blue: 0.965)
    
    /// Paused state background (muted gray-blue)
    /// Hex: #64748B
    static let backgroundPaused = Color(red: 0.392, green: 0.455, blue: 0.545)
    
    // MARK: - Status Colors
    
    /// Offline/disconnected indicator
    /// Hex: #9CA3AF
    static let statusOffline = Color(red: 0.612, green: 0.639, blue: 0.686)
    
    /// Live/active indicator (red dot)
    /// Hex: #EF4444
    static let statusLive = Color(red: 0.937, green: 0.267, blue: 0.267)
    
    /// Success/normal state
    static let statusSuccess = primaryGreen
    
    // MARK: - Border Colors
    
    /// Light border for cards and inputs
    /// Hex: #E5E7EB
    static let borderLight = Color(red: 0.898, green: 0.906, blue: 0.922)
    
    /// Input field border when focused
    static let borderFocused = accentBlue
}

// MARK: - Semantic Color Aliases

extension Color {
    
    /// Color for primary action buttons
    static let buttonPrimary = primaryGreen
    
    /// Color for secondary/outline buttons
    static let buttonSecondary = backgroundCard
    
    /// Color for destructive actions (like sign out)
    static let buttonDestructive = Color.red
    
    /// Toggle "on" state color
    static let toggleOn = primaryGreen
    
    /// Toggle track color when off
    static let toggleOff = Color.gray.opacity(0.3)
}

// MARK: - Color Scheme Support

extension Color {
    
    /// Returns appropriate color for current color scheme
    /// Note: CribAlert uses primarily light UI, but this allows future dark mode support
    static func adaptive(light: Color, dark: Color) -> Color {
        // For V1, we always use light colors as per design
        return light
    }
}
