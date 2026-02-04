//
//  CameraPlacementView.swift
//  CribAlert
//
//  Step 2 of 4: Instructions for mounting camera device.
//

import SwiftUI

struct CameraPlacementView: View {
    
    // MARK: - Properties
    
    let onContinue: () -> Void
    let onBack: () -> Void
    let onSkip: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with navigation
            header
            
            // Progress bar
            progressBar
            
            ScrollView {
                VStack(spacing: 24) {
                    // Illustration
                    mountIllustration
                    
                    // Title and description
                    VStack(spacing: 16) {
                        Text("Mount your device")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Text("For best results, place your camera 3-4 feet directly above the crib with a clear, top-down view.")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal, 24)
                    
                    // Help link
                    Button(action: {
                        // Show mount help
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 14))
                            Text("Don't have a mount?")
                                .font(.system(size: 15))
                        }
                        .foregroundColor(.primaryGreen)
                    }
                }
                .padding(.top, 24)
            }
            
            Spacer()
            
            // Next button
            nextButton
        }
        .background(Color(red: 0.98, green: 0.99, blue: 0.97))
        .navigationBarHidden(true)
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
            
            Text("Step 2 of 4")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Button(action: onSkip) {
                Text("Skip")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
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
                
                // Progress fill
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primaryGreen)
                    .frame(width: geometry.size.width * 0.5, height: 6)
            }
        }
        .frame(height: 6)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
    
    // MARK: - Mount Illustration
    
    private var mountIllustration: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
            
            // Placeholder illustration
            VStack(spacing: 16) {
                Image(systemName: "iphone")
                    .font(.system(size: 60))
                    .foregroundColor(.gray.opacity(0.4))
                
                Image(systemName: "arrow.down")
                    .font(.system(size: 24))
                    .foregroundColor(.primaryGreen)
                
                // Crib representation
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    .frame(width: 100, height: 60)
                    .overlay(
                        Text("Crib")
                            .font(.caption)
                            .foregroundColor(.gray)
                    )
            }
            .padding(.vertical, 40)
        }
        .frame(height: 320)
        .padding(.horizontal, 24)
    }
    
    // MARK: - Next Button
    
    private var nextButton: some View {
        Button(action: onContinue) {
            HStack(spacing: 8) {
                Text("Next")
                    .font(.system(size: 17, weight: .semibold))
                Image(systemName: "arrow.right")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.primaryGreen)
            .cornerRadius(12)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }
}

// MARK: - Preview

#Preview {
    CameraPlacementView(
        onContinue: { print("Continue") },
        onBack: { print("Back") },
        onSkip: { print("Skip") }
    )
}
