//
//  BlinkoApp.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 16/05/25.
//

import SwiftUI

@main
struct BlinkoApp: App {
    var body: some Scene {
        WindowGroup {
            let sampleWords = [VocabularyWord(baseWord: "computer", imageName: "computer", translations: ["en": "computer", "es": "computadora", "it": "computer"]), VocabularyWord(baseWord: "phone", imageName: "telefono", translations: ["en": "phone", "es": "teléfono", "it": "telefono"]), VocabularyWord(baseWord: "wallet", imageName: "portafoglio", translations: ["en": "wallet", "es": "cartera", "it": "portafoglio"]), VocabularyWord(baseWord: "keys", imageName: "chiavi", translations: ["en": "keys", "es": "llaves", "it": "chiavi"])]
            
            ImageMatchingView(words: sampleWords)
        }
    }
}
