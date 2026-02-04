//
//  CryingDetectionService.swift
//  CribAlert
//
//  On-device crying detection using audio analysis.
//  Audio is analyzed in real-time and never recorded.
//
//  Uses custom BabyCryingClassifier.mlmodel if available,
//  otherwise falls back to audio level + pattern analysis.
//

import Foundation
import AVFoundation
import Accelerate
import CoreML
import SoundAnalysis

// MARK: - Crying Detection Service

class CryingDetectionService: NSObject, ObservableObject {
    
    // MARK: - Published State
    
    @Published var isRunning: Bool = false
    @Published var latestResult: CryingDetectionResult?
    @Published var currentAudioLevel: Float = 0
    @Published var usingCustomModel: Bool = false
    
    // MARK: - Audio Components
    
    private var audioEngine: AVAudioEngine?
    private var inputNode: AVAudioInputNode?
    
    // MARK: - Sound Analysis (for custom model)
    
    private var soundAnalyzer: SNAudioStreamAnalyzer?
    private var customModelRequest: SNClassifySoundRequest?
    private let analysisQueue = DispatchQueue(label: "com.cribalert.soundanalysis")
    
    // MARK: - Detection State
    
    /// Threshold for considering audio as potential crying (fallback mode)
    private let volumeThreshold: Float = 0.3
    
    /// Duration in seconds of sustained high audio before alerting
    private let sustainedDuration: TimeInterval = 3.0
    
    private var highAudioStartTime: Date?
    private var recentAudioLevels: [Float] = []
    
    // MARK: - Lifecycle
    
    /// Flag to prevent multiple start operations
    private var isStarting: Bool = false
    
    func start() {
        guard !isRunning, !isStarting else { return }
        isStarting = true
        
        // Check for custom model
        Task { @MainActor [weak self] in
            guard let self = self, self.isStarting else { return }
            
            let modelManager = MLModelManager.shared
            
            if modelManager.cryingModelAvailable, let model = modelManager.cryingModel {
                self.setupWithCustomModel(model)
                self.usingCustomModel = true
                print("🎤 CryingDetectionService: Using custom BabyCryingClassifier model")
            } else {
                self.setupWithFallback()
                self.usingCustomModel = false
                print("🎤 CryingDetectionService: Using audio analysis fallback")
            }
            
            self.isStarting = false
        }
    }
    
    func stop() {
        isStarting = false
        
        // Remove audio tap before stopping engine
        inputNode?.removeTap(onBus: 0)
        
        audioEngine?.stop()
        audioEngine = nil
        inputNode = nil
        soundAnalyzer = nil
        customModelRequest = nil
        isRunning = false
        highAudioStartTime = nil
        recentAudioLevels = []
    }
    
    // MARK: - Setup with Custom Model
    
    private func setupWithCustomModel(_ model: MLModel) {
        do {
            // Create sound classification request
            customModelRequest = try SNClassifySoundRequest(mlModel: model)
            
            // Setup audio engine
            audioEngine = AVAudioEngine()
            inputNode = audioEngine?.inputNode
            
            guard let inputNode = inputNode else { return }
            
            let format = inputNode.outputFormat(forBus: 0)
            
            // Create sound analyzer
            soundAnalyzer = SNAudioStreamAnalyzer(format: format)
            
            // Add the classification request
            if let request = customModelRequest, let analyzer = soundAnalyzer {
                try analyzer.add(request, withObserver: self)
            }
            
            // Install tap for audio processing
            inputNode.installTap(onBus: 0, bufferSize: 8192, format: format) { [weak self] buffer, time in
                self?.analysisQueue.async {
                    self?.soundAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
                }
                
                // Also calculate audio level for UI
                self?.calculateAudioLevel(buffer)
            }
            
            try audioEngine?.start()
            isRunning = true
            
        } catch {
            print("Failed to setup custom model: \(error)")
            setupWithFallback()
        }
    }
    
    // MARK: - Setup with Fallback
    
    private func setupWithFallback() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine?.inputNode
        
        guard let inputNode = inputNode else { return }
        
