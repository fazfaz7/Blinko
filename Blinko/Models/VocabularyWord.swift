//
//  Word.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 16/05/25.
//

import Foundation

// VocabularyWord Model
struct VocabularyWord: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var baseWord: String
    var imageName: String
    
    // Dictionary with the translations in the languages that we are including. Example: ["en": "portafoglio", "es": "cartera", "it": "portafoglio"]
    var translations: [String: String]
}



var level1 = Level(title: "Level 1", words: [VocabularyWord(baseWord: "pencil", imageName: "pencil", translations: ["en": "pencil", "es": "lápiz", "it": "matita"]), VocabularyWord(baseWord: "notebook", imageName: "notebook", translations: ["en": "notebook", "es": "libreta", "it": "quaderno"]), VocabularyWord(baseWord: "ruler", imageName: "ruler", translations: ["en": "ruler", "es": "regla", "it": "righello"]), VocabularyWord(baseWord: "pen", imageName: "pen", translations: ["en": "pen", "es": "pluma", "it": "penna"])])

var level2 = Level(title: "Level 2", words: [VocabularyWord(baseWord: "backpack", imageName: "backpack", translations: ["en": "backpack", "es": "mochila", "it": "zaino"]), VocabularyWord(baseWord: "sharpener", imageName: "sharpener", translations: ["en": "sharpener", "es": "sacapuntas", "it": "temperamatite"]), VocabularyWord(baseWord: "eraser", imageName: "eraser", translations: ["en": "eraser", "es": "borrador", "it": "goma"]), VocabularyWord(baseWord: "pencil case", imageName: "pencil_case", translations: ["en": "pencil case", "es": "estuche", "it": "astuccio"])])

var level3 = Level(title: "Level 3", words: [VocabularyWord(baseWord: "apple", imageName: "apple", translations: ["en": "apple", "es": "manzana", "it": "mela"]), VocabularyWord(baseWord: "pear", imageName: "pear", translations: ["en": "pear", "es": "pera", "it": "pera"]), VocabularyWord(baseWord: "banana", imageName: "banana", translations: ["en": "banana", "es": "plátano", "it": "banana"]), VocabularyWord(baseWord: "tomato", imageName: "tomato", translations: ["en": "tomato", "es": "tomate", "it": "pomodoro"])])


