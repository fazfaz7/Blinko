//
//  CompleteView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 28/05/25.
//

import SwiftUI

struct CompleteView: View {
    // Colors for the cards
    let colors: [Color] = [
        .orangeBlinko, .pinkBlinko, .lilaBlinko, .purpleBlinko,
    ]
    let colorCounter: Int = 0
    
    // Current level
    var level: Level = level1_data
    
    // Speech View Model to handle the speech-to-text feature.
    @StateObject private var speechViewModel = TextToSpeechViewModel(
        textToSpeechService: TextToSpeechService())
    
    @State private var showMoon = false
    @State private var showPlanet = false
    @State private var showCards = false
    @State private var showStar = false
    @State private var showNext = false
    @State private var showConfetti = false
    
    @State private var mascotMood: MascotMood = .happy
   
    @ObservedObject var userProgress: UserProgress
    var onExit: () -> Void
    
    
    var lastMinigame: Bool = false
    @AppStorage("selectedLanguage") var langCode: String = "es"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.darkBlue.ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Image("BluePlanet")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(1.85)
                        .frame(width: geometry.size.width)
                        .offset(y: showPlanet ? geometry.size.height : geometry.size.height + 400)
                        .animation(.easeOut(duration: 0.8), value: showPlanet)
                    
                }
                
                if showConfetti {
                    LottieView(filename: "StelleBack", loopMode: .loop)
                        .allowsHitTesting(false)
                        .transition(.scale)
                        .ignoresSafeArea()
                }
                
                VStack {
                    Image("luna")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.height/2.5)
                        .offset(y: showMoon ? 0 : -geometry.size.height/2)
                        .animation(.easeOut(duration: 0.8), value: showMoon)
                    
                    
                    HStack {
                        ForEach(0..<4, id: \.self) { index in
                            
                            let item = level.words[index]
                            let cardColor = colors[index]
                            
                            
                            CardView(
                                cardSize: geometry.size.width * 0.2,
                                imageName: item.imageName,
                                label: item.translations[
                                    langCode]!,
                                cardColor: cardColor
                            ).padding(.horizontal)
                            
                                .onTapGesture {
                                    speechViewModel.speak(text: item.translations[langCode]!, language: langCode)
                                }
                            
                        }
                    }.padding()
                        .opacity(showCards ? 1 : 0)
                        .animation(.easeOut(duration: 0.7), value: showCards)
                    
                    if showNext {
                        HStack{
                            Spacer()
                            
                            Button {
                                onExit()
                                if lastMinigame {
                                    userProgress.markStageCompleted(.invertedTH, for: level)
                                }
                            } label: {
                                HStack(spacing: 8) {
                                    Text("Next")
                                        .font(.custom("Baloo2-Bold", size: 32))
                                }
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.tealBlinko)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(radius: 5)
                                .padding(.top,30)
                                
                            }
                        }
                        .padding(.trailing, 50)
                        
                    }
                    
                    Spacer()
                }
                
                if showStar {
                    VStack {
                        Spacer()
                        HStack {
                            
                            MascotView(mood: mascotMood, width: 350, height: 350)
                                .offset(x:0, y:40)
                            
                        }
                    }
                    .ignoresSafeArea()
                }
                
                
            }.ignoresSafeArea()
        }.onAppear {
            // Sequence: moon -> planet -> cards -> star
            withAnimation(.easeOut(duration: 1)) {
                showMoon = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showPlanet = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.easeOut(duration: 0.7)) {
                        showCards = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                            showStar = true
                            showConfetti = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                            withAnimation {
                                showNext = true
                            }
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    CompleteView(level: level1_data,  userProgress: UserProgress(), onExit: {})
}
