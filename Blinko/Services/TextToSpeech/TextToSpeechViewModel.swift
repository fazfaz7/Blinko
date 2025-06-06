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

class TextToSpeechService: NSObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    private var isSpeaking = false
    private var isPrepared = false
        
        override init() {
            super.init()
            synthesizer.delegate = self
            prepareTTS()
        }
        
        private func prepareTTS() {
            // Speak an empty string silently to warm up the engine
            let utterance = AVSpeechUtterance(string: "")
            utterance.volume = 0
            synthesizer.speak(utterance)
            isPrepared = true
        }

    func speak(text: String, language: String) {
        guard !isSpeaking else { return }
        isSpeaking = true

        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0

        if language == "it" {
            utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
        } else if language == "es" {
            utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }

        synthesizer.speak(utterance)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}

