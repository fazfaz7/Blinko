//
//  ChooseMinigameView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 26/05/25.
//

import SwiftUI

struct ChooseMinigameView: View {
    // Angles for each circle (in radians)
    let angles: [CGFloat] = [
        0.5 * Double.pi, 0.7 * Double.pi, 0.35 * Double.pi,
    ]
    @State private var revealedIndex: Int = 0
    @State private var pathTrim: CGFloat = 0.0
    @State private var pulsing: Bool = false


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

                // Calculate and store the planet positions in an array
                let planetPositions: [CGPoint] = (0..<3).map { i in
                    let orbitSize = baseOrbitSize + CGFloat(i) * spacing
                    let orbitRadius = orbitSize / 2
                    let angle = angles[i % angles.count]
                    let planetX = center.x + orbitRadius * cos(angle)
                    let planetY = center.y + orbitRadius * sin(angle)
                    return CGPoint(x: planetX, y: planetY)
                }

                let sortedPlanets = planetPositions.enumerated().sorted {
                    $0.element.x < $1.element.x
                }
                let sortedPositions = sortedPlanets.map { $0.element }
                let sortedIndices = sortedPlanets.map { $0.offset }

                // --- Draw the connecting path ---
                // Draw path connecting left-to-right planets

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
                .trim(from: 0, to: pathTrim)
                .stroke(
                    style: StrokeStyle(lineWidth: 8, lineCap: .round, dash: [20, 10])
                )
                .foregroundColor(.white.opacity(0.7))

                ForEach(0..<3) { i in
                                    let idx = sortedIndices[i]
                                    let pos = sortedPositions[i]

                                    // Orbita (circle)
                                    let orbitSize = baseOrbitSize + CGFloat(idx) * spacing
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1.2)
                                        .frame(width: orbitSize, height: orbitSize)
                                        .position(center)

                                    // Bottone pianeta
                                    Button {
                                        // Se clicchi un pianeta più avanti, aggiorna la linea
                                        if i > revealedIndex {
                                                revealedIndex = i
                                                withAnimation(.easeOut(duration: 0.6)) {
                                                    pathTrim = CGFloat(i) / 2 
                                                }
                                            }
                                    } label: {
                                        Image("minigame_planet\(idx+1)")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 190)
                                            .scaleEffect(pulsing ? 1.06 : 0.95) // how much it pulses
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
    ChooseMinigameView()
}
