//
//  CIImage+Extension.swift
//  SettingCameraMacOS
//
//  Created by Adrian Emmanuel Faz Mercado on 26/04/25.
//

import CoreImage


// Converts processed Core Image results (CIImage) into standard images (CGImage)
extension CIImage {
    
    var cgImage: CGImage? {
        let ciContext = CIContext()
        
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else {
            return nil
        }
        
        return cgImage
    }
    
}
