//
//  MonitoringService.swift
//  CribAlert
//
//  Main monitoring service that coordinates camera, detection, and alerts.
//  All analysis runs on-device - no video/audio is uploaded.
//
//  ML Model Support:
//  - Automatically loads custom .mlmodel files if present
//  - Falls back to Vision/Audio analysis if no custom models
//  - See MLModelManager.swift for supported model specifications
//

import Foundation
import AVFoundation
import Combine

// MARK: - Monitoring Service

@MainActor
class MonitoringService: ObservableObject {
    
    // MARK: - Published State
    
    @Published var isMonitoring: Bool = false
    @Published var monitoringState: MonitoringState = .idle
    @Published var currentPosition: PositionStatus = .onBack
    @Published var currentMovement: MovementStatus = .still
    @Published var lastAlertType: AlertType?
    
    /// Indicates if custom ML models are being used
    @Published var usingCustomModels: Bool = false
    
    // MARK: - Dependencies
    
    private let cameraService: CameraService
    private let positionDetector: PositionDetectionService
    private let movementDetector: MovementDetectionService
    private let cryingDetector: CryingDetectionService
    private let modelManager = MLModelManager.shared
    
    // MARK: - Private State
    
    private var cancellables = Set<AnyCancellable>()
    private var monitoringTimer: Timer?
    
    // MARK: - Initialization
    
    init(
        cameraService: CameraService = CameraService(),
        positionDetector: PositionDetectionService = PositionDetectionService(),
        movementDetector: MovementDetectionService = MovementDetectionService(),
        cryingDetector: CryingDetectionService = CryingDetectionService()
    ) {
        self.cameraService = cameraService
        self.positionDetector = positionDetector
        self.movementDetector = movementDetector
        self.cryingDetector = cryingDetector
    }
    
    // MARK: - Monitoring Control
    
    func startMonitoring() async throws {
        guard !isMonitoring else { return }
        
        // Request camera permission
        let cameraGranted = await cameraService.requestCameraPermission()
        guard cameraGranted else {
            monitoringState = .permissionDenied
            return
        }
        
        // Request microphone permission for crying detection
        let micGranted = await cameraService.requestMicrophonePermission()
        // Microphone is optional - continue without it
        
        // Start camera capture
        do {
            try await cameraService.startCapture()
        } catch {
            monitoringState = .cameraUnavailable
            return
        }
        
        // Start detection services
        positionDetector.start()
        movementDetector.start()
        if micGranted {
            cryingDetector.start()
        }
        
        isMonitoring = true
        monitoringState = .active
        
        // Update custom model status
        updateCustomModelStatus()
        
        // Start periodic analysis
        startAnalysisLoop()
    }
    
    func stopMonitoring() {
        guard isMonitoring else { return }
        
        monitoringTimer?.invalidate()
        monitoringTimer = nil
        
        cameraService.stopCapture()
        positionDetector.stop()
        movementDetector.stop()
        cryingDetector.stop()
        
        isMonitoring = false
        monitoringState = .idle
    }
    
    func pauseMonitoring(reason: PausedReason) {
        monitoringState = .paused(reason)
    }
    
    func resumeMonitoring() async throws {
        if case .paused = monitoringState {
            try await startMonitoring()
        }
    }
    
    // MARK: - Analysis Loop
    
    private func startAnalysisLoop() {
        // Analyze every 500ms for performance
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.analyzeCurrentFrame()
            }
        }
    }
    
    private func analyzeCurrentFrame() {
        guard isMonitoring, monitoringState == .active else { return }
        
        // Get current camera frame
        guard let frame = cameraService.currentFrame else { return }
        
        // Run position detection
        let positionResult = positionDetector.detectPosition(in: frame)
        currentPosition = positionResult.position
        
        // Check for position alerts
        if positionResult.position == .onStomach && positionResult.confidence > 0.8 {
            triggerAlert(.rolledOntoStomach)
        }
        
        // Run movement detection
        let movementResult = movementDetector.detectMovement(in: frame)
        currentMovement = movementResult.status
        
        // Check for unusual stillness
        if movementResult.status == .unusual && movementResult.duration > 30 {
            triggerAlert(.unusualStillness)
        }
        
        // Face coverage detection (part of position detection)
        if positionResult.faceMayCovered {
            triggerAlert(.faceMayCovered)
        }
        
        // Crying detection runs separately on audio
        if let cryingResult = cryingDetector.latestResult, cryingResult.isCrying {
            triggerAlert(.cryingDetected)
        }
    }
    
    // MARK: - Alert Management
    
    private func triggerAlert(_ alertType: AlertType) {
        // Debounce: don't trigger same alert within 30 seconds
        if lastAlertType == alertType { return }
        
        lastAlertType = alertType
        
        // Send notification
        NotificationCenter.default.post(
            name: .safetyAlertTriggered,
            object: nil,
            userInfo: ["alertType": alertType]
        )
        
        // Clear alert after 30 seconds to allow re-triggering
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak self] in
            if self?.lastAlertType == alertType {
                self?.lastAlertType = nil
            }
        }
    }
    
    func dismissAlert() {
        lastAlertType = nil
    }
    
    // MARK: - Model Status
    
    private func updateCustomModelStatus() {
        // Check if any custom models are loaded
        usingCustomModels = modelManager.positionModelAvailable || 
                           modelManager.cryingModelAvailable ||
                           modelManager.faceCoverageModelAvailable
        
        if usingCustomModels {
            print("🤖 MonitoringService: Using custom ML models for enhanced detection")
        } else {
            print("🤖 MonitoringService: Using built-in Vision/Audio frameworks")
        }
    }
    
    /// Returns the current detection capabilities
    var detectionCapabilities: DetectionCapabilities {
        DetectionCapabilities(
            positionDetection: modelManager.positionModelAvailable ? .customModel : .visionFramework,
            cryingDetection: modelManager.cryingModelAvailable ? .customModel : .audioAnalysis,
            faceCoverageDetection: modelManager.faceCoverageModelAvailable ? .customModel : .visionFramework
        )
    }
}

// MARK: - Detection Capabilities

struct DetectionCapabilities {
    let positionDetection: DetectionMethod
    let cryingDetection: DetectionMethod
    let faceCoverageDetection: DetectionMethod
    
    enum DetectionMethod: String {
        case customModel = "Custom ML Model"
        case visionFramework = "Vision Framework"
        case audioAnalysis = "Audio Analysis"
    }
}

// MARK: - Monitoring State

enum MonitoringState: Equatable {
    case idle
    case active
    case paused(PausedReason)
    case permissionDenied
    case cameraUnavailable
    
    static func == (lhs: MonitoringState, rhs: MonitoringState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.active, .active), 
             (.permissionDenied, .permissionDenied),
             (.cameraUnavailable, .cameraUnavailable):
            return true
        case (.paused(let a), .paused(let b)):
            return a == b
        default:
            return false
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let safetyAlertTriggered = Notification.Name("safetyAlertTriggered")
}
