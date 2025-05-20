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
    let levelObjects: [VocabularyWord] = level2.words
    

    var body: some View {
        ZStack {

            // View of the Camera, behind everything.
            CameraView(image: $viewModel.currentFrame)

            // 4 objects on the left of the screen.
            ObjectsView(unlockedItems: unlockedItems)

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
                                detectedObject = levelObjects[index]
                                detectedObjectIndex = index
                                unlockedItems.insert(viewModel.detectedObject.lowercased())
                                showSheet = true
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

        }.ignoresSafeArea()
            // Sheet with the data of the detected object that comes up when the user clicks on the camera.
            .sheet(isPresented: $showSheet) {
                DetectedObjectView(object: detectedObject!, index: detectedObjectIndex)
            }
    }
}

#Preview {
    TreasureHuntView()
}

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
                            label: item.translations["en"] ?? "",
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
