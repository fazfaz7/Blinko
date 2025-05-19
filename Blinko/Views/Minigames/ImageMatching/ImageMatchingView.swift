import SwiftUI
import AVFoundation

struct ImageMatchingView: View {
    let words: [VocabularyWord]

    @State private var targetWord: VocabularyWord? = nil
    @State private var feedback: String = ""

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            HStack(spacing: 30) {
                ForEach(words) { word in
                    CardView(cardSize: 200, imageName: word.imageName, label: word.baseWord)
                        .onTapGesture {
                            checkAnswer(selected: word)
                        }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)

            if let word = targetWord {
                VStack(spacing: 20) {
                    Text(word.baseWord)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Button("🔊 Listen Again") {
                        speak(word: word.baseWord)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }

            if !feedback.isEmpty {
                Text(feedback)
                    .font(.headline)
                    .foregroundColor(feedback == "Correct!" ? .green : .red)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.purpleBlinko)
        .ignoresSafeArea()
        .onAppear {
            pickNewTarget()
        }
    }

    func pickNewTarget() {
        targetWord = words.randomElement()
        feedback = ""
        if let word = targetWord {
            speak(word: word.baseWord)
        }
    }

    func checkAnswer(selected: VocabularyWord) {
        feedback = (selected == targetWord) ? "Correct!" : "Try again!"
    }

    func speak(word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        AVSpeechSynthesizer().speak(utterance)
    }
}



#Preview {
        let sampleWords = level1.words
    
    ImageMatchingView(words: sampleWords)
}
