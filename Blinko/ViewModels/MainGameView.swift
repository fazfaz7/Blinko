//
//  MainGameView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 21/05/25.
//


import SwiftUI

enum GameStage: CaseIterable, Codable{
    case treasureHunt
    case memoryGame
    case invertedTH
}


// MainGameView - View that manages the 3 minigames that are independent.
struct MainGameView: View {
    @State private var currentStage: GameStage = .treasureHunt
    @ObservedObject var userProgress: UserProgress
    
    var level: Level
    
    var body: some View {
        ZStack {
            switch currentStage {
            case .treasureHunt:
                TreasureHuntView(level: level, userProgress: userProgress, onNext: { currentStage = .memoryGame })
            case .memoryGame:
                ImageMatchingView(level: level, userProgress: userProgress, onNext: { currentStage = .invertedTH })
            case .invertedTH:
                InvertedTHView(level: level, userProgress: userProgress, onNext: {currentStage = .treasureHunt})
            }
        }.transition(.move(edge: .trailing)) // Animation
        .animation(.easeInOut, value: currentStage)
    }
}

#Preview {
    //MainGameView(onNext: { currentStage = .memoryGame)
}


