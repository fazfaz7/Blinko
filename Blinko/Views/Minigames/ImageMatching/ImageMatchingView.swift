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
    let words: [VocabularyWord]
    let colors: [Color] = [.orangeBlinko, .pinkBlinko, .lilaBlinko, .purpleBlinko]
    
    @State private var remainingWords: [VocabularyWord]
    @State private var targetWord: VocabularyWord?
    @State private var wrongTapTriggers: [UUID: CGFloat] = [:]
    @State private var colorMap: [UUID: Color] = [:]
    @State private var showMascotJump = false
    @State private var mascotOffset: CGFloat = 0
    @State private var isJumping = false
    // Closure used to go to the next minigame. (Image Matching)
    var onNext: () -> Void
    

    
    init(words: [VocabularyWord], onNext: @escaping () -> Void) {
        self.words = words
        _remainingWords = State(initialValue: words)

        var map: [UUID: Color] = [:]
        for (index, word) in words.enumerated() {
            let color = colors[index % colors.count]
            map[word.id] = color
        }
        _colorMap = State(initialValue: map)
        self.onNext = onNext
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            HStack(spacing: 30) {
                ForEach(remainingWords, id: \.id) { word in
                    let color = colorMap[word.id] ?? .gray
                    CardView(cardSize: 240, imageName: word.imageName, withLabel: true, label: word.baseWord, cardColor: color)
                        .modifier(Shake(animatableData: wrongTapTriggers[word.id, default: 0]))
                        .onTapGesture {
                            speak(word: word.baseWord)
                            checkAnswer(selected: word)
                        }
                }

            }
            .padding(.horizontal)
            
            if let word = targetWord {
                Button(action: {
                    speak(word: word.baseWord)
                }) {
                    HStack(spacing: 8) {
                        //Text(word.baseWord)
                        //    .font(.custom("Baloo2-Bold", size: 70))
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
                        onNext()
                    } label: {
                        Text("Next Game")
                            .padding()
                            .foregroundStyle(.white)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.blue))
                    
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.tealBlinko)
        .ignoresSafeArea()
        .onAppear {
            pickNewTarget()
        }
    }
    
    func pickNewTarget() {
        if !remainingWords.isEmpty {
            targetWord = remainingWords.randomElement()
            if let word = targetWord {
                speak(word: word.baseWord)
            }
        } else {
            targetWord = nil
        }
    }
    
    func checkAnswer(selected: VocabularyWord) {
        if selected == targetWord {
            withAnimation{
                remainingWords.removeAll { $0 == selected }
            }
            if remainingWords.isEmpty {
                pickNewTarget()
                showMascotJump = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                pickNewTarget()
            }
        } else {
            // Trigger shake animation for the tapped card
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

    
    func speak(word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        AVSpeechSynthesizer().speak(utterance)
    }
}

#Preview {
   // ImageMatchingView(words: level1.words)
}
