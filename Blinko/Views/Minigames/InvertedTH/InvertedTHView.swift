//
//  InvertedTHView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 17/05/25.
//

import SwiftUI

struct InvertedTHView: View {
    // View Model of ML that manages the object-detection part.
    @State private var viewModel: MLViewModel
    
    // The only data that needs to be passed to the THView is the array of 4 objects. With shuffled order.
    var levelObjects: [VocabularyWord]

    // Current level
    let level: Level
    
    // Index of the object that needs to be found in the specific moment.
    @State private var currentIndex: Int = 0

    // Indexes of the objects that have already been found.
    @State private var foundIndexes: Set<Int> = []

    // Variable used to store the last object found and display it in a big size.
    @State private var lastObjectFound: VocabularyWord? = nil //VocabularyWord(baseWord: "pencil", imageName: "pencil", translations: ["en": "pencil", "es": "lápiz", "it": "matita"])

    // Control variable that displays the card whenever the user finds an object.
    @State private var showObjectFound: Bool = false

    // Speech View Model to handle the speech-to-text feature.
    @StateObject private var speechViewModel = TextToSpeechViewModel(
        textToSpeechService: TextToSpeechService())

    // Colors array for the cards.
    let colors: [Color] = [
        .orangeBlinko, .pinkBlinko, .lilaBlinko, .purpleBlinko,
    ]

    // Variable to store the color of the card of the last object discovered.
    @State private var lastObjectColor: Color = .orangeBlinko
    
    // Control variable that displays the card whenever the user finds an object.
    @State private var showObject: Bool = false
    
    @State private var clickedObject: VocabularyWord? = nil
    @AppStorage("selectedLanguage") var langCode: String = "es"
   
    
    var onNext: () -> Void
    @EnvironmentObject var userProgress: UserProgress
    
    init(level: Level, onNext: @escaping () -> Void ) {
        self.level = level
        self.levelObjects = level.words.shuffled()
        self.onNext = onNext
        _viewModel = State(initialValue: MLViewModel(modelName: level.title))
    }
    
