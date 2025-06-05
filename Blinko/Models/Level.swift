//
//  Level.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 17/05/25.
//

import Foundation

// Level Model
struct Level: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    
    // Every model has a set of 4 VocabularyWords.
    var words: [VocabularyWord]
}
