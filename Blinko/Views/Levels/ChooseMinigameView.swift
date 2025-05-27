//
//  ChooseMinigameView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 26/05/25.
//

import SwiftUI

struct ChooseMinigameView: View {
    // Array of 3 planet numbers to display (e.g., [6, 2, 4])
    let planetNumbers: [Int]
    
    // Angles for planet positions (in radians)
    let angles: [CGFloat] = [
        0.30 * Double.pi, 0.5 * Double.pi, 0.65 * Double.pi,
    ]
    
    // Track which planet is currently revealed
    @State private var revealedIndex: Int = 0
    
    // Animation control for the connecting path
    @State private var pathTrim: CGFloat = 0.0
    
    // Controls the pulsing animation of planets
    @State private var pulsing: Bool = false

    // Initialize with default planet numbers [1, 2, 3]
    init(planetNumbers: [Int] = [1, 2, 3]) {
        self.planetNumbers = planetNumbers
    }

    var body: some View {
        ZStack {
            // Background image
            Image("MinigameBackground")
                .resizable()
                .ignoresSafeArea()

            GeometryReader { geometry in
                // Center point for the sun and orbits
                let center = CGPoint(x: geometry.size.width / 2, y: 0)

                // Sun image at the center
                Image("sun")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 1.35)
                    .position(center)

                // Base size for the innermost orbit
                let baseOrbitSize = geometry.size.width * 0.80
                
                // Spacing between orbits
                let spacing = geometry.size.width * 0.26

                // Calculate planet positions based on angles and orbit sizes
                let planetPositions: [CGPoint] = (0..<3).map { i in
                    let orbitSize = baseOrbitSize + CGFloat(i) * spacing
                    let orbitRadius = orbitSize / 2
                    let angle = angles[i % angles.count]
                    let planetX = center.x + orbitRadius * cos(angle)
                    let planetY = center.y + orbitRadius * sin(angle)
                    return CGPoint(x: planetX, y: planetY)
                }

                // Sort planets from left to right for path drawing
                let sortedPlanets = planetPositions.enumerated().sorted {
                    $0.element.x < $1.element.x
                }
                let sortedPositions = sortedPlanets.map { $0.element }
                let sortedIndices = sortedPlanets.map { $0.offset }

                // --- Draw the connecting path between planets ---
                Path { path in
                    guard sortedPositions.count > 1 else { return }
                    path.move(to: sortedPositions[0])
                    for i in 1..<sortedPositions.count {
                        let prev = sortedPositions[i - 1]
                        let current = sortedPositions[i]
                        let control = CGPoint(
                            x: (prev.x + current.x) / 2,
                            y: i == 1
                                ? max(prev.y, current.y) - geometry.size.height * 0.10
                                : max(prev.y, current.y) + geometry.size.height * 0.10
                        )
                        path.addQuadCurve(to: current, control: control)
                    }
                }
                .trim(from: 0, to: pathTrim) // Animate path drawing
                .stroke(
                    style: StrokeStyle(lineWidth: 8, lineCap: .round, dash: [20, 10])
                )
                .foregroundColor(.white.opacity(0.7))

                // Create planet buttons
                ForEach(0..<3) { i in
                    let idx = sortedIndices[i]
                    let pos = sortedPositions[i]

                    // Draw orbit circle
                    let orbitSize = baseOrbitSize + CGFloat(idx) * spacing
                    Circle()
                        .stroke(Color.white, lineWidth: 1.2)
                        .frame(width: orbitSize, height: orbitSize)
                        .position(center)

                    // Planet button
                    Button {
                        // When clicking a planet further along, update the path
                        if i > revealedIndex {
                            revealedIndex = i
                            withAnimation(.easeOut(duration: 0.6)) {
                                pathTrim = CGFloat(i) / 2
                            }
                        }
                    } label: {
                        // Planet image with pulsing animation
                        Image("minigame_planet\(planetNumbers[idx])")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 190)
                            .scaleEffect(pulsing ? 1.06 : 0.95)
                            .animation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true), value: pulsing)
                    }
                    .position(pos)
                    .onAppear {
                        pulsing = true
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    // Preview with example planet numbers
    ChooseMinigameView(planetNumbers: [1, 4, 6])
}


// Angle Combinations:

// [0.5, 0.7, 0.35]
// [0.7, 0.5, 0.35]
// [0.3, 0.5, 0.65]
