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
    var onExit: () -> Void
    
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
                                    "en"]!,
                                cardColor: cardColor
                            ).padding(.horizontal)
                            
                                .onTapGesture {
                                    speechViewModel.speak(text: item.translations["en"]!, language: "English")
                                }
                            
                        }
                    }.padding()
                        .opacity(showCards ? 1 : 0)
                        .animation(.easeOut(duration: 0.7), value: showCards)
                    
                    if showNext {
                        
                        Button {
                            onExit()
                        } label: {
                            HStack(spacing: 8) {
                                Text("Next")
                                    .font(.custom("Baloo2-Bold", size: 28))
                            }
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.tealBlinko)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(radius: 5)
                            .padding(.top,30)
                            
                        }
                    }
                    Spacer()
                }
                

                        Spacer()
                
                        Image("happy_blinko")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width/2)
                            .offset(
                                    x: geometry.size.width/2.5,
                                    y: showStar ? geometry.size.height/3 : geometry.size.height * 1.2
                                )
                            .opacity(showStar ? 1 : 0)
                               .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showStar)
                 
                   
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
    CompleteView(onExit: {})
}
