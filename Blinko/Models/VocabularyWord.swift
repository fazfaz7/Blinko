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



var level1 = Level(title: "Level 1", words: [VocabularyWord(baseWord: "pencil", imageName: "pencil", translations: ["en": "pencil", "es": "lápiz", "it": "matita"]), VocabularyWord(baseWord: "notebook", imageName: "notebook", translations: ["en": "notebook", "es": "libreta", "it": "quaderno"]), VocabularyWord(baseWord: "ruler", imageName: "ruler", translations: ["en": "ruler", "es": "regla", "it": "rullino"]), VocabularyWord(baseWord: "backpack", imageName: "backpack", translations: ["en": "backpack", "es": "mochila", "it": "zaino"])])

var level2 = Level(title: "Level 2", words: [VocabularyWord(baseWord: "computer", imageName: "computer", translations: ["en": "computer", "es": "computadora", "it": "computer"]), VocabularyWord(baseWord: "phone", imageName: "telefono", translations: ["en": "phone", "es": "teléfono", "it": "telefono"]), VocabularyWord(baseWord: "wallet", imageName: "portafoglio", translations: ["en": "wallet", "es": "cartera", "it": "portafoglio"]), VocabularyWord(baseWord: "keys", imageName: "chiavi", translations: ["en": "keys", "es": "llaves", "it": "chiavi"])])
