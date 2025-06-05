//
//  MinigameSelectionView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 22/05/25.
//

import SwiftUI


// A container view that displays either the minigame selection menu or the chosen minigame.
// Allows the user to select and play a minigame for the given level.

struct MinigameContainerView: View {
    let level: Level
    @ObservedObject var userProgress: UserProgress
    
    // A closure that is called when the user closes the minigame container.
    var onClose: () -> Void

    // The currently selected stage (minigame); if nil, show the selection menu.
    @State private var selectedStage: GameStage? = nil

    var body: some View {
        ZStack {
            if let stage = selectedStage {
                // If a minigame is selected, show the minigame view.
                minigameView(for: stage)
            } else {
                // Otherwise, show the minigame selection menu.
                VStack(spacing: 30) {
                    Text("Choose a minigame")
                        .font(.title.bold())
                    
                    // Display a button for each available minigame (GameStage).
                    ForEach(GameStage.allCases, id: \.self) { stage in
                        Button {
                            selectedStage = stage
                        } label: {
                            Text(label(for: stage))
                                .font(.title2)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.1)))
                        }.disabled(!userProgress.isStageEnabled(stage, for: level))

                    }
                
                }
                .padding()
            }
            
            // Top-right close button. Dismisses minigame or entire container.
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
        .background(Color.black.opacity(0.1).ignoresSafeArea())
        .transition(.move(edge: .trailing)) // Animation
        .animation(.easeInOut, value: selectedStage)
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
            TreasureHuntView(level: level) {
                selectedStage = nil
            }.environmentObject(userProgress)
        case .memoryGame:
            ImageMatchingView(level: level) {
                selectedStage = nil
            }.environmentObject(userProgress)
        case .invertedTH:
            InvertedTHView(level: level) {
                selectedStage = nil
            }
        }
    }
}

