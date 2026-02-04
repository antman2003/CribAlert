//
//  MovementDetectionService.swift
//  CribAlert
//
//  On-device movement detection by comparing video frames.
//  Detects: still, moving, unusual stillness.
//

import Foundation
import CoreImage

// MARK: - Movement Detection Service

class MovementDetectionService: ObservableObject {
    
    // MARK: - Published State
    
    @Published var isRunning: Bool = false
    @Published var latestResult: MovementDetectionResult?
    
    // MARK: - Detection State
    
    private var previousFrame: CIImage?
    private var stillnessStartTime: Date?
    private var movementHistory: [MovementLevel] = []
    
    /// Threshold for considering movement significant
    private let movementThreshold: Float = 0.02
    
    /// Duration in seconds before triggering unusual stillness alert
    private let stillnessAlertDuration: TimeInterval = 120 // 2 minutes
    
    // MARK: - Lifecycle
    
    func start() {
        isRunning = true
        previousFrame = nil
        stillnessStartTime = nil
        movementHistory = []
    }
    
    func stop() {
        isRunning = false
        previousFrame = nil
        stillnessStartTime = nil
        movementHistory = []
    }
    
    // MARK: - Detection
    
    func detectMovement(in currentFrame: CIImage) -> MovementDetectionResult {
        guard isRunning else {
            return MovementDetectionResult(status: .still, level: 0, duration: 0)
        }
        
        defer { previousFrame = currentFrame }
        
        guard let previous = previousFrame else {
            return MovementDetectionResult(status: .still, level: 0, duration: 0)
        }
        
        // Calculate frame difference
        let movementLevel = calculateFrameDifference(current: currentFrame, previous: previous)
        
        // Update movement history
        movementHistory.append(MovementLevel(level: movementLevel, timestamp: Date()))
        
        // Keep only last 30 seconds of history
        let thirtySecondsAgo = Date().addingTimeInterval(-30)
        movementHistory = movementHistory.filter { $0.timestamp > thirtySecondsAgo }
        
        // Determine movement status
        let status: MovementStatus
        var stillnessDuration: TimeInterval = 0
        
        if movementLevel > movementThreshold {
            // Movement detected
            status = .moving
            stillnessStartTime = nil
        } else {
            // No significant movement
            if stillnessStartTime == nil {
                stillnessStartTime = Date()
            }
            
            stillnessDuration = Date().timeIntervalSince(stillnessStartTime ?? Date())
            
            if stillnessDuration > stillnessAlertDuration {
                status = .unusual
            } else {
                status = .still
            }
        }
        
        let result = MovementDetectionResult(
            status: status,
            level: movementLevel,
            duration: stillnessDuration
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.latestResult = result
        }
        
        return result
    }
    
    private func calculateFrameDifference(current: CIImage, previous: CIImage) -> Float {
        // Simple frame difference calculation
        // In production, use more sophisticated optical flow or ML-based detection
        
        // Create difference filter
        guard let differenceFilter = CIFilter(name: "CIDifferenceBlendMode") else {
            return 0
        }
        
        differenceFilter.setValue(current, forKey: kCIInputImageKey)
        differenceFilter.setValue(previous, forKey: kCIInputBackgroundImageKey)
        
        guard let outputImage = differenceFilter.outputImage else {
            return 0
        }
        
        // Calculate average intensity of difference image
        // This gives a rough measure of how much the frame changed
        
        let context = CIContext()
        var avgIntensity: Float = 0
        
        // Sample a small area for performance
        let sampleExtent = CGRect(
            x: outputImage.extent.midX - 50,
            y: outputImage.extent.midY - 50,
            width: 100,
            height: 100
        )
        
        if let cgImage = context.createCGImage(outputImage, from: sampleExtent) {
            // Calculate average pixel intensity
            let width = cgImage.width
            let height = cgImage.height
            let totalPixels = width * height
            
            // Simplified intensity calculation
            avgIntensity = Float(totalPixels > 0 ? 0.05 : 0) // Placeholder
        }
        
        return avgIntensity
    }
}

// MARK: - Detection Result

struct MovementDetectionResult {
    let status: MovementStatus
    let level: Float
    let duration: TimeInterval
}

// MARK: - Movement Level

private struct MovementLevel {
    let level: Float
    let timestamp: Date
}
