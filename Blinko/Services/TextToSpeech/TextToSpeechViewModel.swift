//
//  TextToSpeechViewModel.swift
//  Twinko
//
//  Created by Adrian Emmanuel Faz Mercado on 12/05/25.
//

import Foundation
import AVFoundation

class TextToSpeechViewModel: ObservableObject {
    private let textToSpeechService: TextToSpeechService

    init(textToSpeechService: TextToSpeechService) {
        self.textToSpeechService = textToSpeechService
    }

    func speak(text: String, language: String) {
        textToSpeechService.speak(text: text, language: language)
    }
}

class TextToSpeechService {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(text: String, language: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0

        if language.contains("Italian") {
            utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
        } else if language.contains("Spanish") {
            utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }

        synthesizer.speak(utterance)
    }
}
