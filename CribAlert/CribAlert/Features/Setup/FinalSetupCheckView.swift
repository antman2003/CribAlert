//
//  FinalSetupCheckView.swift
//  CribAlert
//
//  Step 4 of 4: Final calibration check before monitoring.
//

import SwiftUI
import Combine

struct FinalSetupCheckView: View {
    
    // MARK: - Properties
    
    let onContinue: () -> Void
    let onBack: () -> Void
    
    @State private var calibrationProgress: Double = 0.0
    @State private var isCalibrationComplete = false
    @State private var statusText = "Setting up..."
    @State private var timerCancellable: AnyCancellable?
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with navigation
            header
            
            // Progress bar (full)
            progressBar
            
            ScrollView {
                VStack(spacing: 24) {
                    // Camera preview with AI overlay
                    cameraPreviewWithAI
                    
                    // Title
                    Text("Final setup check")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    // Calibration progress
                    calibrationProgressView
                    
                    // Status description
                    Text("Checking camera placement and lighting to help reduce false alerts.")
                        .font(.system(size: 15))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 24)
                    
                    // Privacy message
                    privacyMessage
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
            }
            
            Spacer()
            
            // Start Monitoring button
            startMonitoringButton
        }
        .background(Color(red: 0.98, green: 0.99, blue: 0.97))
        .navigationBarHidden(true)
        .onAppear {
            startCalibrationTimer()
        }
        .onDisappear {
            stopCalibrationTimer()
        }
    }
    
    // MARK: - Timer Management
    
    private func startCalibrationTimer() {
        guard timerCancellable == nil else { return }
        
        timerCancellable = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if calibrationProgress < 1.0 {
                    calibrationProgress += 0.01
                    updateStatusText()
                } else {
                    isCalibrationComplete = true
                    stopCalibrationTimer()
                }
            }
    }
    
    private func stopCalibrationTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Text("Step 4 of 4")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            // Empty space for balance
            Image(systemName: "arrow.left")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.clear)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    // MARK: - Progress Bar
    
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 6)
                
                // Progress fill (100%)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primaryGreen)
                    .frame(width: geometry.size.width, height: 6)
            }
        }
        .frame(height: 6)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
    
    // MARK: - Camera Preview with AI
    
    private var cameraPreviewWithAI: some View {
        ZStack {
            // Camera preview background
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.95, green: 0.95, blue: 0.93), Color(red: 0.90, green: 0.92, blue: 0.90)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            
            // Placeholder content
            VStack(spacing: 16) {
                Image(systemName: "iphone.gen3")
                    .font(.system(size: 50))
                    .foregroundColor(.gray.opacity(0.5))
                
                // Detection frame
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.primaryGreen, style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                    .frame(width: 100, height: 80)
            }
            
            // AI ACTIVE badge
            VStack {
                HStack {
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.primaryGreen)
                            .frame(width: 8, height: 8)
                        Text("AI ACTIVE")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.textPrimary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .padding(16)
                
                Spacer()
            }
        }
        .frame(height: 280)
    }
    
    // MARK: - Calibration Progress
    
    private var calibrationProgressView: some View {
        VStack(spacing: 8) {
            HStack {
                Text(statusText)
                    .font(.system(size: 15))
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                Text("\(Int(calibrationProgress * 100))%")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primaryGreen)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.primaryGreen)
                        .frame(width: geometry.size.width * calibrationProgress, height: 8)
                        .animation(.easeInOut(duration: 0.1), value: calibrationProgress)
                }
            }
            .frame(height: 8)
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Privacy Message
    
    private var privacyMessage: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Privacy first.")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Text("No video is ever stored or uploaded. Analysis happens locally on your device.")
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 24)
    }
    
    // MARK: - Start Monitoring Button
    
    private var startMonitoringButton: some View {
        Button(action: onContinue) {
            HStack(spacing: 8) {
                Text("Start Monitoring")
                    .font(.system(size: 17, weight: .semibold))
                Image(systemName: "arrow.right")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isCalibrationComplete ? Color.primaryGreen : Color.primaryGreen.opacity(0.5))
            .cornerRadius(12)
        }
        .disabled(!isCalibrationComplete)
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }
    
    // MARK: - Helpers
    
    private func updateStatusText() {
        if calibrationProgress < 0.3 {
            statusText = "Analyzing lighting..."
        } else if calibrationProgress < 0.6 {
            statusText = "Checking camera angle..."
        } else if calibrationProgress < 0.9 {
            statusText = "Optimizing detection..."
        } else {
            statusText = "Ready!"
        }
    }
}

// MARK: - Preview

#Preview {
    FinalSetupCheckView(
        onContinue: { print("Continue") },
        onBack: { print("Back") }
    )
}
