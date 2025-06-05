//
//  LevelProgress.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 22/05/25.
//

import Foundation

// Represents the user's progress for a single level.
struct LevelProgress: Codable, Hashable {
    // The unique identifier of the level this progress refers to.
    var levelID: UUID = UUID()
    
    // The set of stages that have been completed in this level.
    var completedStages: Set<GameStage> = []
    
    // Indicates whether the entire level has been completed (all stages are finished).
    var isLevelCompleted: Bool {
        completedStages.count == GameStage.allCases.count
    }
    
    // Returns true if a specific stage has been completed.
    func isStageCompleted(_ stage: GameStage) -> Bool {
        completedStages.contains(stage)
    }
    
    // Finds the first stage in this level that has not yet been completed
    func firstIncompleteStage() -> GameStage? {
        GameStage.allCases.first { !completedStages.contains($0) }
    }
}


// Tracks the progress of the user through levels and stages in the game.
class UserProgress: ObservableObject {
    // Stores the progress for each level, using the level's UUID as the key.
    @Published var levelsProgress: [UUID: LevelProgress] = [:]
    
    init() {
            load()
        }
    
    // Checks if a level is unlocked
    func isLevelUnlocked(levelIndex: Int, levels: [Level]) -> Bool {
        // The first level is always unlocked.
        if levelIndex == 0 { return true }
        
        // Unlock the level if the previous level has been completed.
        let prevLevelID = levels[levelIndex - 1].id
        return levelsProgress[prevLevelID]?.isLevelCompleted == true
    }
    
    // Checks if a specific stage within a level is unlocked.
    func isStageUnlocked(_ stage: GameStage, for level: Level) -> Bool {
        // Get current progress or initialize a new one if none exists.
        let progress = levelsProgress[level.id] ?? LevelProgress(levelID: level.id)
        
        // A stage is unlocked if it's the first incomplete one in the sequence.
        return progress.firstIncompleteStage() == stage
    }
    
    // Returns true if the stage is already completed OR is the next stage to unlock.
    func isStageEnabled(_ stage: GameStage, for level: Level) -> Bool {
        let progress = levelsProgress[level.id] ?? LevelProgress(levelID: level.id)
        return progress.completedStages.contains(stage) || progress.firstIncompleteStage() == stage
    }

    
    
    // Marks a specific stage as completed for a given level.
    func markStageCompleted(_ stage: GameStage, for level: Level) {
        // Retrieve current progress or start new if none exists.
        var progress = levelsProgress[level.id] ?? LevelProgress(levelID: level.id)
        
        // Add this stage to the set of completed stages.
        progress.completedStages.insert(stage)
        
        // Save the updated progress.
        levelsProgress[level.id] = progress
        save()
    }
    
    // Saving/loading to disk (UserDefaults, can be replaced with SwiftData)
    func save() {
        if let data = try? JSONEncoder().encode(levelsProgress) {
            UserDefaults.standard.set(data, forKey: "levelsProgress")
        }
    }
    func load() {
        if let data = UserDefaults.standard.data(forKey: "levelsProgress"),
           let decoded = try? JSONDecoder().decode([UUID: LevelProgress].self, from: data) {
            levelsProgress = decoded
        }
    }
}
