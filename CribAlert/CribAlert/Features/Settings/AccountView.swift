//
//  AccountView.swift
//  CribAlert
//
//  Optional account management screen.
//  Account is NOT required for core monitoring features.
//

import SwiftUI

struct AccountView: View {
    
    // MARK: - Properties
    
    @State private var isLoggedIn = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if isLoggedIn {
                    loggedInView
                } else {
                    loggedOutView
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            .padding(.bottom, 32)
        }
        .background(Color.backgroundPrimary)
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Logged Out View
    
    private var loggedOutView: some View {
        VStack(spacing: 24) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 50))
                    .foregroundColor(.gray.opacity(0.5))
            }
            
            // Title
            VStack(spacing: 8) {
                Text("No Account Required")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("Core monitoring and alerts work without an account. Signing in unlocks optional premium features.")
                    .font(.system(size: 15))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            // Premium features list
            premiumFeaturesList
            
            // Sign in buttons
            VStack(spacing: 12) {
                Button(action: {
                    // Sign in with Apple
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "apple.logo")
                            .font(.system(size: 18))
                        Text("Sign in with Apple")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .cornerRadius(12)
                }
                
                Button(action: {
                    // Sign in with email
                }) {
                    Text("Sign in with Email")
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
            .padding(.top, 8)
            
            // Privacy note
            Text("We never share your data with third parties.")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
        }
    }
    
    // MARK: - Premium Features List
    
    private var premiumFeaturesList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Premium features include:")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.textSecondary)
            
            VStack(spacing: 12) {
                PremiumFeatureRow(icon: "iphone.and.arrow.forward", text: "Multi-device sync")
                PremiumFeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Extended history & insights")
                PremiumFeatureRow(icon: "cloud.fill", text: "Optional cloud backup")
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    // MARK: - Logged In View
    
    private var loggedInView: some View {
        VStack(spacing: 24) {
            // Profile
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.primaryGreen.opacity(0.15))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.primaryGreen)
                }
                
                Text("user@example.com")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textPrimary)
                
                Text("Premium Member")
                    .font(.system(size: 14))
                    .foregroundColor(.primaryGreen)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.primaryGreen.opacity(0.1))
                    .cornerRadius(12)
            }
            
            // Account options
            VStack(spacing: 0) {
                AccountOptionRow(icon: "person.text.rectangle", title: "Edit Profile")
                Divider().padding(.leading, 56)
                AccountOptionRow(icon: "bell.badge", title: "Notification Settings")
                Divider().padding(.leading, 56)
                AccountOptionRow(icon: "creditcard", title: "Subscription")
            }
            .background(Color.white)
            .cornerRadius(12)
            
            // Sign out
            Button(action: {
                isLoggedIn = false
            }) {
                Text("Sign Out")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.red)
            }
            .padding(.top, 16)
        }
    }
}

// MARK: - Premium Feature Row

struct PremiumFeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.primaryGreen)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.textPrimary)
        }
    }
}

// MARK: - Account Option Row

struct AccountOptionRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.accentBlue)
                .frame(width: 32, height: 32)
                .background(Color.accentBlue.opacity(0.1))
                .cornerRadius(8)
            
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.textTertiary)
        }
        .padding(16)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AccountView()
    }
}
