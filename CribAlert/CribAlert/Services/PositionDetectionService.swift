//
//  PositionDetectionService.swift
//  CribAlert
//
//  On-device position detection using Core ML / Vision.
//  Detects: on back, on side, on stomach, face coverage.
//
//  Uses custom BabyPositionClassifier.mlmodel if available,
//  otherwise falls back to Vision framework body pose detection.
//

import Foundation
import CoreImage
import Vision
import CoreML

// MARK: - Position Detection Service

class PositionDetectionService: ObservableObject {
    
    // MARK: - Published State
    
    @Published var isRunning: Bool = false
    @Published var latestResult: PositionDetectionResult?
    @Published var usingCustomModel: Bool = false
    
    // MARK: - Detection Components
    
    /// Custom Core ML model (if available)
    private var customModel: VNCoreMLModel?
    private var customFaceCoverageModel: VNCoreMLModel?
    
    /// Fallback Vision request
    private var poseRequest: VNDetectHumanBodyPoseRequest?
    
    /// CIContext for image processing
    private let ciContext = CIContext()
    
    // MARK: - Lifecycle
    
    func start() {
        isRunning = true
        
        // Check for custom models from MLModelManager
        Task { @MainActor in
            let modelManager = MLModelManager.shared
            
            if modelManager.positionModelAvailable, let model = modelManager.positionModel {
                customModel = model
                usingCustomModel = true
                print("📱 PositionDetectionService: Using custom BabyPositionClassifier model")
            } else {
                setupVisionFallback()
                usingCustomModel = false
                print("📱 PositionDetectionService: Using Vision framework fallback")
            }
            
            // Also check for face coverage model
            if modelManager.faceCoverageModelAvailable {
                customFaceCoverageModel = modelManager.faceCoverageModel
            }
        }
    }
    
    func stop() {
        isRunning = false
        poseRequest = nil
    }
    
    // MARK: - Setup
    
    private func setupVisionFallback() {
        // Use Vision framework for pose detection as fallback
        poseRequest = VNDetectHumanBodyPoseRequest { [weak self] request, error in
            guard error == nil else { return }
            self?.processPoseObservations(request.results as? [VNHumanBodyPoseObservation])
        }
    }
    
    // MARK: - Detection
    
    func detectPosition(in frame: CIImage) -> PositionDetectionResult {
        guard isRunning else {
            return PositionDetectionResult(position: .unknown, confidence: 0, faceMayCovered: false)
        }
        
        // Use custom model if available
        if let model = customModel {
            return detectWithCustomModel(frame, model: model)
        } else {
            return detectWithVisionFallback(frame)
        }
    }
    
    // MARK: - Custom Model Detection
    
    private func detectWithCustomModel(_ frame: CIImage, model: VNCoreMLModel) -> PositionDetectionResult {
        var position: PositionStatus = .unknown
        var confidence: Float = 0
        var faceMayCovered = false
        
        // Create request for position classification
        let request = VNCoreMLRequest(model: model) { request, error in
            guard error == nil,
                  let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                return
            }
            
            // Map model output to PositionStatus
            position = self.mapClassificationToPosition(topResult.identifier)
            confidence = topResult.confidence
        }
        
        // Configure request
        request.imageCropAndScaleOption = .centerCrop
        
        // Perform detection
        let handler = VNImageRequestHandler(ciImage: frame, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Custom model detection failed: \(error)")
            return detectWithVisionFallback(frame)
        }
        
        // Check face coverage with custom model if available
        if let faceCoverageModel = customFaceCoverageModel {
            faceMayCovered = detectFaceCoverageWithModel(frame, model: faceCoverageModel)
        }
        
        let result = PositionDetectionResult(
            position: position,
            confidence: confidence,
            faceMayCovered: faceMayCovered
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.latestResult = result
        }
        
