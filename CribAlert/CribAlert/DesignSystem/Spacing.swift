//
//  Spacing.swift
//  CribAlert
//
//  Design system spacing tokens based on 8pt grid.
//

import SwiftUI

// MARK: - Spacing Constants

enum Spacing {
    
    // MARK: - Base Grid (8pt)
    
    /// 4pt - Minimal spacing
    static let xxxs: CGFloat = 4
    
    /// 8pt - Extra extra small
    static let xxs: CGFloat = 8
    
    /// 12pt - Extra small
    static let xs: CGFloat = 12
    
    /// 16pt - Small (default padding)
    static let sm: CGFloat = 16
    
    /// 20pt - Medium small
    static let md: CGFloat = 20
    
    /// 24pt - Medium
    static let lg: CGFloat = 24
    
    /// 32pt - Large
    static let xl: CGFloat = 32
    
    /// 40pt - Extra large
    static let xxl: CGFloat = 40
    
    /// 48pt - Extra extra large
    static let xxxl: CGFloat = 48
    
    // MARK: - Semantic Spacing
    
    /// Standard screen horizontal padding
    static let screenHorizontal: CGFloat = 16
    
    /// Standard screen vertical padding
    static let screenVertical: CGFloat = 24
    
    /// Space between cards/sections
    static let sectionGap: CGFloat = 24
    
    /// Space between items in a list
    static let listItemGap: CGFloat = 12
    
    /// Space between elements in a card
    static let cardInnerGap: CGFloat = 16
    
    /// Standard card padding
    static let cardPadding: CGFloat = 16
    
    /// Button internal padding
    static let buttonPadding: CGFloat = 16
    
    /// Icon size - small
    static let iconSmall: CGFloat = 16
    
    /// Icon size - medium
    static let iconMedium: CGFloat = 24
    
    /// Icon size - large
    static let iconLarge: CGFloat = 32
}

// MARK: - Corner Radius

enum CornerRadius {
    
    /// Small corners (4pt) - for small elements
    static let small: CGFloat = 4
    
    /// Medium corners (8pt) - for buttons, inputs
    static let medium: CGFloat = 8
    
    /// Large corners (12pt) - for cards
    static let large: CGFloat = 12
    
    /// Extra large corners (16pt) - for camera preview
    static let extraLarge: CGFloat = 16
    
    /// Full corners - for pills and circular elements
    static let full: CGFloat = 9999
}

// MARK: - View Extensions for Spacing

extension View {
    
    /// Apply standard screen padding
    func screenPadding() -> some View {
        self.padding(.horizontal, Spacing.screenHorizontal)
            .padding(.vertical, Spacing.screenVertical)
    }
    
    /// Apply standard card padding
    func cardPadding() -> some View {
        self.padding(Spacing.cardPadding)
    }
    
    /// Apply standard card styling
    func cardStyle() -> some View {
        self
            .padding(Spacing.cardPadding)
            .background(Color.backgroundCard)
            .cornerRadius(CornerRadius.large)
    }
}
