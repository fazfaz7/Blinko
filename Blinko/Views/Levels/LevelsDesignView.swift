import SwiftUI

// PreferenceKey to track scroll offset
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct Planet: Identifiable {
    let id = UUID()
    let imageName: String
    let baseX: CGFloat
    let baseY: CGFloat
    let size: CGFloat
    let parallax: CGFloat
}

struct LevelsDesignView: View {
    let repeatCount = 3
    @State private var galaxies: [Planet] = []
    @State private var scrollOffset: CGFloat = 0 // ✅ Track scroll offset

    var body: some View {
        GeometryReader { geo in
            let screenSize  = geo.size
            let uiImage     = UIImage(named: "SpaceBackground")!
            let aspectRatio = uiImage.size.width / uiImage.size.height
            let tileWidth   = screenSize.height * aspectRatio
            let totalWidth  = tileWidth * CGFloat(repeatCount)

            ScrollView(.horizontal, showsIndicators: false) {
                ZStack {
                    // ✅ Scroll offset tracking
                    GeometryReader { scrollGeo in
                        Color.clear
                            .preference(
                                key: ScrollOffsetKey.self,
                                value: scrollGeo.frame(in: .named("scroll")).minX
                            )
                    }
                    .frame(width: 0, height: 0)

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

                    // ── ➋ Nebulas ──────────────────────────────
                    HStack(spacing: 0) {
                        ForEach(0..<repeatCount, id: \.self) { _ in
                            Image("Nebulas")
                                .resizable()
                                .scaledToFill()
                                .frame(width: tileWidth, height: screenSize.height)
                                .clipped()
                        }
                    }
                    .offset(x: -scrollOffset * 10)

                    // ── ➌ Galaxies ─────────────────────────────
                    ForEach(galaxies) { g in
                        Image(g.imageName)
                            .resizable()
                            .frame(width: g.size, height: g.size)
                            .position(x: g.baseX, y: g.baseY)
                            .offset(x: -scrollOffset * g.parallax)
                    }
                }
                .frame(width: totalWidth, height: screenSize.height)
                .onAppear {
                    UIScrollView.appearance().bounces = false
                    guard galaxies.isEmpty else { return }

                    let xs = (0..<repeatCount).map { i in
                        tileWidth * (CGFloat(i) + 0.5)
                    }

                    galaxies = xs.enumerated().map { (i, x) in
                        Planet(
                            imageName: "galaxy\(i+1)",
                            baseX: x,
                            baseY: CGFloat.random(in: 0.2...0.8) * screenSize.height,
                            size: CGFloat.random(in: 300...400),
                            parallax: CGFloat.random(in: 0.05...0.2)
                        )
                    }
                }
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    scrollOffset = -value // Flip to match scroll direction
                }
            }
            .coordinateSpace(name: "scroll") // ✅ Custom coordinate space
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
