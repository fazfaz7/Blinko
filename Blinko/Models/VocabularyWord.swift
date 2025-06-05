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



var level1_data = Level(id: UUID(uuidString: "b731aec2-af9a-45d1-bd39-22b898c23ff2")!, title: "level1", words: [
    VocabularyWord(baseWord: "pencil", imageName: "pencil", translations: [
        "en": "pencil", "es": "lápiz", "it": "matita", "pt": "lápis", "ja": "えんぴつ"
    ]),
    VocabularyWord(baseWord: "ruler", imageName: "ruler", translations: [
        "en": "ruler", "es": "regla", "it": "righello", "pt": "régua", "ja": "ものさし"
    ]),
    VocabularyWord(baseWord: "rubber", imageName: "rubber", translations: [
        "en": "rubber", "es": "borrador", "it": "gomma", "pt": "borracha", "ja": "けしゴム"
    ]),
    VocabularyWord(baseWord: "backpack", imageName: "backpack", translations: [
        "en": "backpack", "es": "mochila", "it": "zaino", "pt": "mochila", "ja": "リュックサック"
    ])
])


var level2_data = Level(id: UUID(uuidString:"5f948f7c-3510-4234-a53c-870161517859")!,title: "level2", words: [
    VocabularyWord(baseWord: "pen", imageName: "pen", translations: [
        "en": "pen", "es": "pluma", "it": "penna", "pt": "caneta", "ja": "ペン"
    ]),
    VocabularyWord(baseWord: "glue", imageName: "glue", translations: [
        "en": "glue", "es": "pegamento", "it": "colla", "pt": "cola", "ja": "のり"
    ]),
    VocabularyWord(baseWord: "sharpener", imageName: "sharpener", translations: [
        "en": "sharpener", "es": "sacapuntas", "it": "temperamatite", "pt": "apontador", "ja": "えんぴつけずり"
    ]),
    VocabularyWord(baseWord: "notebook", imageName: "notebook", translations: [
        "en": "notebook", "es": "libreta", "it": "quaderno", "pt": "caderno", "ja": "ノート"
    ])
])


var level3_data = Level(id: UUID(uuidString: "4db58b6f-669b-43a6-9dd4-bfa52e28437d")!,title: "level3", words: [
    VocabularyWord(baseWord: "apple", imageName: "apple", translations: [
        "en": "apple", "es": "manzana", "it": "mela", "pt": "maçã", "ja": "りんご"
    ]),
    VocabularyWord(baseWord: "banana", imageName: "banana", translations: [
        "en": "banana", "es": "plátano", "it": "banana", "pt": "banana", "ja": "バナナ"
    ]),
    VocabularyWord(baseWord: "carrot", imageName: "carrot", translations: [
        "en": "carrot", "es": "zanahoria", "it": "carota", "pt": "cenoura", "ja": "にんじん"
    ]),
    VocabularyWord(baseWord: "egg", imageName: "egg", translations: [
        "en": "egg", "es": "huevo", "it": "uovo", "pt": "ovo", "ja": "たまご"
    ])
])


var level4_data = Level(id: UUID(uuidString: "7966ab55-89ed-4a1e-9f45-d1dea72b9ca2")!, title: "level4", words: [
    VocabularyWord(baseWord: "lemon", imageName: "lemon", translations: [
        "en": "lemon", "es": "limón", "it": "limone", "pt": "limão", "ja": "レモン"
    ]),
    VocabularyWord(baseWord: "potato", imageName: "potato", translations: [
        "en": "potato", "es": "papa", "it": "patata", "pt": "batata", "ja": "じゃがいも"
    ]),
    VocabularyWord(baseWord: "pear", imageName: "pear", translations: [
        "en": "pear", "es": "pera", "it": "pera", "pt": "pêra", "ja": "なし"
    ]),
    VocabularyWord(baseWord: "tomato", imageName: "tomato", translations: [
        "en": "tomato", "es": "tomate", "it": "pomodoro", "pt": "tomate", "ja": "トマト"
    ])
])



var level5_data = Level(id: UUID(uuidString: "65241189-dd37-474e-abe9-15e44ae431b6")!, title: "level5", words: [
    VocabularyWord(baseWord: "backpack", imageName: "backpack", translations: [
        "en": "backpack", "es": "mochila", "it": "zaino", "pt": "mochila", "ja": "リュックサック"
    ]),
    VocabularyWord(baseWord: "pen", imageName: "pen", translations: [
        "en": "pen", "es": "pluma", "it": "penna", "pt": "caneta", "ja": "ペン"
    ]),
    VocabularyWord(baseWord: "banana", imageName: "banana", translations: [
        "en": "banana", "es": "plátano", "it": "banana", "pt": "banana", "ja": "バナナ"
    ]),
    VocabularyWord(baseWord: "tomato", imageName: "tomato", translations: [
        "en": "tomato", "es": "tomate", "it": "pomodoro", "pt": "tomate", "ja": "トマト"
    ])
])



