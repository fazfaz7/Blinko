//
//  CameraManager.swift
//  SettingCameraMacOS
//
//  Created by Adrian Emmanuel Faz Mercado on 26/04/25.
//

import Foundation
import AVFoundation
import CoreML
import Vision


class CameraManager: NSObject {
    // 1. captureSession: an AVCaptureSession object that performs real-time capture and adds appropriate inputs and outputs
    private let captureSession = AVCaptureSession()
    
    // 2. deviceInput: an AVCaptureDeviceInput that describes the media input from a capture device to a capture session
    private var deviceInput: AVCaptureDeviceInput?
    
    // 3. videoOutput: an AVCaptureVideoDataOutput object used to have access to video frames for processing
    private var videoOutput: AVCaptureVideoDataOutput?
    
    // 4. systemPreferredCamera: an AVCaptureDevice object represents the hardware or virtual capture device that can provide one or more streams of media of a particular type
    private let systemPreferredCamera = AVCaptureDevice.default(for: .video)
    
    
    // 5. sessionQueue: the queue on which the AVCaptureVideoDataOutputSampleBufferDelegate callbacks should be invoked. It is mandatory to use a serial dispatch queue to guarantee that video frames will be delivered in order.
    private var sessionQueue = DispatchQueue(label: "video.preview.session")
    
    
    // Async property that checks/requests camera permissions
    private var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
    private var addToPreviewStream: ((CGImage) -> Void)?
    
    
    // Async stream that provides frames for preview
    lazy var previewStream: AsyncStream<CGImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { cgImage in
                continuation.yield(cgImage)
            }
        }
    }()
    
   // Handles ML model processing
    private var mlProcessor: MLModelProcessor?
    
    private var detectionHandler: ((String) -> Void)?
    
    override init() {
        super.init()
        
        Task {
            await configureSession()
            await startSession()
        }
    }
    
    // 2.
    private func configureSession() async {
        // 1.
        guard await isAuthorized,
              let systemPreferredCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera)
        else { return }
        
        // 2.
        captureSession.beginConfiguration()
        
        // 3.
        defer {
            self.captureSession.commitConfiguration()
        }
        
        // 4.
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
        // 5.
        guard captureSession.canAddInput(deviceInput) else {
            print("Unable to add device input to capture session.")
            return
        }
        
        // 6.
        guard captureSession.canAddOutput(videoOutput) else {
            print("Unable to add video output to capture session.")
            return
        }
        
        // 7.
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        
    }
    
    // 3.
    private func startSession() async {
        /// Checking authorization
        guard await isAuthorized else { return }
        /// Start the capture session flow of data
        captureSession.startRunning()
    }
    
    func setupMLModel(with model: MLModel, detectionHandler: @escaping (String) -> Void) {
        self.detectionHandler = detectionHandler
        mlProcessor = MLModelProcessor(model: model, detectionHandler: detectionHandler)
    }
}


// Handles the raw video frames coming from the camera
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // Called whenever a new video frame is available from the camera
    func captureOutput(_ output: AVCaptureOutput,
                     didOutput sampleBuffer: CMSampleBuffer,
                     from connection: AVCaptureConnection) {
        
        // 1. First convert the frame to a CGImage for preview display
        guard let currentFrame = sampleBuffer.cgImage else {
            return  // Skip this frame if conversion fails
        }
        
        // 2. Send the converted image to the preview stream
        // This updates the live camera view in the UI
        addToPreviewStream?(currentFrame)
        
        // 3. ML Processing Pipeline
        // First get the raw pixel buffer
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
           // Check if we have an ML processor configured
           let mlProcessor = mlProcessor {
            // Pass the frame to our ML processor for object detection
            mlProcessor.processFrame(pixelBuffer)
        }
    }
}


// Handles all CoreML/Vision processing tasks
class MLModelProcessor {
    // The Vision wrapper for the CoreML model
    private var visionModel: VNCoreMLModel?
    
    // Array to hold the Vision requests
    private var requests = [VNRequest]()
    
    // Callback to send detection results back to ViewModel
    private var detectionHandler: ((String) -> Void)?
    
    // Initialize with a CoreML model and result handler
    init?(model: MLModel, detectionHandler: @escaping (String) -> Void) {
        // Store the callback handler
        self.detectionHandler = detectionHandler
        
        do {
            // 1. Convert CoreML model to Vision framework format
            // This enables Vision's preprocessing and optimization
            visionModel = try VNCoreMLModel(for: model)
            
            // 2. Set up the Vision request pipeline
            setupVisionRequest()
        } catch {
            // Handle model conversion errors
            print("Error creating VNCoreMLModel: \(error)")
            return nil
        }
    }
    
    // Configure the Vision request that will process each frame
    private func setupVisionRequest() {
        // Safely unwrap our Vision model
        guard let visionModel = visionModel else { return }
        
        // Create the CoreML Vision request:
        let request = VNCoreMLRequest(model: visionModel) {
            // This completion handler runs when detection finishes
            [weak self] request, error in
            // Process the detection results or errors
            self?.processDetectionResults(for: request, error: error)
        }
        
        // Configure how Vision handles image sizing:
        // .scaleFill maintains aspect ratio while filling the frame
        request.imageCropAndScaleOption = .scaleFill
        
        // Store the request in the array
        requests = [request]
    }
    
    // Handle the detection results from Vision
    private func processDetectionResults(for request: VNRequest, error: Error?) {
        // 1. First check for errors
        if let error = error {
            print("Detection error: \(error.localizedDescription)")
            return
        }
        
        // 2. Verify we got valid results
        guard let results = request.results else {
            detectionHandler?("No results")  // Notify UI of empty results
            return
        }
        
        // 3. Process classification results
        if let classifications = results as? [VNClassificationObservation],
           // Find the first classification with >50% confidence
           let bestResult = classifications.first(where: { $0.confidence > 0.3 }) {
            // Send the identified object to our handler
            detectionHandler?(bestResult.identifier)
        }
    }
    
    // Process a single camera frame through the ML pipeline
    func processFrame(_ pixelBuffer: CVPixelBuffer) {
        // Create a Vision image handler for this specific frame
        // The options dictionary could contain orientation hints etc.
        let imageRequestHandler = VNImageRequestHandler(
            cvPixelBuffer: pixelBuffer,
            options: [:]
        )
        
        do {
            // Execute our Vision request (this runs the actual ML model)
            try imageRequestHandler.perform(requests)
        } catch {
            // Handle processing errors
            print("Failed to perform classification: \(error.localizedDescription)")
        }
    }
}


extension CameraManager {
    func stopSession() {
        sessionQueue.async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }

    func startSessionIfNeeded() {
        sessionQueue.async { [weak self] in
            if let isRunning = self?.captureSession.isRunning, !isRunning {
                self?.captureSession.startRunning()
            }
        }
    }
}
