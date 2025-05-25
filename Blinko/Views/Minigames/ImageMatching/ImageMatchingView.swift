import SwiftUI
import AVFoundation

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = amount * sin(animatableData * .pi * shakesPerUnit)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

struct ImageMatchingView: View {
    let level: Level
    let colors: [Color] = [.orangeBlinko, .pinkBlinko, .lilaBlinko, .purpleBlinko]
    
    // Track the remaining words still in the game
    @State private var remainingWords: [VocabularyWord]
    
    // The word the user has to tap
    @State private var targetWord: VocabularyWord?
    
    // Used by the shake animation
    @State private var wrongTapTriggers: [UUID: CGFloat] = [:]
    
    // Map the colors to the index, so they don't shift
    @State private var colorMap: [UUID: Color] = [:]
    
    // Show Blinko animation after the complete level
    @State private var showMascotJump = false
    
    // Useful for Blinko jumping
    @State private var mascotOffset: CGFloat = 0
    
    // Useful for Blinko jumping?
    @State private var isJumping = false
    
    // S
    @State private var correctWordOverlay: VocabularyWord?
    
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
        VStack(spacing: 30) {
            Spacer()
            
            // Blinko animation after the game has ended
            if(showMascotJump){
                    Image("blinko2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .offset(y: mascotOffset)
                        .onAppear {
                            withAnimation {
                                startJumping()
                            }
                        }
                    
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
                        .onTapGesture {
                            // Every time user tap a card it will trigger audio and check if it's the right card
                            guard correctWordOverlay == nil else { return }
                                SpeechViewModel.speak(text: word.baseWord, language: "English")
                                checkAnswer(selected: word)
                        }
                }

            }
            .padding(.horizontal)
            
            // Button to show the target word
            if let word = targetWord {
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
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                SpeechViewModel.speak(text: word.baseWord, language: "English")            }
        } else {
            targetWord = nil
        }
    }
    
    // Check if the answer user selected is right
    func checkAnswer(selected: VocabularyWord) {
        if selected == targetWord {
            correctWordOverlay = selected
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    remainingWords.removeAll { $0 == selected }
                    correctWordOverlay = nil
                }
                if remainingWords.isEmpty {
                    showMascotJump = true
                } else {
                    pickNewTarget()
                }
            }
        } else {
            withAnimation {
                wrongTapTriggers[selected.id, default: 0] += 1
            }
        }
    }


    func startJumping() {
        guard !isJumping else { return }
        isJumping = true
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            withAnimation(.interpolatingSpring(stiffness: 150, damping: 5)) {
                mascotOffset = -30
            }
            
            // Return to original position
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    mascotOffset = 0
                }
            }
            
            // Stop after some time (optional)
            if !showMascotJump {
                timer.invalidate()
                isJumping = false
            }
        }
    }

}

#Preview {
    ImageMatchingView(level: level1, userProgress: UserProgress(), onNext: {})
}
