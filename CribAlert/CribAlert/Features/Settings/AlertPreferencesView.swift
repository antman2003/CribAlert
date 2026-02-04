//
//  AlertPreferencesView.swift
//  CribAlert
//
//  Settings for alert sounds, volume, and vibration patterns.
//

import SwiftUI

struct AlertPreferencesView: View {
    
    // MARK: - Properties
    
    @State private var selectedSound: AlertSound = .calmChime
    @State private var volume: Double = 0.75
    @State private var overrideSilentMode: Bool = true
    @State private var selectedVibration: VibrationPattern = .heartbeat
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Alert Sounds section
                alertSoundsSection
                
                // Volume section
                volumeSection
                
                // Critical Safety section
                criticalSafetySection
                
                // Vibration Pattern section
                vibrationPatternSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color.backgroundPrimary)
        .navigationTitle("Alert Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Alert Sounds Section
    
    private var alertSoundsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ALERT SOUNDS")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.textSecondary)
                .tracking(0.5)
            
            VStack(spacing: 0) {
                ForEach(AlertSound.allCases) { sound in
                    soundRow(sound)
                    
                    if sound != AlertSound.allCases.last {
                        Divider()
                            .padding(.leading, 50)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            
            Text("Choose a sound that will wake you without causing stress.")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
        }
    }
    
    private func soundRow(_ sound: AlertSound) -> some View {
        HStack(spacing: 14) {
            // Radio button
            Circle()
                .strokeBorder(selectedSound == sound ? Color.accentBlue : Color.gray.opacity(0.3), lineWidth: 2)
                .background(
                    Circle()
                        .fill(selectedSound == sound ? Color.accentBlue : Color.clear)
                        .padding(4)
                )
                .frame(width: 24, height: 24)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedSound = sound
                    }
                }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 8) {
                    Text(sound.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textPrimary)
                    
                    if sound.isRecommended {
                        Text("RECOMMENDED")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.accentBlue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.accentBlue.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                
                Text(sound.description)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Play button
            Button(action: {
                // Play sound preview
            }) {
                Image(systemName: "play.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.accentBlue)
                    .cornerRadius(18)
            }
        }
        .padding(16)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedSound = sound
            }
        }
    }
    
    // MARK: - Volume Section
    
    private var volumeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("VOLUME")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.textSecondary)
                .tracking(0.5)
            
            VStack(spacing: 8) {
                HStack {
                    Text("Alert Volume")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Text("\(Int(volume * 100))%")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "speaker.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                    
                    Slider(value: $volume, in: 0...1)
                        .tint(.accentBlue)
                    
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            
            Text("Test this volume with your phone locked.")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
        }
    }
    
    // MARK: - Critical Safety Section
    
    private var criticalSafetySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CRITICAL SAFETY")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.textSecondary)
                .tracking(0.5)
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Override Silent Mode")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textPrimary)
                        
                        Text("Settings that help ensure alerts aren't missed.")
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $overrideSilentMode)
                        .labelsHidden()
                        .tint(.accentBlue)
                }
                .padding(16)
                
                // Recommendation banner
                HStack(spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.accentBlue)
                    
                    Text("We recommend keeping this enabled to ensure you never miss a safety notification.")
                        .font(.system(size: 13))
                        .foregroundColor(.accentBlue)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .background(Color.accentBlue.opacity(0.08))
            }
            .background(Color.white)
            .cornerRadius(12)
        }
    }
    
    // MARK: - Vibration Pattern Section
    
    private var vibrationPatternSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("VIBRATION PATTERN")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.textSecondary)
                .tracking(0.5)
            
            VStack(spacing: 0) {
                ForEach(VibrationPattern.allCases) { pattern in
                    vibrationRow(pattern)
                    
                    if pattern != VibrationPattern.allCases.last {
                        Divider()
                            .padding(.leading, 50)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(12)
        }
    }
    
    private func vibrationRow(_ pattern: VibrationPattern) -> some View {
        HStack(spacing: 14) {
            // Icon
            Image(systemName: pattern.icon)
                .font(.system(size: 16))
                .foregroundColor(.textSecondary)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(pattern.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textPrimary)
                
                Text(pattern.description)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Radio button
            Circle()
                .strokeBorder(selectedVibration == pattern ? Color.accentBlue : Color.gray.opacity(0.3), lineWidth: 2)
                .background(
                    Circle()
                        .fill(selectedVibration == pattern ? Color.accentBlue : Color.clear)
                        .padding(4)
                )
                .frame(width: 24, height: 24)
        }
        .padding(16)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedVibration = pattern
            }
        }
    }
}

// MARK: - Supporting Types

enum AlertSound: String, CaseIterable, Identifiable {
    case calmChime
    case softMelody
    case clearPulse
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .calmChime: return "Calm Chime"
        case .softMelody: return "Soft Melody"
        case .clearPulse: return "Clear Pulse"
        }
    }
    
    var description: String {
        switch self {
        case .calmChime: return "Default tone"
        case .softMelody: return "Gentle lullaby"
        case .clearPulse: return "Rhythmic pulse"
        }
    }
    
    var isRecommended: Bool {
        self == .calmChime
    }
}

enum VibrationPattern: String, CaseIterable, Identifiable {
    case heartbeat
    case sos
    case continuous
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .heartbeat: return "Heartbeat"
        case .sos: return "SOS"
        case .continuous: return "Continuous"
        }
    }
    
    var description: String {
        switch self {
        case .heartbeat: return "Gentle repeating vibration"
        case .sos: return "Short, attention-grabbing pulses"
        case .continuous: return "Strong vibration until dismissed"
        }
    }
    
    var icon: String {
        switch self {
        case .heartbeat: return "heart.fill"
        case .sos: return "sos"
        case .continuous: return "iphone.radiowaves.left.and.right"
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AlertPreferencesView()
    }
}
