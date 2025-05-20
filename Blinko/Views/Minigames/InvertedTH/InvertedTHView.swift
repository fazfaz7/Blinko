//
//  InvertedTHView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 17/05/25.
//

import SwiftUI

struct InvertedTHView: View {
    // View Model of ML that manages the object-detection part.
    @State private var viewModel = MLViewModel()

    // The only data that needs to be passed to the THView is the array of 4 objects. With shuffled order.
    let levelObjects: [VocabularyWord] = level1.words.shuffled()

    // Index of the object that needs to be found in the specific moment.
    @State private var currentIndex: Int = 0

    // Indexes of the objects that have already been found.
    @State private var foundIndexes: Set<Int> = []

    // Variable used to store the last object found and display it in a big size.
    @State private var lastObjectFound: VocabularyWord? = nil

    // Control variable that displays the card whenever the user finds an object.
    @State private var showObject: Bool = false

    // Speech View Model to handle the speech-to-text feature.
    @StateObject private var speechViewModel = TextToSpeechViewModel(
        textToSpeechService: TextToSpeechService())

    // Colors array for the cards.
    let colors: [Color] = [
        .orangeBlinko, .pinkBlinko, .lilaBlinko, .purpleBlinko,
    ]

    // Variable to store the color of the card of the last object discovered.
    @State private var lastObjectColor: Color = .orangeBlinko

    var body: some View {
        ZStack {
            // View of the Camera, behind everything.
            CameraView(image: $viewModel.currentFrame)

            VStack {
                // If all the objects have been scanned, the scanner disappears. It starts glowing if it sees ONLY the current object.
                // Also, it disappears whenever a big card is on the screen.
                if currentIndex < levelObjects.count && !showObject {
                    Image("ScannerImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 700)
                        .shadow(
                            color: viewModel.detectedObject.lowercased()
                                == levelObjects[currentIndex].translations[
                                    "en"]!
                                ? .yellow : .clear, radius: 40)
                }
            }

            // If showObject is now true, then the cards and the camera button disappear.
            if !showObject {
                HStack {
                    Spacer()

                    // Button to capture the object found. Disabled if the user is not finding anything.
                    Button {
                        if currentIndex < levelObjects.count,
                            viewModel.detectedObject.lowercased()
                                == levelObjects[
                                    currentIndex
                                ].translations["en"]!
                        {
                            lastObjectFound = levelObjects[currentIndex]
                            lastObjectColor = colors[currentIndex]
                            withAnimation {
                                showObject = true
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
            if !showObject {
                // Objects
                HStack {
                    VStack {
                        ForEach(0..<4, id: \.self) { index in

                            let item = levelObjects[index]

                            Spacer()
                            CardView(
                                cardSize: 120,
                                imageName: item.imageName,
                                label: item.translations["en"] ?? "",
                                cardColor: colors[index],
                                isSilhouette: foundIndexes.contains(index)
                                    ? false : true
                            )
                            .overlay {

                                if foundIndexes.contains(index) {

                                } else if currentIndex != index {
                                    RoundedRectangle(cornerRadius: 10)
                                }

                            }

                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding()
                    Spacer()
                }
            }

            
            // If the variable showObject is true, then we show the card in a big size along with its pronunciation.
            if showObject {

                if let object = lastObjectFound {
                    CardView(
                        cardSize: 350,
                        imageName: object.imageName,
                        label: object.translations["en"] ?? "",
                        cardColor: lastObjectColor
                    ).onTapGesture {
                        speechViewModel.speak(
                            text: object.translations["en"]!,
                            language: "English")
                    }.onAppear {
                        speechViewModel.speak(
                            text: object.translations["en"]!,
                            language: "English")
                    }

                }

            }

            if foundIndexes.count == 4 {
                Image("GoodJob")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 800)
            }

        }.ignoresSafeArea()
            .onTapGesture {
                
                if showObject {
                    withAnimation {
                        showObject = false
                        foundIndexes.insert(currentIndex)
                    }
                    currentIndex += 1
                }
            }

    }
}

#Preview {
    InvertedTHView()
}
