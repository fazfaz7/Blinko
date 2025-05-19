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

    var body: some View {
        ZStack {
            // View of the Camera, behind everything.
            CameraView(image: $viewModel.currentFrame)

            VStack {
                // If all the objects have been scanned, the scanner disappears. It starts glowing if it sees ONLY the current object.
                if currentIndex < levelObjects.count {
                    Image("ScannerImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 700)
                        .shadow(
                            color: viewModel.detectedObject.lowercased()
                                == levelObjects[currentIndex].translations[
                                    "it"]!
                                ? .yellow : .clear, radius: 40)
                }
            }

            HStack {
                Spacer()

                // Button to capture the object found. Disabled if the user is not finding anything.
                Button {
                    if currentIndex < levelObjects.count,
                        viewModel.detectedObject.lowercased() == levelObjects[
                            currentIndex
                        ].translations["it"]!
                    {
                        foundIndexes.insert(currentIndex)
                        currentIndex += 1
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

            // Objects
            HStack {
                VStack {
                    ForEach(0..<4, id: \.self) { index in

                        let item = levelObjects[index]

                        Spacer()
                        CardView(
                            cardSize: 120,
                            imageName: item.imageName,
                            label: item.translations["en"] ?? ""
                        )
                        .overlay {

                            if foundIndexes.contains(index) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.green)
                                    .overlay {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.clear)
                                    }

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

            if foundIndexes.count == 4 {
                Image("GoodJob")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 800)
            }

        }.ignoresSafeArea()

    }
}

#Preview {
    InvertedTHView()
}
