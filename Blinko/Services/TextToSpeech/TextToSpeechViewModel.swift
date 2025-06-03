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
    @Published var isSpeaking: Bool = false // 👈 Published for your View

    init(textToSpeechService: TextToSpeechService) {
        self.textToSpeechService = textToSpeechService

        // Bind the service's status callback
        textToSpeechService.onSpeakingStatusChanged = { [weak self] status in
            DispatchQueue.main.async {
                self?.isSpeaking = status
            }
        }
    }

    func speak(text: String, language: String) {
        textToSpeechService.speak(text: text, language: language)
    }
}

class TextToSpeechService: NSObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    var onSpeakingStatusChanged: ((Bool) -> Void)? // 👈 Add this
    private var isPrepared = false

    override init() {
        super.init()
        synthesizer.delegate = self
        prepareTTS()
    }

    private func prepareTTS() {
        let utterance = AVSpeechUtterance(string: "")
        utterance.volume = 0
        synthesizer.speak(utterance)
        isPrepared = true
    }

    func speak(text: String, language: String) {
        guard !synthesizer.isSpeaking else { return }

        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0

        switch language {
        case "it": utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
        case "es": utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        default:   utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }

        onSpeakingStatusChanged?(true) // ✅ Notify start
        synthesizer.speak(utterance)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        onSpeakingStatusChanged?(false) // ✅ Notify end
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        onSpeakingStatusChanged?(false)
    }
}

