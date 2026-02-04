//
//  WelcomeView.swift
//  CribAlert
//
//  Welcome screen with safety disclaimer.
//  User must acknowledge the disclaimer before proceeding.
//

import SwiftUI

struct WelcomeView: View {
    
    // MARK: - Properties
    
    /// Callback when user completes welcome and wants to proceed
    let onContinue: () -> Void
    
    /// Whether the user has checked the acknowledgment checkbox
    @State private var hasAcknowledged: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with logo
            header
                .padding(.top, 16)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Baby illustration
                    babyIllustration
                    
                    // Title and subtitle
                    titleSection
                    
                    // Safety disclaimer card
                    safetyDisclaimerCard
                    
                    // Acknowledgment checkbox
                    acknowledgmentCheckbox
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            
            // Bottom section with button and page indicator
            bottomSection
        }
        .background(Color.white)
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack(spacing: 12) {
            // Logo icon
            ZStack {
                Circle()
                    .fill(Color.accentBlue.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: "video.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.accentBlue)
            }
            
            Text("CribAlert")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Baby Illustration
    
    private var babyIllustration: some View {
        // Placeholder for baby illustration
        // In production, replace with actual image asset
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.98, green: 0.90, blue: 0.85), Color(red: 0.85, green: 0.92, blue: 0.95)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 280)
            
            // Placeholder content - replace with actual image
            VStack(spacing: 8) {
                Image(systemName: "moon.zzz.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray.opacity(0.4))
                
                Text("Baby Sleeping Illustration")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.6))
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Title Section
    
    private var titleSection: some View {
        VStack(spacing: 12) {
            Text("Welcome to CribAlert")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Let's help everyone get a better night's rest with smart monitoring.")
                .font(.system(size: 16))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
    }
    
    // MARK: - Safety Disclaimer Card
    
    private var safetyDisclaimerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // Shield icon in circle
                ZStack {
                    Circle()
                        .fill(Color.accentBlue.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.accentBlue)
                }
                
                Text("Safety First")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.accentBlue)
            }
            
            Text("Important: This is not a medical device. It does not monitor vital signs or prevent SIDS. Always follow safe sleep guidelines.")
                .font(.system(size: 15))
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.96, green: 0.98, blue: 1.0))
        .cornerRadius(16)
    }
    
    // MARK: - Acknowledgment Checkbox
    
    private var acknowledgmentCheckbox: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                hasAcknowledged.toggle()
            }
        }) {
            HStack(alignment: .top, spacing: 12) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(hasAcknowledged ? Color.accentBlue : Color.gray.opacity(0.4), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if hasAcknowledged {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.accentBlue)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                Text("I understand this is a safety aid, not a medical device.")
                    .font(.system(size: 15))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 8)
    }
    
    // MARK: - Bottom Section
    
    private var bottomSection: some View {
        VStack(spacing: 20) {
            // Start Setup button
            Button(action: {
                if hasAcknowledged {
                    onContinue()
                }
            }) {
                Text("Start Setup")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(hasAcknowledged ? Color.accentBlue : Color.accentBlue.opacity(0.5))
                    .cornerRadius(12)
            }
            .disabled(!hasAcknowledged)
            .padding(.horizontal, 24)
            
            // Page indicator dots
            HStack(spacing: 8) {
                ForEach(0..<4) { index in
                    Circle()
                        .fill(index == 0 ? Color.accentBlue : Color.gray.opacity(0.3))
                        .frame(width: index == 0 ? 24 : 8, height: 8)
                        .animation(.easeInOut(duration: 0.2), value: index)
                }
            }
            .padding(.bottom, 16)
        }
        .padding(.top, 16)
        .background(Color.white)
    }
}

// MARK: - Preview

#Preview {
    WelcomeView {
        print("Continue tapped")
    }
}
