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
    
    @State private var rotation1: Angle = .degrees(0)
    @State private var rotation2: Angle = .degrees(0)
    @State private var floatPhase = false

    
    // TextToSpeech viewModel to prompt words
    @StateObject private var SpeechViewModel = TextToSpeechViewModel(
        textToSpeechService: TextToSpeechService())
    
    // Closure used to go to the next minigame. (Image Matching)
    @ObservedObject var userProgress: UserProgress
    var onNext: () -> Void
    @AppStorage("selectedLanguage") var langCode: String = "es"
    
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
        
        if isGameFinished {
            CompleteView(level: level, userProgress: userProgress) {
                    userProgress.markStageCompleted(.memoryGame, for: level)
                    onNext()
                
            }
        } else {
            ZStack {
                // PLANETS BACKGROUND
                Image("planet2_image_matching")
                    .resizable()
                    .scaledToFill()
                    .rotationEffect(rotation1)
                    .offset(x: -500, y: -500)
                    .onAppear {
                        withAnimation(Animation.linear(duration: 60).repeatForever(autoreverses: false)) {
                            rotation1 = .degrees(360)
                        }
                    }
                
                Image("planet1_image_matching")
                    .resizable()
                    .scaledToFill()
                    .rotationEffect(rotation2)
                    .offset(x: 550, y: 500)
                    .onAppear {
                        withAnimation(Animation.linear(duration: 180).repeatForever(autoreverses: false)) {
                            rotation2 = .degrees(360)
                        }
                    }
                
                VStack(spacing: 100) {
                    Spacer()
                    
                    
                    
                    // List the cards
                    HStack(spacing: 30) {
                        ForEach(remainingWords, id: \.id) { word in
                            let color = colorMap[word.id] ?? .gray
                            CardView(
                                cardSize: 240,
                                imageName: word.imageName,
                                withLabel: true,
                                label: word.translations[langCode]!,
                                cardColor: color
                            )
                            .modifier(Shake(animatableData: wrongTapTriggers[word.id, default: 0]))
                            .offset(y: floatPhase ? -5 : 5)
                            .onTapGesture {
                                guard correctWordOverlay == nil else { return }
                                SpeechViewModel.speak(text: word.translations[langCode]!, language: langCode)
                                checkAnswer(selected: word)
                            }
                        }
                    }
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            floatPhase.toggle()
                        }
                    }
                    .onChange(of: $remainingWords.count) {
                        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            floatPhase.toggle()
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    
                    // Button to show the target word
                    if !isGameFinished, let word = targetWord {
                        Button(action: {
                            SpeechViewModel.speak(text: word.translations[langCode]!, language: langCode)
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.system(size: 60))
                                Text(word.translations[langCode]!)
                                    .font(.custom("Baloo2-Bold", size: 70))
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .foregroundColor(.darkBlueBlinko)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(radius: 2)
                        }
                        
                    }
                    
                    Spacer()
                }
                
                // Mascot
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        MascotView(mood: mascotMood, width: 450, height: 450)
                            .offset(x: 40, y: -150)
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
                            label: word.translations[langCode]!,
                            cardColor: colorMap[word.id] ?? .gray
                        )
                        .transition(.scale(scale: 0.5).combined(with: .opacity))
                        
                        .zIndex(1)
                    }
                }
                    .animation(.easeOut(duration: 0.4), value: correctWordOverlay)
            )
            .background(.darkBlueBlinko)
            .ignoresSafeArea()
            .onAppear {
                pickNewTarget()
            }
            .statusBarHidden() 
        }
    }
    
    // Picks a new target from the remaining words, and prompt the audio
    func pickNewTarget() {
        if !remainingWords.isEmpty {
            targetWord = remainingWords.randomElement()
            if let word = targetWord {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    SpeechViewModel.speak(text: word.translations[langCode]!, language: langCode)            }
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
                    
                    withAnimation {
                        isGameFinished = true
                    }
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
    ImageMatchingView(level: level1_data, userProgress: UserProgress(), onNext: {})
}
