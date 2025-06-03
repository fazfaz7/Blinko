//
//  ChooseMinigameView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 26/05/25.
//

import SwiftUI

struct ChooseMinigameView: View {
    // Array of 3 planet numbers to display (e.g., [6, 2, 4])
    
    let level: Level
    @ObservedObject var userProgress: UserProgress
    
    // A closure that is called when the user closes the minigame container.
    var onClose: () -> Void
    
    // The currently selected stage (minigame); if nil, show the selection menu.
    @State private var selectedStage: GameStage? = nil
    
    let planetNumbers: [Int] = [1,2,3]
    
    // Angles for planet positions (in radians)
    let angles: [CGFloat] = [
        0.5 * Double.pi, 0.7 * Double.pi, 0.35 * Double.pi,
    ]
    
    // Track which planet is currently revealed
    @State private var revealedIndex: Int = 0
    
    // Animation control for the connecting path
    @State private var pathTrim: CGFloat = 0.0
    
    // Controls the pulsing animation of planets
    @State private var pulsing: Bool = false
    
    @State private var localPulsing: [Bool] = [false, false, false]

    let stages: [GameStage] = [.treasureHunt, .memoryGame, .invertedTH]
    
    
    private var pulsingIndex: Int? {
            let progress = userProgress.levelsProgress[level.id] ?? LevelProgress(levelID: level.id)
            return progress.firstIncompleteStage().flatMap { stages.firstIndex(of: $0) }
        }
    
    @State private var pathAnim: [CGFloat] = [0, 0] // For 2 lines between 3 planets
    



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
                    
                    // Get current level progress
                    let progress = userProgress.levelsProgress[level.id] ?? LevelProgress(levelID: level.id)
                    
                    let pulsingStage = progress.firstIncompleteStage()
                    let pulsingIndex = pulsingStage.flatMap { stages.firstIndex(of: $0) }


                    ForEach(1..<sortedPositions.count, id: \.self) { i in
                        let stage = stages[i-1]
                        if progress.isStageCompleted(stage) {
                            Path { path in
                                let prev = sortedPositions[i - 1]
                                let current = sortedPositions[i]
                                let control = CGPoint(
                                    x: (prev.x + current.x) / 2,
                                    y: i == 1
                                    ? max(prev.y, current.y) - geometry.size.height * 0.10
                                    : max(prev.y, current.y) + geometry.size.height * 0.10
                                )
                                path.move(to: prev)
                                path.addQuadCurve(to: current, control: control)
                            }
                            .trim(from: 0, to: pathAnim[i-1])
                            .stroke(
                                style: StrokeStyle(lineWidth: 8, lineCap: .round, dash: [20, 10])
                            )
                            .foregroundColor(.white.opacity(0.7))
                        }
                    }


                    
                    ForEach(0..<3) { i in
                        let idx = sortedIndices[i]
                        let pos = sortedPositions[i]
                        let isPulsing = (i == pulsingIndex)
                        
                        // Draw orbit circle (come prima)
                        let orbitSize = baseOrbitSize + CGFloat(idx) * spacing
                        Circle()
                            .stroke(Color.white, lineWidth: 1.2)
                            .frame(width: orbitSize, height: orbitSize)
                            .position(center)
                        
                        // Planet button
                        Button {
                            if i > revealedIndex {
                                revealedIndex = i
                                withAnimation(.easeOut(duration: 0.6)) {
                                    pathTrim = CGFloat(i) / 2
                                }
                            }
                            selectedStage = stages[i]
                        } label: {
                            PulsingPlanetView(
                                imageName: "minigame_planet\(planetNumbers[idx])",
                                color: .white,
                                pulse: isPulsing
                            )
                            .frame(width: 190)
                            
//                            Image("minigame_planet\(planetNumbers[idx])")
//                                                    .resizable()
//                                                    .scaledToFit()
//                                                    .frame(width: 190)
//                                                    .scaleEffect(localPulsing[i] ? 1.26 : 0.95)
//                                                    .animation(
//                                                        localPulsing[i]
//                                                        ? .easeInOut(duration: 1).repeatForever(autoreverses: true)
//                                                        : .default,
//                                                        value: localPulsing[i]
//                                                    )
                        }
                        .position(pos)
                        .onAppear {
                            if isPulsing && !localPulsing[i] {
                                // Forza l’animazione solo su quello giusto
                                DispatchQueue.main.async {
                                    localPulsing[i] = true
                                }
                            }
                        }
                        .onDisappear {
                            localPulsing[i] = false
                        }
                        .disabled(!userProgress.isStageEnabled(stages[i], for: level))
                    }
                }
            
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        if selectedStage != nil {
                            // If inside a minigame, go back to the menu.
                            selectedStage = nil
                        } else {
                            // If on the menu, close the entire container.
                            onClose()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .padding(20)
                            .foregroundColor(.white)
                            .background(Circle().fill(.gray.opacity(0.8)))
                    }
                }
                Spacer()
            }
            
        }
        .ignoresSafeArea()
                .fullScreenCover(item: $selectedStage) { stage in
                    minigameView(for: stage)
                }
                .onChange(of: userProgress.levelsProgress) {
                    // Update pulsing states whenever progress changes
                    updatePulsingStates()
                    animateProgressLines()
                }
                .onAppear {
                    // Initialize pulsing states when view appears
                    updatePulsingStates()
                    animateProgressLines()
                }
                .statusBarHidden() 


    }
    
    // Returns the display label for a given minigame (stage).
    func label(for stage: GameStage) -> String {
        switch stage {
        case .treasureHunt: return "Treasure Hunt"
        case .memoryGame: return "Image Matching"
        case .invertedTH: return "Inverted Hunt"
        }
    }

    // Returns the appropriate minigame view for a given stage, passing in the level and user progress.
    @ViewBuilder
    func minigameView(for stage: GameStage) -> some View {
        switch stage {
        case .treasureHunt:
            TreasureHuntView(level: level, userProgress: userProgress) {
                selectedStage = nil
            }
        case .memoryGame:
            ImageMatchingView(level: level, userProgress: userProgress) {
                selectedStage = nil
            }
        case .invertedTH:
            InvertedTHView(level: level, userProgress: userProgress) {
                selectedStage = nil
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                    onClose()
                }
            }
        }
    }
    
    private func updatePulsingStates() {
          let progress = userProgress.levelsProgress[level.id] ?? LevelProgress(levelID: level.id)
          let newPulsingIndex = progress.firstIncompleteStage().flatMap { stages.firstIndex(of: $0) }
          
          // Reset all pulsing states
          localPulsing = [false, false, false]
          
          // Enable pulsing for the current incomplete stage
          if let newPulsingIndex = newPulsingIndex {
              localPulsing[newPulsingIndex] = true
          }
      }
    
    private func animateProgressLines() {
        let progress = userProgress.levelsProgress[level.id] ?? LevelProgress(levelID: level.id)
        // For each completed stage, if the animation hasn't run yet, animate it
        for i in 0..<2 {
            let stage = stages[i]
            if progress.isStageCompleted(stage) && pathAnim[i] < 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeOut(duration: 1.2)) {
                        pathAnim[i] = 1
                    }
                }
            } else if !progress.isStageCompleted(stage) {
                pathAnim[i] = 0 // Reset if not completed
            }
        }
    }
    
    
}

#Preview {
    // Preview with example planet numbers
    ChooseMinigameView(
        level: level1_data,
        userProgress: UserProgress(),
        onClose: {}
    )
}


// Angle Combinations:

// [0.5, 0.7, 0.35]
// [0.7, 0.5, 0.35]
// [0.3, 0.5, 0.65]
