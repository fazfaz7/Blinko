//
//  ChooseMinigameView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 26/05/25.
//

import SwiftUI

struct ChooseMinigameView: View {
    // Angles for each circle (in radians)
    let angles: [CGFloat] = [0.5*Double.pi, 0.7*Double.pi, 0.35*Double.pi] // 0 to 2pi (MEZZO CAZZO PI is aligned to half of the sun)
    
    var body: some View {
        ZStack {
            Image("MinigameBackground")
                .resizable()
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                let center = CGPoint(x: geometry.size.width / 2, y: 0)
                
                Image("sun")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 1.35)
                    .position(center)
                
                let baseOrbitSize = geometry.size.width * 0.80
                let spacing = geometry.size.width * 0.26
                
                ForEach(0..<3) { i in
                    let orbitSize = baseOrbitSize + CGFloat(i) * spacing
                    let orbitRadius = orbitSize / 2
                    
                    // Orbit circle
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: orbitSize, height: orbitSize)
                        .position(center)
                    
                    // Planet circle on the orbit
                    let angle = angles[i % angles.count]
                    let planetX = center.x + orbitRadius * cos(angle)
                    let planetY = center.y + orbitRadius * sin(angle)
                    
                    
                    Button {
                        print("hello \(i)")
                    } label: {
                        Image("minigame_planet\(i+1)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 190)
                            
                    }
                    .position(x: planetX, y: planetY)

                }
            }
        }
        .ignoresSafeArea()
    }
}


#Preview {
    ChooseMinigameView()
}
