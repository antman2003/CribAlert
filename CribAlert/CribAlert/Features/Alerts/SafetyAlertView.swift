//
//  SafetyAlertView.swift
//  CribAlert
//
//  Full-screen safety alert views for different alert types.
//  Alerts are calm, actionable, and use observational language only.
//

import SwiftUI

// MARK: - High Severity Alert (Stomach/Face Covered)

struct HighSeverityAlertView: View {
    
    let alertType: AlertType
    let onViewCamera: () -> Void
    let onChecking: () -> Void
    let onMarkOkay: () -> Void
    
    var body: some View {
        ZStack {
            // Amber/cream background
            Color.alertAmber
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 60)
                
                // Alert label
                Text("Safety alert")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textSecondary)
                    .tracking(0.5)
                
                // Alert title
                Text(alertType.rawValue)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                // Description
                Text(alertType.description)
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                // Camera preview
                cameraPreview
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 12) {
                    // Primary: View live camera
                    Button(action: onViewCamera) {
                        HStack(spacing: 10) {
                            Image(systemName: "video.fill")
                                .font(.system(size: 16))
                            Text("View live camera")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.textPrimary)
                        .cornerRadius(12)
                    }
                    
                    // Secondary: I am checking
                    Button(action: onChecking) {
                        Text("I am checking")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    
                    // Tertiary: Mark as okay
                    Button(action: onMarkOkay) {
                        Text("Mark as okay")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
    
    private var cameraPreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            // Camera feed placeholder
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.85, green: 0.78, blue: 0.72), Color(red: 0.75, green: 0.82, blue: 0.85)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .padding(8)
            
            // Baby placeholder
            Image(systemName: "moon.zzz.fill")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.6))
            
            // LIVE badge
            VStack {
                HStack {
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                        Text("LIVE")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(20)
                }
                .padding(20)
                
                Spacer()
            }
        }
        .aspectRatio(4/3.5, contentMode: .fit)
    }
}

// MARK: - Medium Severity Alert (Unusual Stillness)

struct UnusualStillnessAlertView: View {
    
    let onViewCamera: () -> Void
    let onChecking: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // Light background
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                    .frame(height: 40)
                
                // Tag badge
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.warningOrange)
                        .frame(width: 10, height: 10)
                    
                    Text("MONITORING MOVEMENT")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.warningOrange)
                        .tracking(0.5)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.warningOrange.opacity(0.15))
                .cornerRadius(20)
                
                // Title
                Text("Unusual Stillness Detected")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                // Description
                Text("We haven't seen normal movement for a while. This can happen during deep sleep. Please take a moment to check your baby.")
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
                
                // Camera preview
                stillnessCameraPreview
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 12) {
                    // Primary: View live camera
                    Button(action: onViewCamera) {
                        HStack(spacing: 10) {
                            Image(systemName: "video.fill")
                                .font(.system(size: 16))
                            Text("View live camera")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.textPrimary)
                        .cornerRadius(12)
                    }
                    
                    // Secondary: I am checking
                    Button(action: onChecking) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .semibold))
                            Text("I am checking")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(12)
                    }
                    
                    // Tertiary: Dismiss
                    Button(action: onDismiss) {
                        Text("Dismiss")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
    
    private var stillnessCameraPreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.95, green: 0.90, blue: 0.88), Color(red: 0.92, green: 0.88, blue: 0.85)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Baby placeholder
            Image(systemName: "moon.zzz.fill")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.4))
            
            // Live badge
            VStack {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "video.fill")
                            .font(.system(size: 12))
                        Text("Live")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(8)
                    
                    Spacer()
                }
                .padding(16)
                
                Spacer()
                
                // Mute button
                HStack {
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "speaker.slash.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(8)
                    }
                }
                .padding(16)
            }
        }
        .aspectRatio(4/3, contentMode: .fit)
    }
}

// MARK: - Crying Detected Alert

struct CryingDetectedAlertView: View {
    
    let onOpenLiveView: () -> Void
    let onMute: () -> Void
    let onDismiss: () -> Void
    
    // Animation state for sound waves
    @State private var animateWaves = false
    
    var body: some View {
        ZStack {
            // Light blue gradient background
            LinearGradient(
                colors: [Color(red: 0.94, green: 0.97, blue: 1.0), Color(red: 0.88, green: 0.94, blue: 1.0)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 80)
                
                // Sound wave animation
                soundWaveAnimation
                
                // Listening tag
                HStack(spacing: 8) {
                    Image(systemName: "waveform")
                        .font(.system(size: 14))
                    Text("Listening for sounds")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.accentBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.accentBlue.opacity(0.1))
                .cornerRadius(20)
                
                // Title
                Text("Crying Detected")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                // Description
                Text("Your baby sounds upset and may need you.")
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 12) {
                    // Primary: Open live view
                    Button(action: onOpenLiveView) {
                        Text("Open live view")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.accentBlue)
                            .cornerRadius(30)
                    }
                    
                    // Secondary: Mute for 5 minutes
                    Button(action: onMute) {
                        Text("Mute for 5 minutes")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.accentBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(30)
                    }
                    
                    // Tertiary: Dismiss
                    Button(action: onDismiss) {
                        Text("Dismiss")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                animateWaves = true
            }
        }
    }
    
    private var soundWaveAnimation: some View {
        HStack(spacing: 6) {
            ForEach(0..<7, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.accentBlue)
                    .frame(width: 6, height: waveHeight(for: index))
                    .animation(
                        .easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.1),
                        value: animateWaves
                    )
            }
        }
        .frame(height: 60)
    }
    
    private func waveHeight(for index: Int) -> CGFloat {
        let heights: [CGFloat] = [30, 45, 25, 55, 35, 50, 40]
        let baseHeight = heights[index % heights.count]
        return animateWaves ? baseHeight : baseHeight * 0.5
    }
}

// MARK: - Preview

#Preview("Stomach Alert") {
    HighSeverityAlertView(
        alertType: .rolledOntoStomach,
        onViewCamera: {},
        onChecking: {},
        onMarkOkay: {}
    )
}

#Preview("Face Covered Alert") {
    HighSeverityAlertView(
        alertType: .faceMayCovered,
        onViewCamera: {},
        onChecking: {},
        onMarkOkay: {}
    )
}

#Preview("Unusual Stillness") {
    UnusualStillnessAlertView(
        onViewCamera: {},
        onChecking: {},
        onDismiss: {}
    )
}

#Preview("Crying Detected") {
    CryingDetectedAlertView(
        onOpenLiveView: {},
        onMute: {},
        onDismiss: {}
    )
}
