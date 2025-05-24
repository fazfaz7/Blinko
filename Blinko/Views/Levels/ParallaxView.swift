//
//  ParallaxView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 24/05/25.
//

import SwiftUI

import SwiftUI

/*
// ➊ PreferenceKey to observe scroll offset
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
*/

struct ParallaxTestView: View {
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let screenSize = geo.size
            let totalWidth = screenSize.width * 2  // two “screens” worth
            
            ScrollView(.horizontal, showsIndicators: false) {
                ZStack {
                  // ── ➋ Simple placeholder background ───────────
                  Color.gray
                    .frame(width: totalWidth, height: screenSize.height)
                  
                  // ── ➌ Red = “far” (parallax 0) ────────────────
                  Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.red)
                    .position(
                      x: screenSize.width * 0.5,
                      y: screenSize.height * 0.3
                    )
                    .offset(x: -scrollOffset * (1 - 0.0))  // parallax = 0

                  // ── ➍ Green = “near” (parallax 1) ───────────
                  Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.green)
                    .position(
                      x: screenSize.width * 0.5,
                      y: screenSize.height * 0.7
                    )
                    .offset(x: -scrollOffset * (1 - 1.0))  // parallax = 1
                }
                .frame(width: totalWidth, height: screenSize.height)
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(
                                key: ScrollOffsetKey.self,
                                value: -proxy.frame(in: .named("scroll")).origin.x
                            )
                    }
                )
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetKey.self) { scrollOffset = $0 }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ParallaxTestView()
}
