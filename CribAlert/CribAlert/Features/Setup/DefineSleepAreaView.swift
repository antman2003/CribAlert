//
//  DefineSleepAreaView.swift
//  CribAlert
//
//  Step 3 of 4: Define the sleep area (crib ROI) on camera preview.
//

import SwiftUI

struct DefineSleepAreaView: View {
    
    // MARK: - Properties
    
    let onContinue: () -> Void
    let onBack: () -> Void
    let onSkip: () -> Void
    
    // ROI corner positions (normalized 0-1)
    @State private var topLeft = CGPoint(x: 0.2, y: 0.15)
    @State private var topRight = CGPoint(x: 0.8, y: 0.15)
    @State private var bottomLeft = CGPoint(x: 0.2, y: 0.75)
    @State private var bottomRight = CGPoint(x: 0.8, y: 0.75)
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with navigation
            header
            
            // Progress bar
            progressBar
            
            // Camera preview with ROI overlay
            cameraPreviewWithROI
                .padding(.horizontal, 24)
                .padding(.top, 24)
            
            Spacer()
            
            // Title and description
            VStack(spacing: 12) {
                Text("Define the sleep area")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Drag the corners to fit the edges of the mattress. This helps the monitor ignore movement outside the crib.")
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            
            // Confirm button
            confirmButton
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
            
            Text("Step 3 of 4")
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
                    .frame(width: geometry.size.width * 0.75, height: 6)
            }
        }
        .frame(height: 6)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
    
    // MARK: - Camera Preview with ROI
    
    private var cameraPreviewWithROI: some View {
        GeometryReader { geometry in
            ZStack {
                // Camera preview background
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.18, green: 0.22, blue: 0.28))
                
                // Grid overlay inside ROI
                roiOverlay(in: geometry.size)
                
                // LIVE indicator
                VStack {
                    HStack {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                            Text("LIVE VIEW")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(6)
                        
                        Spacer()
                    }
                    .padding(16)
                    
                    Spacer()
                }
            }
        }
        .aspectRatio(4/5, contentMode: .fit)
    }
    
    // MARK: - ROI Overlay
    
    private func roiOverlay(in size: CGSize) -> some View {
        let tl = CGPoint(x: topLeft.x * size.width, y: topLeft.y * size.height)
        let tr = CGPoint(x: topRight.x * size.width, y: topRight.y * size.height)
        let bl = CGPoint(x: bottomLeft.x * size.width, y: bottomLeft.y * size.height)
        let br = CGPoint(x: bottomRight.x * size.width, y: bottomRight.y * size.height)
        
        return ZStack {
            // Semi-transparent green overlay for ROI
            Path { path in
                path.move(to: tl)
                path.addLine(to: tr)
                path.addLine(to: br)
                path.addLine(to: bl)
                path.closeSubpath()
            }
            .fill(Color.primaryGreen.opacity(0.2))
            
            // Border
            Path { path in
                path.move(to: tl)
                path.addLine(to: tr)
                path.addLine(to: br)
                path.addLine(to: bl)
                path.closeSubpath()
            }
            .stroke(Color.primaryGreen, lineWidth: 2)
            
            // Grid lines
            gridLines(tl: tl, tr: tr, bl: bl, br: br)
            
            // Corner handles
            cornerHandle(at: tl)
            cornerHandle(at: tr)
            cornerHandle(at: bl)
            cornerHandle(at: br)
        }
    }
    
    private func gridLines(tl: CGPoint, tr: CGPoint, bl: CGPoint, br: CGPoint) -> some View {
        Path { path in
            // Horizontal lines (3 lines dividing into 4 sections)
            for i in 1...3 {
                let t = CGFloat(i) / 4.0
                let leftPoint = CGPoint(
                    x: tl.x + (bl.x - tl.x) * t,
                    y: tl.y + (bl.y - tl.y) * t
                )
                let rightPoint = CGPoint(
                    x: tr.x + (br.x - tr.x) * t,
                    y: tr.y + (br.y - tr.y) * t
                )
                path.move(to: leftPoint)
                path.addLine(to: rightPoint)
            }
            
            // Vertical lines (3 lines dividing into 4 sections)
            for i in 1...3 {
                let t = CGFloat(i) / 4.0
                let topPoint = CGPoint(
                    x: tl.x + (tr.x - tl.x) * t,
                    y: tl.y + (tr.y - tl.y) * t
                )
                let bottomPoint = CGPoint(
                    x: bl.x + (br.x - bl.x) * t,
                    y: bl.y + (br.y - bl.y) * t
                )
                path.move(to: topPoint)
                path.addLine(to: bottomPoint)
            }
        }
        .stroke(Color.primaryGreen.opacity(0.4), lineWidth: 1)
    }
    
    private func cornerHandle(at point: CGPoint) -> some View {
        Circle()
            .fill(Color.white)
            .frame(width: 24, height: 24)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            .position(point)
    }
    
    // MARK: - Confirm Button
    
    private var confirmButton: some View {
        Button(action: onContinue) {
            HStack(spacing: 8) {
                Text("Confirm Area")
                    .font(.system(size: 17, weight: .semibold))
                Image(systemName: "checkmark")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.textPrimary)
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
    DefineSleepAreaView(
        onContinue: { print("Continue") },
        onBack: { print("Back") },
        onSkip: { print("Skip") }
    )
}
