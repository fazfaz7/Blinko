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
    var label: String = "Phone"
    var cardColor: Color = .pinkBlinko
    
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
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageCircle*0.65)
            }
            
            Text(label)
                .fontWeight(.heavy)
                .font(.system(size: labelFont))
                .frame(width: labelWidth)
                .fixedSize(horizontal: false, vertical: true) // Allow the text to wrap
                .minimumScaleFactor(0.5) // Allow text to shrink if needed
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
    }
}

#Preview {
    HStack{
        VStack(){
            CardView(cardSize: 120, imageName: level2.words[0].imageName, label: level2.words[0].baseWord)
        }
        Spacer()
    }.padding()

}

