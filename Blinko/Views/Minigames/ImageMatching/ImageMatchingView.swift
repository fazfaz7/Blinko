import SwiftUI
import AVFoundation

struct ImageMatchingView: View {
    let level: Level
    let colors: [Color] = [.orangeBlinko, .pinkBlinko, .lilaBlinko, .purpleBlinko]
    
    // Track the remaining words in the game
    @State private var remainingWords: [VocabularyWord]
    
    // The word the user has to tap
    @State private var targetWord: VocabularyWord?
    
    // Used by the shake animation
    @State private var wrongTapTriggers: [UUID: CGFloat] = [:]
    
    // Map the colors to the index, so they don't shift
    @State private var colorMap: [UUID: Color] = [:]
    
    // Track the status of the game
    @State private var isGameFinished = false
    
    // Overlay of the card when it is correctly selected
    @State private var correctWordOverlay: VocabularyWord?
    
    // Track mascot mood changes
    @State private var mascotMood: MascotMood = .normal
    
    @State private var showConfetti = false
    
    // TextToSpeech viewModel to prompt words
    @StateObject private var SpeechViewModel = TextToSpeechViewModel(
        textToSpeechService: TextToSpeechService())
    
    // Closure used to go to the next minigame. (Image Matching)
    @ObservedObject var userProgress: UserProgress
    var onNext: () -> Void

    init(level: Level,  userProgress: UserProgress, onNext: @escaping () -> Void) {
        self.level = level
        _remainingWords = State(initialValue: level.words)

        var map: [UUID: Color] = [:]
        for (index, word) in level.words.enumerated() {
            let color = colors[index % colors.count]
            map[word.id] = color
        }
        _colorMap = State(initialValue: map)
       
       self.userProgress = userProgress
        self.onNext = onNext
        
    }
    
    var body: some View {
        ZStack {
            if showConfetti {
                LottieView(filename: "confetti", loopMode: .loop)
                    .frame(width: 800, height: 800)
                    .allowsHitTesting(false)
                    .transition(.scale)
            }
            
            VStack(spacing: 30) {
                Spacer()
                
                // Blinko animation after the game has ended
                if(isGameFinished){
                 
                 Button {
                 userProgress.markStageCompleted(.memoryGame, for: level)
                 onNext()
                 } label: {
                 Text("Next Game")
                 .padding()
                 .foregroundStyle(.white)
                 .background(RoundedRectangle(cornerRadius: 10).fill(.blue))
                 
                 }
                 }
                
                // List the cards
                HStack(spacing: 30) {
                    ForEach(remainingWords, id: \.id) { word in
                        let color = colorMap[word.id] ?? .gray
                        CardView(cardSize: 240, imageName: word.imageName, withLabel: true, label: word.baseWord, cardColor: color)
                            .modifier(Shake(animatableData: wrongTapTriggers[word.id, default: 0]))
                        // Every time user tap a card it will trigger audio and check if it's the right card
                            .onTapGesture {
                                guard correctWordOverlay == nil else { return }
                                SpeechViewModel.speak(text: word.baseWord, language: "English")
                                checkAnswer(selected: word)
                            }
                    }
                    
                }
                .padding(.horizontal)
                
                // Button to show the target word
                if !isGameFinished, let word = targetWord {
                    Button(action: {
                        SpeechViewModel.speak(text: word.baseWord, language: "English")
                    }) {
                        HStack(spacing: 8) {
                            Text(word.baseWord)
                                .font(.custom("Baloo2-Bold", size: 70))
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 90))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .foregroundColor(.tealBlinko)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(radius: 2)
                    }
                    
                }
             
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                        MascotView(mood: mascotMood)
                }
            }
            .ignoresSafeArea()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        
            // Overlay of the correct card when it is selected
            .overlay(
                ZStack {
                    if let word = correctWordOverlay {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .transition(.opacity)
                        
                        CardView(
                            cardSize: 300,
                            imageName: word.imageName,
                            withLabel: true,
                            label: word.baseWord,
                            cardColor: colorMap[word.id] ?? .gray
                        )
                        .transition(.scale(scale: 0.5).combined(with: .opacity))
                        
                        .zIndex(1)
                    }
                }
                    .animation(.easeOut(duration: 0.4), value: correctWordOverlay)
            )
            .background(Color.tealBlinko)
            .ignoresSafeArea()
            .onAppear {
                pickNewTarget()
            }
    }
    
    // Picks a new target from the remaining words, and prompt the audio
    func pickNewTarget() {
        if !remainingWords.isEmpty {
            targetWord = remainingWords.randomElement()
            if let word = targetWord {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    SpeechViewModel.speak(text: word.baseWord, language: "English")            }
            }
        } else {
            targetWord = nil
        }
    }
    
    // Check if the answer user selected is right
    func checkAnswer(selected: VocabularyWord) {
        if selected == targetWord {
            mascotMood = .wow  // Quick positive feedback
            correctWordOverlay = selected

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    remainingWords.removeAll { $0 == selected }
                    correctWordOverlay = nil
                    mascotMood = remainingWords.isEmpty ? .happy : .normal
                }
                if remainingWords.isEmpty {
                    isGameFinished = true
                    mascotMood = .happy
                    showConfetti = true
                } else {
                    pickNewTarget()
                }
            }
        } else {
            withAnimation {
                mascotMood = .angry  // Feedback for mistake
                wrongTapTriggers[selected.id, default: 0] += 1
            }
            
            // Reset mood back to normal after a moment
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if !remainingWords.isEmpty {
                    mascotMood = .normal
                }
            }
        }
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = amount * sin(animatableData * .pi * shakesPerUnit)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

#Preview {
    ImageMatchingView(level: level1, userProgress: UserProgress(), onNext: {})
}
