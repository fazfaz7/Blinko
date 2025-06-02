//
//  ViewModel.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 16/05/25.
//


import Foundation
import CoreImage
import Observation
import CoreML
import Vision

@Observable
class MLViewModel {
    var currentFrame: CGImage?
    
    // Camera Manager Object
    let cameraManager = CameraManager()
    
    // String containing the currently detected object
    var detectedObject: String = "No object detected"
    
    // The Core ML model used for object detection
    private var mlModel: MLModel?
    
    private let modelName: String  // <--- NEW
    
    init(modelName: String) {
        self.modelName = modelName
        // Load the ML model first (async)
        loadMLModel()
        
        Task {
            // Start handling camera preview frames (async)
            await handleCameraPreviews()
        }
    }
    
    
    // Attempts to load the Core ML model with fallback strategies:
    // 1. First tries to load pre-compiled model (.mlmodelc)
    // 2. Falls back to compiling source model (.mlmodel) if needed
    
    private func loadMLModel() {
        // 1. First try to load compiled model (.mlmodelc)
        if let compiledModelURL = Bundle.main.url(forResource: modelName, withExtension: "mlmodelc") {
            do {
                mlModel = try MLModel(contentsOf: compiledModelURL)
                print("Successfully loaded compiled model")
                setupObjectDetection() // Initialize detection once model is ready
                return
            } catch {
                print("Error loading compiled model: \(error)")
            }
        }
        
        // 2. Fall back to compiling .mlmodel if needed
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "mlmodel") else {
            print("Error: Could not find Test3.mlmodel in bundle")
            return
        }
        
        do {
            // Compile the model first
            let compiledModelURL = try MLModel.compileModel(at: modelURL)
            // Then load the compiled model
            mlModel = try MLModel(contentsOf: compiledModelURL)
            print("Successfully compiled and loaded model")
            setupObjectDetection()
        } catch {
            print("Error compiling or loading model: \(error)")
        }
    }
    
    
    // Subscribes to the camera preview stream and updates the current frame
    // Runs in a continuous loop while the camera is active
    func handleCameraPreviews() async {
        for await image in cameraManager.previewStream {
            // Update UI on main thread
            Task { @MainActor in
                currentFrame = image
            }
        }
    }
    
    // Configures the object detection pipeline once the model is loaded
    private func setupObjectDetection() {
        guard let mlModel = mlModel else {
            print("Cannot setup detection - no model loaded")
            return
        }
        
        // Configure the camera manager with ML model
        cameraManager.setupMLModel(with: mlModel) { [weak self] detectedObject in
            DispatchQueue.main.async {
                self?.detectedObject = detectedObject
                print("Detected: \(detectedObject)")
            }
        }
    }
}
