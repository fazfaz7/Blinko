//
//  PlanetGradientOverlay.swift
//  Blinko
//
//  Created by Vincenzo Gerelli on 03/06/25.
//
import SwiftUI

struct PlanetGradientOverlay: View {
    let imageName: String
    let baseColor: Color
    let pulse: Bool
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [.white, baseColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .scaleEffect(pulse ? 1.1 : 1.0)
            .opacity(0.5)
    }
}
