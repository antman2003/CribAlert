//
//  MLModelManager.swift
//  CribAlert
//
//  Manages Core ML model loading and provides fallback to Vision framework.
//  Drop .mlmodel files into the project to enable custom detection.
//
//  Supported models:
//  - BabyPositionClassifier.mlmodel (Image classifier: on_back, on_side, on_stomach)
//  - BabyCryingClassifier.mlmodel (Sound classifier: crying, not_crying)
//  - FaceCoverageDetector.mlmodel (Image classifier: clear, covered)
//

import Foundation
import CoreML
import Vision

// MARK: - ML Model Manager

@MainActor
class MLModelManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = MLModelManager()
    
    // MARK: - Published State
    
    @Published var positionModelAvailable: Bool = false
    @Published var cryingModelAvailable: Bool = false
    @Published var faceCoverageModelAvailable: Bool = false
    
    // MARK: - Loaded Models
    
    private(set) var positionModel: VNCoreMLModel?
    private(set) var cryingModel: MLModel?
    private(set) var faceCoverageModel: VNCoreMLModel?
    
    // MARK: - Initialization
    
    private init() {
        loadAvailableModels()
    }
    
    // MARK: - Model Loading
    
    func loadAvailableModels() {
        // Try to load each custom model
        loadPositionModel()
        loadCryingModel()
        loadFaceCoverageModel()
        
        printModelStatus()
    }
    
    private func loadPositionModel() {
        // Try to load BabyPositionClassifier.mlmodel
        // When you add this model to Xcode, it auto-generates a class
        
        // Method 1: Try to load from bundle by class name
        if let modelURL = Bundle.main.url(forResource: "BabyPositionClassifier", withExtension: "mlmodelc") {
            do {
                let config = MLModelConfiguration()
                config.computeUnits = .cpuAndNeuralEngine // Use Neural Engine for efficiency
                
                let mlModel = try MLModel(contentsOf: modelURL, configuration: config)
                positionModel = try VNCoreMLModel(for: mlModel)
                positionModelAvailable = true
                print("✅ BabyPositionClassifier model loaded successfully")
            } catch {
                print("⚠️ BabyPositionClassifier model found but failed to load: \(error)")
            }
        } else {
            print("ℹ️ BabyPositionClassifier.mlmodel not found - using Vision framework fallback")
        }
    }
    
    private func loadCryingModel() {
        // Try to load BabyCryingClassifier.mlmodel
        if let modelURL = Bundle.main.url(forResource: "BabyCryingClassifier", withExtension: "mlmodelc") {
            do {
                let config = MLModelConfiguration()
                config.computeUnits = .cpuAndNeuralEngine
                
                cryingModel = try MLModel(contentsOf: modelURL, configuration: config)
                cryingModelAvailable = true
                print("✅ BabyCryingClassifier model loaded successfully")
            } catch {
                print("⚠️ BabyCryingClassifier model found but failed to load: \(error)")
            }
        } else {
            print("ℹ️ BabyCryingClassifier.mlmodel not found - using audio analysis fallback")
        }
    }
    
    private func loadFaceCoverageModel() {
        // Try to load FaceCoverageDetector.mlmodel
        if let modelURL = Bundle.main.url(forResource: "FaceCoverageDetector", withExtension: "mlmodelc") {
            do {
                let config = MLModelConfiguration()
                config.computeUnits = .cpuAndNeuralEngine
                
                let mlModel = try MLModel(contentsOf: modelURL, configuration: config)
                faceCoverageModel = try VNCoreMLModel(for: mlModel)
                faceCoverageModelAvailable = true
                print("✅ FaceCoverageDetector model loaded successfully")
            } catch {
                print("⚠️ FaceCoverageDetector model found but failed to load: \(error)")
            }
        } else {
            print("ℹ️ FaceCoverageDetector.mlmodel not found - using Vision framework fallback")
        }
    }
    
    private func printModelStatus() {
        print("""
        
        ╔════════════════════════════════════════╗
        ║       CribAlert ML Model Status        ║
        ╠════════════════════════════════════════╣
        ║ Position Detection:  \(positionModelAvailable ? "✅ Custom Model" : "⚡ Vision Fallback")
        ║ Crying Detection:    \(cryingModelAvailable ? "✅ Custom Model" : "⚡ Audio Analysis")
        ║ Face Coverage:       \(faceCoverageModelAvailable ? "✅ Custom Model" : "⚡ Vision Fallback")
        ╚════════════════════════════════════════╝
        
        To enable custom models, add .mlmodel files to the Xcode project:
        - BabyPositionClassifier.mlmodel (Image classifier)
        - BabyCryingClassifier.mlmodel (Sound classifier)
        - FaceCoverageDetector.mlmodel (Image classifier)
        
        """)
    }
}

// MARK: - Model Specifications

/// Expected input/output specifications for custom models
enum ModelSpecifications {
    
    /// BabyPositionClassifier.mlmodel
    /// - Input: 224x224 RGB image
    /// - Output: Classification (on_back, on_side, on_stomach, unknown)
    enum PositionClassifier {
        static let inputSize = CGSize(width: 224, height: 224)
        static let labels = ["on_back", "on_side", "on_stomach", "unknown"]
    }
    
    /// BabyCryingClassifier.mlmodel  
    /// - Input: Audio spectrogram or features
    /// - Output: Classification (crying, not_crying)
    enum CryingClassifier {
        static let sampleRate: Double = 16000
        static let windowSize: Int = 1024
        static let labels = ["crying", "not_crying"]
    }
    
    /// FaceCoverageDetector.mlmodel
    /// - Input: 224x224 RGB image
    /// - Output: Classification (clear, partially_covered, covered)
    enum FaceCoverageDetector {
        static let inputSize = CGSize(width: 224, height: 224)
        static let labels = ["clear", "partially_covered", "covered"]
    }
}
