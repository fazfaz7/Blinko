//
//  LevelSelectionView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 03/06/25.
//

import SwiftUI

struct StarLevel: Identifiable {
    let id: Int
    let position: CGPoint
    let connectedTo: [Int]
    let imageName: String
}

struct StarView: View {
    let isUnlocked: Bool
    let imageName: String
    var pulsing: Bool
    
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .opacity(isUnlocked ? 1.0 : 0.45)
            .grayscale(isUnlocked ? 0.0 : 1.0)
            .shadow(color: pulsing ? .white : .clear, radius: pulsing ? 20 : 0)
            .scaleEffect(pulsing ? 1.32 : 1)
            .animation(
                            pulsing ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default,
                            value: pulsing
                        )
      
    }
}

struct StarMapView: View {
    let stars: [StarLevel]
    let currentLevel: Int
    let unlockedUpTo: Int      // Example: 2 means stars 0, 1, 2 are unlocked

    let localPulsing: [Bool]
    
    @Binding var pathAnim: [CGFloat] // Changed from @State to @Binding
    
    var onLevelSelect: (Int) -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Draw connections ("roads")
                ForEach(stars) { star in
                    ForEach(star.connectedTo, id: \.self) { targetID in
                        if star.id <= unlockedUpTo && targetID <= unlockedUpTo {
                            if let target = stars.first(where: { $0.id == targetID }) {
                                Path { path in
                                    let from = CGPoint(x: star.position.x * geo.size.width,
                                                       y: star.position.y * geo.size.height)
                                    let to = CGPoint(x: target.position.x * geo.size.width,
                                                   y: target.position.y * geo.size.height)
                                    path.move(to: from)
                                    path.addLine(to: to)
                                }
                                .trim(from: 0, to: pathAnim[star.id]) // Use the corresponding pathAnim index
                                .stroke(
                                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                                )
                                .foregroundColor(.white)
                                .zIndex(-1)
                            }
                        }
                    }
                }
                
                // Draw stars
                ForEach(stars) { star in
                    let isUnlocked = star.id <= unlockedUpTo
                    Button {
                        if isUnlocked {
                            onLevelSelect(star.id)
                        }
                    } label: {
                        StarView(
                            isUnlocked: isUnlocked,
                            imageName: star.imageName,
                            pulsing: localPulsing[star.id]
                        )
                            .frame(width: 70, height: 70)
                    }
                    .position(
                        x: star.position.x * geo.size.width,
                        y: star.position.y * geo.size.height
                    )
                    .disabled(!isUnlocked)
                }
            }
            .cornerRadius(24)
           
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct LevelSelectionView: View {
    // 5 stars, zig-zag positions. Use whatever layout you want!
    let stars: [StarLevel] = [
        StarLevel(id: 0, position: CGPoint(x: 0.05, y: 0.32), connectedTo: [1], imageName: "star1"),
        StarLevel(id: 1, position: CGPoint(x: 0.28, y: 0.60), connectedTo: [2], imageName: "star2"),
        StarLevel(id: 2, position: CGPoint(x: 0.52, y: 0.50), connectedTo: [3], imageName: "star3"),
        StarLevel(id: 3, position: CGPoint(x: 0.75, y: 0.68), connectedTo: [4], imageName: "star4"),
        StarLevel(id: 4, position: CGPoint(x: 0.95, y: 0.28), connectedTo: [], imageName: "star5")
    ]
    
    let levels: [Level] = [level1_data, level2_data, level3_data, level4_data, level5_data]
    @ObservedObject var userProgress: UserProgress
    @State private var selectedLevel: Level? = nil
    @State private var showLanguageSheet: Bool = false
    
    // Current level should be the highest unlocked level
    @State private var currentLevel: Int {
        didSet {
            // Ensure currentLevel doesn't exceed unlocked levels
            if currentLevel > unlockedUpTo {
                currentLevel = unlockedUpTo
            }
        }
    }
    
    @State private var localPulsing: [Bool] = [false, false, false, false, false]
    
    @State private var pathAnim: [CGFloat] = [0, 0, 0, 0]
    
    // Unlocked up to the highest level the user has unlocked
    private var unlockedUpTo: Int {
        var highestUnlocked = 0
        for (index, _) in levels.enumerated() {
            if userProgress.isLevelUnlocked(levelIndex: index, levels: levels) {
                highestUnlocked = index
            }
        }
        return highestUnlocked
    }
    
    init(userProgress: UserProgress) {
        self.userProgress = userProgress
        // Initialize currentLevel to the highest unlocked level
        var highestUnlocked = 0
        for (index, _) in [level1_data, level2_data, level3_data, level4_data, level5_data].enumerated() {
            if userProgress.isLevelUnlocked(levelIndex: index, levels: [level1_data, level2_data, level3_data, level4_data, level5_data]) {
                highestUnlocked = index
            }
        }
        self._currentLevel = State(initialValue: highestUnlocked)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("SpaceBackground")
                    .scaledToFill()
                    .ignoresSafeArea()

                StarMapView(
                    stars: stars,
                    currentLevel: currentLevel,
                    unlockedUpTo: unlockedUpTo,
                    localPulsing: localPulsing,// ← ADD THIS!
                    pathAnim: $pathAnim // Pass the binding
                ) { selectedID in
                    currentLevel = selectedID
                    selectedLevel = levels[selectedID]
                }
                    .padding()
                    
                
            }.ignoresSafeArea()
               .onAppear {
                   updatePulsingStates()
                   DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                       animateProgressLines()
                   }
               }
               .onChange(of: currentLevel) {
                   updatePulsingStates()
                   DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                       animateProgressLines()
                   }
               }
               .onChange(of: unlockedUpTo) {
                   DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                       animateProgressLines()
                   }
               }
        }
        .fullScreenCover(item: $selectedLevel) { level in
            ChooseMinigameView(
                level: level,
                userProgress: userProgress
            ) {
                selectedLevel = nil
                currentLevel = unlockedUpTo
            }
        }
        .statusBarHidden()
    }
    
    private func updatePulsingStates() {
        localPulsing = stars.indices.map { $0 == currentLevel }
    }
    
    private func animateProgressLines() {
        // For each connection, if both stars are unlocked, animate the line
        for i in 0..<4 { // We have 4 connections between 5 stars
            let starID = i
            let isUnlocked = starID <= unlockedUpTo && (starID + 1) <= unlockedUpTo
            
            if isUnlocked && pathAnim[i] < 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeOut(duration: 1.2)) {
                        pathAnim[i] = 1
                    }
                }
            } else if !isUnlocked {
                pathAnim[i] = 0 // Reset if not unlocked
            }
        }
    }

}

#Preview {
    LevelSelectionView(userProgress: UserProgress())
}
