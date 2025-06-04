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
    
    @State private var isPulsing = false

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
            .scaleEffect(isPulsing ? 1.1 : 1.0)
            .opacity(0.5)
            .onAppear {
                if pulse {
                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        isPulsing = true
                    }
                }
            }
            .onChange(of: pulse) {
                if pulse {
                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        isPulsing = true
                    }
                } else {
                    isPulsing = false
                }
            }
            .onDisappear {
                isPulsing = false
            }
    }
}

