//
//  MonitorView.swift
//  CribAlert
//
//  Main monitoring screen showing live camera feed and status.
//

import SwiftUI

struct MonitorView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var appState: AppState
    @StateObject private var monitoringService = MonitoringService()
    @State private var safetyAlertsEnabled: Bool = true
    @State private var showingAlert: AlertType?
    
    // Recent activities (will be populated from monitoring events)
    @State private var recentActivities: [ActivityItem] = []
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Main content based on monitoring state
            mainContent
            
            // Safety alert overlay
            if let alertType = showingAlert {
                alertOverlay(for: alertType)
            }
        }
        .onAppear {
            startMonitoringIfNeeded()
            setupNotificationObserver()
        }
        .onDisappear {
            removeNotificationObserver()
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        switch monitoringService.monitoringState {
        case .idle, .active:
            activeMonitorView
        case .paused(let reason):
            MonitorPausedView(
                pausedReason: reason,
                onReconnect: { Task { try? await monitoringService.resumeMonitoring() } },
                onRunSetup: { /* Navigate to setup */ }
            )
        case .permissionDenied:
            permissionDeniedView
        case .cameraUnavailable:
            MonitorPausedView(
                pausedReason: .cameraDisconnected,
                onReconnect: { Task { try? await monitoringService.startMonitoring() } },
                onRunSetup: { /* Navigate to setup */ }
            )
        }
    }
    
    private var activeMonitorView: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Status card
                    statusCard
                    
                    // Live camera preview
                    cameraPreview
                    
                    // Status indicators
                    statusIndicators
                    
                    // Safety alerts toggle
                    safetyAlertsToggle
                    
                    // Recent activity
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
                                .fill(monitoringService.isMonitoring ? Color.red : Color.gray)
                                .frame(width: 6, height: 6)
                            Text(monitoringService.isMonitoring ? "LIVE" : "OFFLINE")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(monitoringService.isMonitoring ? .red : .gray)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Open settings
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 18))
                            .foregroundColor(.textPrimary)
                    }
                }
            }
        }
    }
    
    private var permissionDeniedView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "camera.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Camera Permission Required")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text("CribAlert needs camera access to monitor your baby. Please enable camera access in Settings.")
                .font(.system(size: 16))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(Color.primaryGreen)
            .cornerRadius(12)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
    
    @ViewBuilder
    private func alertOverlay(for alertType: AlertType) -> some View {
        switch alertType {
        case .rolledOntoStomach, .faceMayCovered:
            HighSeverityAlertView(
                alertType: alertType,
                onViewCamera: { showingAlert = nil },
                onChecking: { dismissAlert() },
                onMarkOkay: { dismissAlert() }
            )
        case .unusualStillness:
            UnusualStillnessAlertView(
                onViewCamera: { showingAlert = nil },
                onChecking: { dismissAlert() },
                onDismiss: { dismissAlert() }
            )
        case .cryingDetected:
            CryingDetectedAlertView(
                onOpenLiveView: { showingAlert = nil },
                onMute: { dismissAlert() },
                onDismiss: { dismissAlert() }
            )
        }
    }
    
    // MARK: - Monitoring Lifecycle
    
    private func startMonitoringIfNeeded() {
        guard !monitoringService.isMonitoring else { return }
        
        Task {
            do {
                try await monitoringService.startMonitoring()
                addActivityItem(description: "Monitoring started", type: .info)
            } catch {
                print("Failed to start monitoring: \(error)")
            }
        }
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            forName: .safetyAlertTriggered,
            object: nil,
            queue: .main
        ) { notification in
            if let alertType = notification.userInfo?["alertType"] as? AlertType {
                self.showingAlert = alertType
                self.addActivityItem(description: alertType.rawValue, type: .alert)
            }
        }
    }
    
    private func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: .safetyAlertTriggered, object: nil)
    }
    
    private func dismissAlert() {
        showingAlert = nil
        monitoringService.dismissAlert()
    }
    
    private func addActivityItem(description: String, type: ActivityType) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let timeString = formatter.string(from: Date())
        
        let item = ActivityItem(time: timeString, description: description, type: type)
        recentActivities.insert(item, at: 0)
        
        // Keep only last 10 items
        if recentActivities.count > 10 {
            recentActivities = Array(recentActivities.prefix(10))
        }
    }
    
    // MARK: - Status Card
    
    private var statusCard: some View {
        let isNormal = monitoringService.currentPosition.isNormal && monitoringService.currentMovement.isNormal
        
        return HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 40, height: 40)
                
                Image(systemName: isNormal ? "checkmark" : "exclamationmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Text(isNormal 
                 ? "\(appState.displayBabyName)'s sleep looks normal"
                 : "Check on \(appState.displayBabyName)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(16)
        .background(isNormal ? Color.primaryGreen : Color.warningOrange)
        .cornerRadius(16)
    }
    
    // MARK: - Camera Preview
    
    private var cameraPreview: some View {
        ZStack {
            // Camera feed placeholder
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.75, green: 0.78, blue: 0.82), Color(red: 0.65, green: 0.68, blue: 0.72)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Placeholder baby image
            VStack {
                Image(systemName: "moon.zzz.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            // Control buttons overlay
            VStack {
                Spacer()
                
                HStack(spacing: 16) {
                    Spacer()
                    
                    // Microphone button
                    cameraControlButton(icon: "mic.fill")
                    
                    // Camera button
                    cameraControlButton(icon: "video.fill")
                    
                    // Fullscreen button
                    Button(action: {}) {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textPrimary)
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                }
                .padding(16)
            }
        }
        .aspectRatio(4/3.5, contentMode: .fit)
        .overlay(
            // LIVE PREVIEW indicator
            VStack {
                Spacer()
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.primaryGreen)
                        .frame(width: 8, height: 8)
                    
                    Text("LIVE PREVIEW")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
                .padding(.bottom, 8)
            }
        )
    }
    
    private func cameraControlButton(icon: String) -> some View {
        Button(action: {}) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
        }
    }
    
    // MARK: - Status Indicators
    
    private var statusIndicators: some View {
        HStack(spacing: 12) {
            // Movement indicator - uses actual monitoring data
            StatusIndicatorCard(
                icon: "waveform.path.ecg",
                title: "Movement",
                value: monitoringService.currentMovement.displayValue,
                subtitle: monitoringService.currentMovement.subtitle,
                isNormal: monitoringService.currentMovement.isNormal
            )
            
            // Position indicator - uses actual monitoring data
            StatusIndicatorCard(
                icon: "bed.double.fill",
                title: "Position",
                value: monitoringService.currentPosition.displayValue,
                subtitle: monitoringService.currentPosition.subtitle,
                isNormal: monitoringService.currentPosition.isNormal
            )
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
                
                Button("View All") {
                    // Navigate to full history
                }
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

// MARK: - Status Indicator Card

struct StatusIndicatorCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let isNormal: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .frame(width: 32, height: 32)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                if isNormal {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.primaryGreen)
                }
            }
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(subtitle)
                .font(.system(size: 13))
                .foregroundColor(.primaryGreen)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Activity Row

struct ActivityRow: View {
    let activity: ActivityItem
    
    var body: some View {
        HStack(spacing: 12) {
            // Time
            Text(activity.time)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.textSecondary)
                .frame(width: 60, alignment: .leading)
            
            // Divider
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 30)
            
            // Status dot
            Circle()
                .fill(activity.type.color)
                .frame(width: 8, height: 8)
            
            // Description
            Text(activity.description)
                .font(.system(size: 15))
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(12)
        .background(Color(red: 0.99, green: 0.97, blue: 0.93))
        .cornerRadius(10)
    }
}

// MARK: - Supporting Types
// ActivityItem and ActivityType are defined in Models/ActivityModels.swift
// MovementStatus and PositionStatus are defined in Models/StatusTypes.swift

// MARK: - Preview

#Preview {
    MonitorView()
        .environmentObject(AppState())
}
