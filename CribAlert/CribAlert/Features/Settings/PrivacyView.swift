//
//  PrivacyView.swift
//  CribAlert
//
//  Privacy & data transparency settings showing how user data is protected.
//

import SwiftUI

struct PrivacyView: View {
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with shield icon
                headerSection
                
                // Privacy guarantee cards
                privacyCards
                
                // Data protection button
                dataProtectionButton
                
                // Footer
                footerSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 32)
        }
        .background(Color.backgroundPrimary)
        .navigationTitle("Privacy & Data")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Shield icon
            ZStack {
                Circle()
                    .fill(Color.accentBlue.opacity(0.15))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.accentBlue)
            }
            
            Text("Privacy Guarantee")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text("Your baby's video and audio feeds are protected with strict privacy standards.")
                .font(.system(size: 16))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
    }
    
    // MARK: - Privacy Cards
    
    private var privacyCards: some View {
        VStack(spacing: 12) {
            PrivacyCard(
                icon: "cpu.fill",
                iconColor: .accentBlue,
                title: "All safety analysis runs directly on your device.",
                description: "Video and audio are analyzed locally on your phone, ensuring no data leaves your device for analysis."
            )
            
            PrivacyCard(
                icon: "video.slash.fill",
                iconColor: .accentBlue,
                title: "Video is not recorded or uploaded by default.",
                description: "Real-time monitoring works entirely without cloud transmission. No footage is stored externally."
            )
            
            PrivacyCard(
                icon: "person.crop.circle.badge.xmark",
                iconColor: .accentBlue,
                title: "An account is only required for optional premium features.",
                description: "Basic monitoring and alerts work without creating an account."
            )
        }
    }
    
    // MARK: - Data Protection Button
    
    private var dataProtectionButton: some View {
        Button(action: {
            // Show data protection details
        }) {
            Text("How we protect your data")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.accentBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.accentBlue, lineWidth: 1)
                )
        }
    }
    
    // MARK: - Footer Section
    
    private var footerSection: some View {
        VStack(spacing: 16) {
            Text("Your baby's video stays on your device unless you choose otherwise.")
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 6) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.primaryGreen)
                
                Text("ENCRYPTED & SECURE")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.primaryGreen)
                    .tracking(0.5)
            }
            
            Button("Read full Privacy Policy") {
                // Open privacy policy
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.textSecondary)
            .underline()
        }
    }
}

// MARK: - Privacy Card

struct PrivacyCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(iconColor.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(3)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PrivacyView()
    }
}
