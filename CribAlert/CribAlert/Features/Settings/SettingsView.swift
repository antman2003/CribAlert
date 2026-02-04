//
//  SettingsView.swift
//  CribAlert
//
//  Main settings screen with navigation to sub-pages.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var appState: AppState
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                // Monitoring section
                Section {
                    NavigationLink(destination: AlertPreferencesView()) {
                        SettingsRow(
                            icon: "bell.fill",
                            iconColor: .accentBlue,
                            title: "Alert Preferences",
                            subtitle: "Sounds, volume, vibration"
                        )
                    }
                    
                    NavigationLink(destination: BabyProfileView()) {
                        SettingsRow(
                            icon: "person.fill",
                            iconColor: .primaryGreen,
                            title: "Baby Profile",
                            subtitle: appState.displayBabyName
                        )
                    }
                } header: {
                    Text("MONITORING")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }
                
                // Privacy section
                Section {
                    NavigationLink(destination: PrivacyView()) {
                        SettingsRow(
                            icon: "lock.shield.fill",
                            iconColor: .accentBlue,
                            title: "Privacy & Data",
                            subtitle: "How we protect your data"
                        )
                    }
                } header: {
                    Text("PRIVACY")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }
                
                // Support section
                Section {
                    NavigationLink(destination: HelpSupportView()) {
                        SettingsRow(
                            icon: "questionmark.circle.fill",
                            iconColor: .warningOrange,
                            title: "Help & Support",
                            subtitle: "FAQ, contact us"
                        )
                    }
                } header: {
                    Text("SUPPORT")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }
                
                // Account section (optional)
                Section {
                    NavigationLink(destination: AccountView()) {
                        SettingsRow(
                            icon: "person.crop.circle.fill",
                            iconColor: .textSecondary,
                            title: "Account",
                            subtitle: "Optional – for premium features"
                        )
                    }
                } header: {
                    Text("ACCOUNT")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }
                
                // App info
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 4) {
                            Text("CribAlert v1.0.0")
                                .font(.system(size: 13))
                                .foregroundColor(.textSecondary)
                            Text("Made with ❤️ for parents")
                                .font(.system(size: 12))
                                .foregroundColor(.textTertiary)
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.insetGrouped)
            .background(Color.backgroundPrimary)
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(iconColor)
                .frame(width: 32, height: 32)
                .background(iconColor.opacity(0.15))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textPrimary)
                
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
