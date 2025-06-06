//
//  CardView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 16/05/25.
//

import SwiftUI

struct CardView: View {
    var cardSize: CGFloat = 350
    var imageName: String = "telefono2"
    var withLabel: Bool = true
    var label: String = "Phone"
    var cardColor: Color = .pinkBlinko
    var isSilhouette: Bool = false
    var grayCard: Bool = false
    @AppStorage("selectedLanguage") var langCode: String = "es"
    
    var body: some View {
        // We are using dynamic sizing based on cardSize (for now)
        let imageCircle = cardSize * 0.77
        //let imageWidth = cardSize * 0.51
        let labelWidth = cardSize * 0.71
        let minLabelFont: CGFloat = 12
        let labelFont = max(cardSize * 0.14, minLabelFont) // ~50/350 but not smaller than 12
        let cornerRadius = cardSize * 0.071
        let spacing = cardSize * 0.11
        
        VStack(spacing: spacing) {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: imageCircle)
                
                // For this, we we'll always have the same size of images so it shouldn't be a problem in the future.
                Image(imageName)
                    .renderingMode(isSilhouette ? .template : .original) // Used to make the silhouette when needed.
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(isSilhouette ? .gray : .clear)
                    .frame(width: imageCircle*0.75)
                    .grayscale(grayCard ? 1 : 0)
            }
                Text(withLabel ? label : " ")
                    .fontWeight(.heavy)
                    .font(.custom("Baloo2-Bold", size: labelFont))
                    .frame(width: labelWidth)
                    .minimumScaleFactor(0.6) // Allow text to shrink if needed
                    .fixedSize(horizontal: false, vertical: true) // Allow the text to wrap
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(.white)
                    )
                    .foregroundStyle(.tealBlinko)
        }
        .frame(width: cardSize, height: cardSize * 1.43) // 500/350
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(cardColor)
        )
        .grayscale(grayCard ? 1 : 0)
    }
}

#Preview {
    HStack{
        VStack(){
            CardView(cardSize: 120, imageName: level1_data.words[0].imageName, label: "faz")
        }
        Spacer()
    }.padding()

}

