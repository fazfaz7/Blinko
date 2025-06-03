//
//  TestView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 21/05/25.
//

import SwiftUI

struct MagicMovePositionExample: View {
    @Namespace private var animation
    @State private var moved = false

    var body: some View {
        VStack {
            if !moved {
                HStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green)
                        .frame(width: 100, height: 100)
                        .matchedGeometryEffect(id: "box", in: animation)
                    Spacer()
                }
                Spacer()
            } else {
                Spacer()
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green)
                        .frame(width: 100, height: 100)
                        .matchedGeometryEffect(id: "box", in: animation)
                }
            }

            Button("Move") {
                withAnimation(.spring()) {
                    moved.toggle()
                }
            }
            .padding(.top, 40)
        }
        .padding()
    }
}



#Preview {
    MagicMovePositionExample()
}
