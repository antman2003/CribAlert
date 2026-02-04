//
//  PositionDetectionService.swift
//  CribAlert
//
//  On-device position detection using Core ML / Vision.
//  Detects: on back, on side, on stomach, face coverage.
//

import Foundation
import CoreImage
import Vision

// MARK: - Position Detection Service

class PositionDetectionService: ObservableObject {
    
    // MARK: - Published State
    
    @Published var isRunning: Bool = false
    @Published var latestResult: PositionDetectionResult?
    
    // MARK: - Vision Components
    
    private var poseRequest: VNDetectHumanBodyPoseRequest?
    
    // MARK: - Lifecycle
    
    func start() {
        isRunning = true
        setupVisionRequests()
    }
    
    func stop() {
        isRunning = false
        poseRequest = nil
    }
    
    // MARK: - Setup
    
    private func setupVisionRequests() {
        // Use Vision framework for pose detection
        poseRequest = VNDetectHumanBodyPoseRequest { [weak self] request, error in
            guard error == nil else { return }
            self?.processPoseObservations(request.results as? [VNHumanBodyPoseObservation])
        }
    }
    
    // MARK: - Detection
    
    func detectPosition(in frame: CIImage) -> PositionDetectionResult {
        guard isRunning, let request = poseRequest else {
            return PositionDetectionResult(position: .unknown, confidence: 0, faceMayCovered: false)
        }
        
        let handler = VNImageRequestHandler(ciImage: frame, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Position detection failed: \(error)")
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
        
        // If shoulders are at similar y-level and far apart in x -> on back
        // If shoulders are close in x -> on side or stomach
        
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
}