        return result
    }
    
    private func mapClassificationToPosition(_ classification: String) -> PositionStatus {
        switch classification.lowercased() {
        case "on_back", "onback", "back":
            return .onBack
        case "on_side", "onside", "side":
            return .onSide
        case "on_stomach", "onstomach", "stomach", "prone":
            return .onStomach
        default:
            return .unknown
        }
    }
    
    private func detectFaceCoverageWithModel(_ frame: CIImage, model: VNCoreMLModel) -> Bool {
        var isCovered = false
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard error == nil,
                  let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                return
            }
            
            // Check if classified as covered
            let classification = topResult.identifier.lowercased()
            isCovered = classification.contains("covered") && topResult.confidence > 0.7
        }
        
        request.imageCropAndScaleOption = .centerCrop
        
        let handler = VNImageRequestHandler(ciImage: frame, options: [:])
        try? handler.perform([request])
        
        return isCovered
    }
    
    // MARK: - Vision Fallback Detection
    
    private func detectWithVisionFallback(_ frame: CIImage) -> PositionDetectionResult {
        guard let request = poseRequest else {
            return PositionDetectionResult(position: .unknown, confidence: 0, faceMayCovered: false)
        }
        
        let handler = VNImageRequestHandler(ciImage: frame, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Vision fallback detection failed: \(error)")
        }
        
        return latestResult ?? PositionDetectionResult(position: .unknown, confidence: 0, faceMayCovered: false)
    }
    
    private func processPoseObservations(_ observations: [VNHumanBodyPoseObservation]?) {
        guard let observations = observations, !observations.isEmpty else {
            latestResult = PositionDetectionResult(position: .unknown, confidence: 0, faceMayCovered: false)
            return
        }
        
        // Analyze the first detected pose
        let observation = observations[0]
        
        // Determine position based on body pose landmarks
        let result = analyzeBodyPose(observation)
        
        DispatchQueue.main.async { [weak self] in
            self?.latestResult = result
        }
    }
    
    private func analyzeBodyPose(_ observation: VNHumanBodyPoseObservation) -> PositionDetectionResult {
        // Get key body points
        guard let nose = try? observation.recognizedPoint(.nose),
              let leftShoulder = try? observation.recognizedPoint(.leftShoulder),
              let rightShoulder = try? observation.recognizedPoint(.rightShoulder) else {
            return PositionDetectionResult(position: .unknown, confidence: 0.3, faceMayCovered: false)
        }
        
        // Check confidence
        let minConfidence: Float = 0.3
        guard nose.confidence > minConfidence,
              leftShoulder.confidence > minConfidence,
              rightShoulder.confidence > minConfidence else {
            return PositionDetectionResult(position: .unknown, confidence: 0.3, faceMayCovered: false)
        }
        
        // Analyze shoulder orientation to determine position
        let shoulderDiff = abs(leftShoulder.y - rightShoulder.y)
        let shoulderDistance = abs(leftShoulder.x - rightShoulder.x)
        
        let position: PositionStatus
        let confidence: Float
        
        if shoulderDistance > 0.15 && shoulderDiff < 0.1 {
            // Shoulders spread out horizontally -> likely on back
            position = .onBack
            confidence = 0.85
        } else if shoulderDistance < 0.08 {
            // Shoulders close together -> on side
            position = .onSide
            confidence = 0.75
        } else if nose.y > max(leftShoulder.y, rightShoulder.y) {
            // Nose below shoulders in image (top-down view) -> on stomach
            position = .onStomach
            confidence = 0.80
        } else {
            position = .onBack
            confidence = 0.60
        }
        
        // Check if face may be covered (nose not visible or low confidence)
        let faceMayCovered = nose.confidence < 0.4
        
        return PositionDetectionResult(
            position: position,
            confidence: confidence,
            faceMayCovered: faceMayCovered
        )
    }
}

// MARK: - Detection Result

struct PositionDetectionResult {
    let position: PositionStatus
    let confidence: Float
    let faceMayCovered: Bool
    
    /// Human-readable description for debugging
    var description: String {
        "Position: \(position.displayValue), Confidence: \(Int(confidence * 100))%, Face Covered: \(faceMayCovered)"
    }
}
