//
//  CameraView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 26/04/25.
//

import SwiftUI

// View that displays the live camera feed.
struct CameraView: View {
    
    // CGImage is used for faster performance
    @Binding var image: CGImage?
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                Image(decorative: image, scale: 1)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
            } else {
                // If there is no camera available, an unavailable view is shown.
                ContentUnavailableView("No camera feed", systemImage: "xmark.circle.fill")
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
            }
        }
    }
    
}