        let format = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.processAudioBufferFallback(buffer)
        }
        
        do {
            try audioEngine?.start()
            isRunning = true
        } catch {
            print("Failed to start audio engine: \(error)")
            isRunning = false
        }
    }
    
    // MARK: - Audio Level Calculation
    
    private func calculateAudioLevel(_ buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        
        let frameCount = Int(buffer.frameLength)
        
        var rms: Float = 0
        vDSP_rmsqv(channelData, 1, &rms, vDSP_Length(frameCount))
        
        let normalizedLevel = min(1.0, rms * 10)
        
        DispatchQueue.main.async { [weak self] in
            self?.currentAudioLevel = normalizedLevel
        }
    }
    
    // MARK: - Fallback Audio Processing
    
    private func processAudioBufferFallback(_ buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        
        let frameCount = Int(buffer.frameLength)
        
        // Calculate RMS for audio level
        var rms: Float = 0
        vDSP_rmsqv(channelData, 1, &rms, vDSP_Length(frameCount))
        
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
        analyzeCryingPatternFallback(currentLevel: normalizedLevel)
    }
    
    private func analyzeCryingPatternFallback(currentLevel: Float) {
        if currentLevel > volumeThreshold {
            if highAudioStartTime == nil {
                highAudioStartTime = Date()
            }
            
            let duration = Date().timeIntervalSince(highAudioStartTime ?? Date())
            
            if duration > sustainedDuration {
                let isCrying = classifyAsCryingFallback()
                
                let result = CryingDetectionResult(
                    isCrying: isCrying,
                    confidence: isCrying ? 0.70 : 0.30, // Lower confidence for fallback
                    audioLevel: currentLevel,
                    usingCustomModel: false
                )
                
                DispatchQueue.main.async { [weak self] in
                    self?.latestResult = result
                }
            }
        } else {
            if let startTime = highAudioStartTime {
                let duration = Date().timeIntervalSince(startTime)
                if duration < 1.0 {
                    highAudioStartTime = nil
                }
            }
            
            if currentLevel < 0.1 {
                highAudioStartTime = nil
                let result = CryingDetectionResult(
                    isCrying: false,
                    confidence: 0.9,
                    audioLevel: currentLevel,
                    usingCustomModel: false
                )
                DispatchQueue.main.async { [weak self] in
                    self?.latestResult = result
                }
            }
        }
    }
    
    private func classifyAsCryingFallback() -> Bool {
        guard recentAudioLevels.count > 20 else { return false }
        
        let recentLevels = Array(recentAudioLevels.suffix(20))
        
        let mean = recentLevels.reduce(0, +) / Float(recentLevels.count)
        let variance = recentLevels.map { pow($0 - mean, 2) }.reduce(0, +) / Float(recentLevels.count)
        
        // Crying typically has moderate variance
        let hasVariance = variance > 0.01 && variance < 0.1
        let highAverage = mean > volumeThreshold
        
        return hasVariance && highAverage
    }
}

// MARK: - SNResultsObserving (Custom Model)

extension CryingDetectionService: SNResultsObserving {
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let classificationResult = result as? SNClassificationResult else { return }
        
        // Get the top classification
        guard let topClassification = classificationResult.classifications.first else { return }
        
        let identifier = topClassification.identifier.lowercased()
        let confidence = Float(topClassification.confidence)
        
        // Check if classified as crying
        let isCrying = identifier.contains("cry") && confidence > 0.6
        
        let detectionResult = CryingDetectionResult(
            isCrying: isCrying,
            confidence: confidence,
            audioLevel: currentAudioLevel,
            usingCustomModel: true
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.latestResult = detectionResult
        }
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("Sound classification failed: \(error)")
    }
    
    func requestDidComplete(_ request: SNRequest) {
        // Classification completed
    }
}

// MARK: - Detection Result

struct CryingDetectionResult {
    let isCrying: Bool
    let confidence: Float
    let audioLevel: Float
    let usingCustomModel: Bool
    
    /// Human-readable description for debugging
    var description: String {
        let modelType = usingCustomModel ? "Custom Model" : "Fallback"
        return "Crying: \(isCrying), Confidence: \(Int(confidence * 100))%, Level: \(Int(audioLevel * 100))% [\(modelType)]"
    }
}
