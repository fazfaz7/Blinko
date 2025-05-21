//
//  ContentView.swift
//  TreasureHuntView
//
//  Created by Adrian Emmanuel Faz Mercado on 26/04/25.
//
import SwiftUI

struct TreasureHuntView: View {
    // View Model of ML that manages the object-detection part.
    @State private var viewModel = MLViewModel()
    
    // Control variable to show the sheet whenever the user discovers an object.
    @State private var showSheet: Bool = false
    
    // Detected Object variable that holds a VocabularyWord object. It is nil whenever nothing is found.
    @State private var detectedObject: VocabularyWord? = nil
    
    // Index of the detected object in relation to its position in the array. It is used to know the color of the card when displaying it.
    @State private var detectedObjectIndex: Int = 0
    
    // Set of the objects that have already been unlocked.
    @State private var unlockedItems: Set<String> = []
    
    // The only data that needs to be passed to the THView is the array of 4 objects.
    let levelObjects: [VocabularyWord] = level1.words
    
    
    // Colors for the cards
    let colors: [Color] = [
        .orangeBlinko, .pinkBlinko, .lilaBlinko, .purpleBlinko,
    ]
    let colorCounter: Int = 0
    
    // Control variable that displays the card whenever the user finds an object.
    @State private var showObjectFound: Bool = false
    
    // Control variable that displays the card whenever the user finds an object.
    @State private var showObject: Bool = false
    
    @State private var clickedObject: VocabularyWord? = nil
    @State private var clickedObjectIndex: Int = 0
    
    // Speech View Model to handle the speech-to-text feature.
    @StateObject private var speechViewModel = TextToSpeechViewModel(
        textToSpeechService: TextToSpeechService())


    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                // View of the Camera, behind everything.
                CameraView(image: $viewModel.currentFrame)
                
                
                if !showObject && !showObjectFound {
                    // 4 objects on the left of the screen.
                    HStack {
                        VStack {
                            ForEach(0..<4, id: \.self) { index in
                                
                                let item = levelObjects[index]
                                let cardColor = colors[index]
                                
                                Spacer()
                                CardView(
                                    cardSize: geometry.size.width * 0.1,
                                    imageName: item.imageName,
                                    label: item.translations[unlockedItems.contains(item.translations["en"] ?? "") ? "en" : "it"] ?? "" ,
                                    cardColor: cardColor)
                                .grayscale(unlockedItems.contains(item.translations["en"] ?? "") ? 0 : 1)
                                .onTapGesture {
                                    withAnimation {
                                        clickedObject = item
                                        clickedObjectIndex = index
                                        showObject = true
                                    }
                                    
                                }
                                
                            }
                        }
                        .frame(maxHeight: .infinity)
                        .padding(geometry.size.width * 0.02)
                        Spacer()
                    }
                    
                    VStack {
                        Image("ScannerImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 700)
                        // The image glows if the user is detecting something.
                            .shadow(
                                color: viewModel.detectedObject != "none"
                                ? .yellow : .clear, radius: 40)
                    }
                    
                    HStack {
                        Spacer()
                        
                        // Button to capture the object found. Disabled if the user is not finding anything.
                        Button {
                            if viewModel.detectedObject != "none" {
                                
                                if let index = levelObjects.firstIndex(where: {
                                    $0.translations["en"]?.lowercased() == viewModel.detectedObject.lowercased()
                                }) {
                                    print("HOLA")
                                    detectedObject = levelObjects[index]
                                    detectedObjectIndex = index
                                    unlockedItems.insert(viewModel.detectedObject.lowercased())
                                    withAnimation {
                                        showObjectFound = true
                                    }
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
                    
                    // Blinko in the right bottom part of the screen!
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(
                                viewModel.detectedObject != "none"
                                ? "blinko2" : "blinko1"
                            )
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .padding(20)
                        }
                    }
                }
                
                if showObject {
                    
                    if let object = clickedObject {
                        CardView(
                            cardSize: 350,
                            imageName: object.imageName,
                            label: object.translations[unlockedItems.contains(object.baseWord) ? "en" : "it"] ?? "",
                            cardColor: colors[clickedObjectIndex],
                            grayCard: unlockedItems.contains(object.baseWord) ? false : true
                        ).onTapGesture {
                            speechViewModel.speak(
                                text: object.translations[unlockedItems.contains(object.baseWord) ? "en" : "it"]!,
                                language: unlockedItems.contains(object.baseWord) ? "English" : "Italian")
                        }.onAppear {
                            speechViewModel.speak(
                                text: object.translations[unlockedItems.contains(object.baseWord) ? "en" : "it"]!,
                                language: unlockedItems.contains(object.baseWord) ? "English" : "Italian")
                        }
                        

                    }
                    
                }
                
                // If the variable showObject is true, then we show the card in a big size along with its pronunciation.
                if showObjectFound {

                    if let object = detectedObject {
                        CardView(
                            cardSize: 350,
                            imageName: object.imageName,
                            label: object.translations["en"] ?? "",
                            cardColor: colors[detectedObjectIndex]
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
                
            }.ignoresSafeArea()
            // Sheet with the data of the detected object that comes up when the user clicks on the camera.
                .onTapGesture {
                    withAnimation {
                        showObject = false
                        showObjectFound = false
                    }
                }
        }
    }
}

#Preview {
    TreasureHuntView()
}





/*
// View that represents the column of objects that need to be found.
struct ObjectsView: View {
    // Set of objects that have been discovered. A Set so that the object is only registered once even if the kid tries to scan again the same object.
    let unlockedItems: Set<String>

    // Colors for the cards
    let colors: [Color] = [
        .orangeBlinko, .pinkBlinko, .lilaBlinko, .purpleBlinko,
    ]
    let colorCounter: Int = 0
    let levelObjects: [VocabularyWord] = level1.words

    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    ForEach(0..<4, id: \.self) { index in

                        let item = levelObjects[index]
                        let cardColor = colors[index]

                        Spacer()
                        CardView(
                            cardSize: geometry.size.width * 0.1,
                            imageName: item.imageName,
                            label: item.translations[unlockedItems.contains(item.translations["en"] ?? "") ? "en" : "it"] ?? "" ,
                            cardColor: cardColor)
                        .grayscale(unlockedItems.contains(item.translations["en"] ?? "") ? 0 : 1)
                        
                    }
                }
                .frame(maxHeight: .infinity)
                .padding(geometry.size.width * 0.02)
                Spacer()
            }
        }
    }
}
*/
