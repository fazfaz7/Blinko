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



var level1_data = Level(title: "level1", words: [VocabularyWord(baseWord: "pencil", imageName: "pencil", translations: ["en": "pencil", "es": "lápiz", "it": "matita"]), VocabularyWord(baseWord: "notebook", imageName: "notebook", translations: ["en": "notebook", "es": "libreta", "it": "quaderno"]), VocabularyWord(baseWord: "ruler", imageName: "ruler", translations: ["en": "ruler", "es": "regla", "it": "righello"]), VocabularyWord(baseWord: "pen", imageName: "pen", translations: ["en": "pen", "es": "pluma", "it": "penna"])])

var level2_data = Level(title: "level2", words: [VocabularyWord(baseWord: "backpack", imageName: "backpack", translations: ["en": "backpack", "es": "mochila", "it": "zaino"]), VocabularyWord(baseWord: "sharpener", imageName: "sharpener", translations: ["en": "sharpener", "es": "sacapuntas", "it": "temperamatite"]), VocabularyWord(baseWord: "rubber", imageName: "rubber", translations: ["en": "rubber", "es": "borrador", "it": "gomma"]), VocabularyWord(baseWord: "glue", imageName: "glue", translations: ["en": "glue", "es": "pegamento", "it": "colla"])])

var level3_data = Level(title: "level3", words: [VocabularyWord(baseWord: "carrot", imageName: "carrot", translations: ["en": "carrot", "es": "zanahoria", "it": "carota"]), VocabularyWord(baseWord: "pear", imageName: "pear", translations: ["en": "pear", "es": "pera", "it": "pera"]), VocabularyWord(baseWord: "banana", imageName: "banana", translations: ["en": "banana", "es": "plátano", "it": "banana"]), VocabularyWord(baseWord: "tomato", imageName: "tomato", translations: ["en": "tomato", "es": "tomate", "it": "pomodoro"])])


var level4_data = Level(title: "level3", words: [VocabularyWord(baseWord: "carrot", imageName: "carrot", translations: ["en": "carrot", "es": "zanahoria", "it": "carota"]), VocabularyWord(baseWord: "pear", imageName: "pear", translations: ["en": "pear", "es": "pera", "it": "pera"]), VocabularyWord(baseWord: "banana", imageName: "banana", translations: ["en": "banana", "es": "plátano", "it": "banana"]), VocabularyWord(baseWord: "tomato", imageName: "tomato", translations: ["en": "tomato", "es": "tomate", "it": "pomodoro"])])


var level5_data = Level(title: "level3", words: [VocabularyWord(baseWord: "carrot", imageName: "carrot", translations: ["en": "carrot", "es": "zanahoria", "it": "carota"]), VocabularyWord(baseWord: "pear", imageName: "pear", translations: ["en": "pear", "es": "pera", "it": "pera"]), VocabularyWord(baseWord: "banana", imageName: "banana", translations: ["en": "banana", "es": "plátano", "it": "banana"]), VocabularyWord(baseWord: "tomato", imageName: "tomato", translations: ["en": "tomato", "es": "tomate", "it": "pomodoro"])])
