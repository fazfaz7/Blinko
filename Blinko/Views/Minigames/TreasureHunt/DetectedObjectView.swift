//
//  DetectedObjectView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 16/05/25.
//

import SwiftUI

// Sheet that appears when an object is detected.
struct DetectedObjectView: View {
    let object: VocabularyWord

    // ViewModel that manages the text-to-speech part.
    @StateObject private var viewModel = TextToSpeechViewModel(
        textToSpeechService: TextToSpeechService())
    
    // Index to know which is the card color.
    let index: Int

    let colors: [Color] = [
        .orangeBlinko, .pinkBlinko, .lilaBlinko, .purpleBlinko,
    ]

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            VStack(spacing: 30) {

                CardView(
                    cardSize: 300, imageName: object.imageName,
                    label: object.translations["en"]!, cardColor: colors[index])

            }
            .padding()
            // When the card appears, the name of the object in the language is said.
            .onAppear {
                viewModel.speak(
                    text: object.translations["en"]!, language: "English")
            }
        }
    }
}

#Preview {
    DetectedObjectView(
        object: VocabularyWord(
            baseWord: "wallet", imageName: "portafoglio",
            translations: [
                "en": "wallet", "es": "cartera", "it": "portafoglio2",
            ]), index: 0)
}
