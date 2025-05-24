//
//  LevelsDesignView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 23/05/25.
//

import SwiftUI

// PreferenceKey (no change)
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// Reuse your Planet struct to represent a galaxy
struct Planet: Identifiable {
    let id        = UUID()
    let imageName: String
    let baseX:     CGFloat   // world X
    let baseY:     CGFloat   // world Y
    let size:      CGFloat
    let parallax:  CGFloat   // unused here, but fill in
}

struct LevelsDesignView: View {
    let repeatCount = 3
    @State private var galaxies: [Planet] = []

    var body: some View {
        GeometryReader { geo in
            let screenSize  = geo.size
            let uiImage     = UIImage(named: "SpaceBackground")!
            let aspectRatio = uiImage.size.width / uiImage.size.height
            let tileWidth   = screenSize.height * aspectRatio
            let totalWidth  = tileWidth * CGFloat(repeatCount)

            ScrollView(.horizontal, showsIndicators: false) {
                ZStack {
                  // ── ➊ Starfield ────────────────────────────
                  HStack(spacing: 0) {
                    ForEach(0..<repeatCount, id: \.self) { _ in
                      Image("SpaceBackground")
                        .resizable()
                        .scaledToFill()
                        .frame(width: tileWidth, height: screenSize.height)
                        .clipped()
                        
                    }
                  }
                  .frame(width: totalWidth, height: screenSize.height)

                  // ── ➋ Nebulas
                  HStack(spacing: 0) {
                    ForEach(0..<repeatCount, id: \.self) { _ in
                      Image("Nebulas")
                        .resizable()
                        .scaledToFill()
                        .frame(width: tileWidth, height: screenSize.height)
                        .clipped()
                    }
                  }
                  .frame(width: totalWidth, height: screenSize.height)

                  // ── ➌ Galaxies (3, evenly-spaced, random Y) ─
                  ForEach(galaxies) { g in
                    Image(g.imageName)
                      .resizable()
                      .frame(width: g.size, height: g.size)
                      .position(x: g.baseX, y: g.baseY)
                  }
                }
                .frame(width: totalWidth, height: screenSize.height)
                
                .onAppear {
                  // disable bounce once
                  UIScrollView.appearance().bounces = false

                  // only generate once
                  guard galaxies.isEmpty else { return }

                  // for 3 tiles, center at 0.5, 1.5, 2.5 × tileWidth
                  let xs = (0..<repeatCount).map { i in
                    tileWidth * (CGFloat(i) + 0.5)
                  }
                  var gen: [Planet] = []
                  for (i, x) in xs.enumerated() {
                    let randomY = CGFloat.random(in: 0.2...0.8) * screenSize.height
                    let randomSize = CGFloat.random(in: 300...400)
                    gen.append(
                      Planet(
                        imageName: "galaxy\(i+1)",
                        baseX: x,
                        baseY: randomY,
                        size: randomSize,
                        parallax: 0.1
                      )
                    )
                  }
                  galaxies = gen
                }
            }
        }
        .ignoresSafeArea()
        .onDisappear {
          UIScrollView.appearance().bounces = true
        }
    }
}

#Preview {
  LevelsDesignView()
}

