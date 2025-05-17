//
//  CMSampleBuffer+Extension.swift
//  SettingCameraMacOS
//
//  Created by Adrian Emmanuel Faz Mercado on 26/04/25.
//

import AVFoundation
import CoreImage


// Converts raw camera frames (CMSampleBuffer) into display-ready images (CGImage)

extension CMSampleBuffer {
    
    var cgImage: CGImage? {
        let pixelBuffer: CVPixelBuffer? = CMSampleBufferGetImageBuffer(self)
        
        guard let imagePixelBuffer = pixelBuffer else {
            return nil
        }
        
        return CIImage(cvPixelBuffer: imagePixelBuffer).cgImage
    }
    
}


