//
//  CryingDetectionService.swift
//  CribAlert
//
//  On-device crying detection using audio analysis.
//  Audio is analyzed in real-time and never recorded.
//

import Foundation
import AVFoundation
import Accelerate

// MARK: - Crying Detection Service

class CryingDetectionService: ObservableObject {
    
    // MARK: - Published State
    
    @Published var isRunning: Bool = false
    @Published var latestResult: CryingDetectionResult?
    @Published var currentAudioLevel: Float = 0
    
    // MARK: - Audio Components
    
    private var audioEngine: AVAudioEngine?
    private var inputNode: AVAudioInputNode?
    
    // MARK: - Detection State
    
    /// Threshold for considering audio as potential crying
    private let volumeThreshold: Float = 0.3
    
    /// Duration in seconds of sustained high audio before alerting
    private let sustainedDuration: TimeInterval = 3.0
    
    private var highAudioStartTime: Date?
    private var recentAudioLevels: [Float] = []
    
    // MARK: - Lifecycle
    
    func start() {
        guard !isRunning else { return }
        
        setupAudioEngine()
        
        do {
            try audioEngine?.start()
            isRunning = true
        } catch {
            print("Failed to start audio engine: \(error)")
            isRunning = false
        }
    }
    
    func stop() {
        audioEngine?.stop()
        audioEngine = nil
        inputNode = nil
        isRunning = false
        highAudioStartTime = nil
        recentAudioLevels = []
    }
    
    // MARK: - Audio Setup
    
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine?.inputNode
        
        guard let inputNode = inputNode else { return }
        
        let format = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.processAudioBuffer(buffer)
        }
    }
    
    // MARK: - Audio Processing
    
    private func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        
        let frameCount = Int(buffer.frameLength)
        
        // Calculate RMS (Root Mean Square) for audio level
        var rms: Float = 0
        vDSP_rmsqv(channelData, 1, &rms, vDSP_Length(frameCount))
        
        // Normalize to 0-1 range
        let normalizedLevel = min(1.0, rms * 10)
        
        DispatchQueue.main.async { [weak self] in
            self?.currentAudioLevel = normalizedLevel
        }
        
        // Update history
        recentAudioLevels.append(normalizedLevel)
        if recentAudioLevels.count > 50 {
            recentAudioLevels.removeFirst()
        }
        
        // Analyze for crying pattern
        analyzeCryingPattern(currentLevel: normalizedLevel)
    }
    
    private func analyzeCryingPattern(currentLevel: Float) {
        // Check if audio level is above threshold
        if currentLevel > volumeThreshold {
            if highAudioStartTime == nil {
                highAudioStartTime = Date()
            }
            
            // Check if sustained high audio
            let duration = Date().timeIntervalSince(highAudioStartTime ?? Date())
            
            if duration > sustainedDuration {
                // Analyze frequency pattern (simplified)
                // Real implementation would use ML model for crying classification
                let isCrying = classifyAsCrying()
                
                let result = CryingDetectionResult(
                    isCrying: isCrying,
                    confidence: isCrying ? 0.85 : 0.3,
                    audioLevel: currentLevel
                )
                
                DispatchQueue.main.async { [weak self] in
                    self?.latestResult = result
                }
            }
        } else {
            // Audio dropped below threshold
            if let startTime = highAudioStartTime {
                let duration = Date().timeIntervalSince(startTime)
                if duration < 1.0 {
                    // Short burst - reset
                    highAudioStartTime = nil
                }
            }
            
            // If quiet for a while, clear crying state
            if currentLevel < 0.1 {
                highAudioStartTime = nil
                let result = CryingDetectionResult(isCrying: false, confidence: 0.9, audioLevel: currentLevel)
                DispatchQueue.main.async { [weak self] in
                    self?.latestResult = result
                }
            }
        }
    }
    
    private func classifyAsCrying() -> Bool {
        // Simplified crying classification
        // Real implementation would:
        // 1. Extract audio features (MFCCs, spectral features)
        // 2. Use trained Core ML model for classification
        // 3. Distinguish crying from other sounds (TV, music, talking)
        
        // For now, use simple heuristics:
        // - Sustained high volume
        // - Variable amplitude (crying has characteristic rhythm)
        
        guard recentAudioLevels.count > 20 else { return false }
        
        let recentLevels = Array(recentAudioLevels.suffix(20))
        
        // Calculate variance
        let mean = recentLevels.reduce(0, +) / Float(recentLevels.count)
        let variance = recentLevels.map { pow($0 - mean, 2) }.reduce(0, +) / Float(recentLevels.count)
        
        // Crying typically has moderate variance (not constant like white noise)
        let hasVariance = variance > 0.01 && variance < 0.1
        
        // Check average level is high
        let highAverage = mean > volumeThreshold
        
        return hasVariance && highAverage
    }
}

// MARK: - Detection Result

struct CryingDetectionResult {
    let isCrying: Bool
    let confidence: Float
    let audioLevel: Float
}