    var body: some View {
        ZStack {
            // View of the Camera, behind everything.
            CameraView(image: $viewModel.currentFrame)

            VStack {
                // If all the objects have been scanned, the scanner disappears. It starts glowing if it sees ONLY the current object.
                // Also, it disappears whenever a big card is on the screen.
                if currentIndex < levelObjects.count && !showObjectFound && !showObject {
                    Image(viewModel.detectedObject.lowercased()
                          == levelObjects[currentIndex].baseWord
                              ? "ScannerYellow" : "ScannerBlue")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 600)
                        .shadow(
                            color: viewModel.detectedObject.lowercased()
                            == levelObjects[currentIndex].baseWord
                            ? .yellow.opacity(0.9) : .clear,
                            radius: viewModel.detectedObject.lowercased()
                            == levelObjects[currentIndex].baseWord ? 30 : 0)
                }
            }
            

            // If showObject is now true, then the cards and the camera button disappear.
            if !showObjectFound && !showObject{
                HStack {
                    Spacer()

                    // Button to capture the object found. Disabled if the user is not finding anything.
                    Button {
                        if currentIndex < levelObjects.count,
                            viewModel.detectedObject.lowercased()
                                == levelObjects[
                                    currentIndex
                                ].baseWord
                        {
                            lastObjectFound = levelObjects[currentIndex]
                            lastObjectColor = colors[currentIndex]
                            withAnimation {
                                showObjectFound = true
                            }

                        }

                    } label: {
                        ZStack {

                            Circle()
                                .fill(.white)
                                .frame(width: 110)
                                .padding(25)

                            Circle()
                                .fill(.black)
                                .frame(width: 100)
                                .padding(25)

                            Circle()
                                .fill(.white)
                                .frame(width: 90)
                                .padding(25)

                        }
                    }

                }
            }

            // If showObject is now true, then the cards and the camera button disappear.
            if !showObjectFound && !showObject {
                // Objects
                HStack {
                    VStack {
                        ForEach(0..<4, id: \.self) { index in

                            let item = levelObjects[index]

                            Spacer()
                            CardView(
                                cardSize: 120,
                                imageName: item.imageName,
                                label: item.translations[langCode] ?? "",
                                cardColor: colors[index],
                                isSilhouette: !foundIndexes.contains(index) // Simplified logic
                            )
                            .grayscale(foundIndexes.contains(index) ? 0 : 1)
                            .overlay {

                                if foundIndexes.contains(index) {

                                } else if currentIndex != index {
                                    Image("CardBack")
                                        .resizable()
                                        .scaledToFill()
                                }

                            }
                            .onTapGesture {
                                if !foundIndexes.contains(index) && index <= currentIndex {
                                    clickedObject = item
                                    withAnimation {
                                        showObject = true
                                    }
                                }
                            }

                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding()
                    Spacer()
                }
            }
            
            if showObject || showObjectFound {
                  Color.black.opacity(0.4)
                      .ignoresSafeArea()
                      .transition(.opacity)
              }


            
            // If the variable showObject is true, then we show the card in a big size along with its pronunciation.
            if showObjectFound {

                if let object = lastObjectFound {
                    CardView(
                        cardSize: 350,
                        imageName: object.imageName,
                        label: object.translations[langCode] ?? "",
                        cardColor: lastObjectColor
                    ).onTapGesture {
                        speechViewModel.speak(
                            text: object.translations[langCode]!,
                            language: langCode)
                    }
                    VStack{
                        
                        HStack{
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    foundIndexes.insert(currentIndex)
                                    currentIndex += 1
                                    showObjectFound = false
                                }
                            }) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .resizable()
                                    .frame(width: 130, height: 130)
                                    .foregroundColor(.white)
                                    .background(Color.tealBlinko)
                                    .clipShape(Circle())
                                    .padding(50)
                                
                                
                            }
                            .padding()
                            
                        }
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            MascotView(
                                mood: speechViewModel.isSpeaking ? .wow : .normal,
                                width: speechViewModel.isSpeaking ? 400 : 300,
                                height: speechViewModel.isSpeaking ? 400 : 300
                            )
                            .animation(.easeInOut(duration: 0.1), value: speechViewModel.isSpeaking)
                            .onTapGesture {
                                speechViewModel.speak(
                                    text: object.translations[langCode]!,
                                    language: langCode
                                )
                            }
                            .onAppear {
                                speechViewModel.speak(
                                    text: object.translations[langCode]!,
                                    language: langCode
                                )
                            }

                            Spacer()
                            
                        }
                    }
                    .padding()
                    .ignoresSafeArea()
                    
                    
                }

            }
            
            if showObject {
                
                if let object = clickedObject {
                    CardView(
                        cardSize: 350,
                        imageName: object.imageName,
                        label: object.translations[langCode] ?? "",
                        isSilhouette: true,
                        grayCard: true
                    ).onTapGesture {
                        speechViewModel.speak(
                            text: object.translations[langCode]!,
                            language: langCode)
                    }.onAppear {
                        speechViewModel.speak(
                            text: object.translations[langCode]!,
                            language: langCode)
                    }
                    

                }
                
            }
            
            if currentIndex < levelObjects.count && !showObjectFound && !showObject {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(
                            viewModel.detectedObject.lowercased()
                            == levelObjects[currentIndex].translations[
                                langCode]!
                            ? "Happy" : "Neutral"
                        )
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                    }
                }}

            if foundIndexes.count == 4 && !showObjectFound {
                CompleteView(level: level, onExit: onNext, lastMinigame: true)
                    .environmentObject(userProgress)
                    .onAppear{
                        viewModel.cameraManager.stopSession()

                        
                    }
               
                
                 
            }
            
            // X button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        viewModel.cameraManager.stopSession()
                        onNext()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.red.opacity(0.8))
                                .frame(width: 70, height: 70)
                            Image(systemName: "xmark")
                                .font(.system(size: 40, weight: .black))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }.padding(25)
                }
                Spacer()
            }
            
        }.ignoresSafeArea()
            .onTapGesture {
                

                
                if showObject {
                    showObject = false
                }
                

            }
            .onDisappear {
                viewModel.cameraManager.stopSession()
                    }
            .statusBarHidden() 

    }
}

#Preview {
    InvertedTHView(level: level1_data,  onNext: {})
        .environmentObject(UserProgress())
}
