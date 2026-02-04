//
//  MonitorPausedView.swift
//  CribAlert
//
//  Monitoring paused state - shown when camera is disconnected or unavailable.
//  This is a STATE of the main monitor screen, not a separate page.
//

import SwiftUI

struct MonitorPausedView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var appState: AppState
    @State private var safetyAlertsEnabled: Bool = true
    
    let pausedReason: PausedReason
    let onReconnect: () -> Void
    let onRunSetup: () -> Void
    
    // Recent activities (preserved from before pause)
    @State private var recentActivities: [ActivityItem] = [
        ActivityItem(time: "10:42 PM", description: "Liam moved slightly", type: .movement),
        ActivityItem(time: "09:15 PM", description: "Sleep detected", type: .info)
    ]
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Paused status card
                    pausedStatusCard
                    
                    // Unavailable camera preview
                    unavailableCameraPreview
                    
                    // Reconnect button
                    reconnectButton
                    
                    // Run setup link
                    runSetupLink
                    
                    // Reassurance message
                    reassuranceMessage
                    
                    // Disabled status indicators
                    disabledStatusIndicators
                    
                    // Safety alerts toggle
                    safetyAlertsToggle
                    
                    // Recent activity (preserved)
                    recentActivitySection
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(Color.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text("\(appState.displayBabyName)'s Room")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 6, height: 6)
                            Text("OFFLINE")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 18))
                            .foregroundColor(.textPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Paused Status Card
    
    private var pausedStatusCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Monitoring paused")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(pausedReason.rawValue)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.backgroundPaused)
        .cornerRadius(16)
    }
    
    // MARK: - Unavailable Camera Preview
    
    private var unavailableCameraPreview: some View {
        ZStack {
            // Blurred/grayed camera background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.backgroundPaused)
            
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "video.slash.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Text("Live view unavailable")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .aspectRatio(4/3, contentMode: .fit)
    }
    
    // MARK: - Reconnect Button
    
    private var reconnectButton: some View {
        Button(action: onReconnect) {
            Text("Reconnect camera")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.primaryGreen)
                .cornerRadius(12)
        }
    }
    
    // MARK: - Run Setup Link
    
    private var runSetupLink: some View {
        Button(action: onRunSetup) {
            Text("Run camera setup")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primaryGreen)
        }
    }
    
    // MARK: - Reassurance Message
    
    private var reassuranceMessage: some View {
        Text("You'll receive alerts again once monitoring resumes.")
            .font(.system(size: 14))
            .foregroundColor(.textSecondary)
            .multilineTextAlignment(.center)
    }
    
    // MARK: - Disabled Status Indicators
    
    private var disabledStatusIndicators: some View {
        HStack(spacing: 12) {
            // Movement indicator (disabled)
            DisabledStatusCard(icon: "waveform.path.ecg", title: "Movement")
            
            // Position indicator (disabled)
            DisabledStatusCard(icon: "bed.double.fill", title: "Position")
        }
    }
    
    // MARK: - Safety Alerts Toggle
    
    private var safetyAlertsToggle: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Safety Alerts")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Text("Notify me of unsafe objects")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $safetyAlertsEnabled)
                .labelsHidden()
                .tint(.primaryGreen)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    // MARK: - Recent Activity
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Activity")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button("View All") {}
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primaryGreen)
            }
            
            VStack(spacing: 8) {
                ForEach(recentActivities) { activity in
                    ActivityRow(activity: activity)
                }
            }
        }
    }
}

// MARK: - Disabled Status Card

struct DisabledStatusCard: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(width: 32, height: 32)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.gray.opacity(0.6))
                
                Spacer()
            }
            
            Text("--")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Waiting for connection")
                .font(.system(size: 13))
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    MonitorPausedView(
        pausedReason: .cameraDisconnected,
        onReconnect: {},
        onRunSetup: {}
    )
    .environmentObject(AppState())
}
