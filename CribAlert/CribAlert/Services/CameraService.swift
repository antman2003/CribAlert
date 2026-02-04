//
//  CameraService.swift
//  CribAlert
//
//  Camera capture service using AVFoundation.
//  Captures video frames for on-device analysis.
//  No video is recorded or uploaded.
//

import Foundation
import AVFoundation
import CoreImage

// MARK: - Camera Service

class CameraService: NSObject, ObservableObject {
    
    // MARK: - Published State
    
    @Published var isCapturing: Bool = false
    @Published var hasPermission: Bool = false
    @Published var currentFrame: CIImage?
    
    // MARK: - AVFoundation Components
    
    private let captureSession = AVCaptureSession()
    private var videoOutput: AVCaptureVideoDataOutput?
    private let sessionQueue = DispatchQueue(label: "com.cribalert.camera")
    
    // MARK: - Configuration
    
    /// Target frame rate for analysis (lower for battery savings)
    private let targetFrameRate: Int = 5
    
    // MARK: - Permission Requests
    
    func requestCameraPermission() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            hasPermission = true
            return true
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            await MainActor.run { hasPermission = granted }
            return granted
        case .denied, .restricted:
            hasPermission = false
            return false
        @unknown default:
            return false
        }
    }
    
    func requestMicrophonePermission() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .audio)
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }
    
    // MARK: - Capture Control
    
    func startCapture() async throws {
        guard hasPermission else {
            throw CameraError.permissionDenied
        }
        
        try await setupCaptureSession()
        
        sessionQueue.async { [weak self] in
            self?.captureSession.startRunning()
            DispatchQueue.main.async {
                self?.isCapturing = true
            }
        }
    }
    
    func stopCapture() {
        sessionQueue.async { [weak self] in
            self?.captureSession.stopRunning()
            DispatchQueue.main.async {
                self?.isCapturing = false
                self?.currentFrame = nil
            }
        }
    }
    
    // MARK: - Session Setup
    
    private func setupCaptureSession() async throws {
        captureSession.beginConfiguration()
        
        // Use lower resolution for analysis (saves battery)
        captureSession.sessionPreset = .medium
        
        // Setup camera input
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            captureSession.commitConfiguration()
            throw CameraError.cameraUnavailable
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            // Configure frame rate
            try camera.lockForConfiguration()
            camera.activeVideoMinFrameDuration = CMTime(value: 1, timescale: CMTimeScale(targetFrameRate))
            camera.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: CMTimeScale(targetFrameRate))
            camera.unlockForConfiguration()
            
        } catch {
            captureSession.commitConfiguration()
            throw CameraError.setupFailed(error)
        }
        
        // Setup video output
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: sessionQueue)
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
            videoOutput = output
        }
        
        captureSession.commitConfiguration()
    }
    
    // MARK: - Preview Layer
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer {
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.videoGravity = .resizeAspectFill
        return layer
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        DispatchQueue.main.async { [weak self] in
            self?.currentFrame = ciImage
        }
    }
}

// MARK: - Camera Errors

enum CameraError: Error {
    case permissionDenied
    case cameraUnavailable
    case setupFailed(Error)
    
    var localizedDescription: String {
        switch self {
        case .permissionDenied:
            return "Camera permission was denied. Please enable camera access in Settings."
        case .cameraUnavailable:
            return "Camera is not available on this device."
        case .setupFailed(let error):
            return "Failed to setup camera: \(error.localizedDescription)"
        }
    }
}
