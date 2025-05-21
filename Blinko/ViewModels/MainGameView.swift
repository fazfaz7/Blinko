//
//  MainGameView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 21/05/25.
//


import SwiftUI

enum GameStage {
    case treasureHunt
    case memoryGame
    case invertedTH
}

// MainGameView - View that manages the 3 minigames that are independent.
struct MainGameView: View {
    @State private var currentStage: GameStage = .treasureHunt
    
    var body: some View {
        ZStack {
            switch currentStage {
            case .treasureHunt:
                TreasureHuntView(onNext: { currentStage = .memoryGame })
            case .memoryGame:
                ImageMatchingView(words: level1.words, onNext: { currentStage = .invertedTH })
            case .invertedTH:
                InvertedTHView(onNext: {currentStage = .treasureHunt})
            }
        }.transition(.move(edge: .trailing)) // Animation
        .animation(.easeInOut, value: currentStage)
    }
}

#Preview {
    //MainGameView(onNext: { currentStage = .memoryGame)
}

