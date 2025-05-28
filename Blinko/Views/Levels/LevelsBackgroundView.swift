////
////  ParallaxScrollView.swift
////  Blinko
////
////  Created by Vincenzo Gerelli on 26/05/25.
////
//
//
//import SwiftUI
//
//struct LevelsBackgroundView: View {
//    var body: some View {
//        GeometryReader { outerProxy in
//            let screenWidth = outerProxy.size.width
//            let screenHeight = outerProxy.size.height
//
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 0) {
//                    GeometryReader { innerProxy in
//                        let scrollOffset = innerProxy.frame(in: .global).minX
//
//                        ZStack {
//                            // Z Level 0 - Space background (slowest)
//                            Image("SpaceBackground")
//                                .resizable()
//                                .scaledToFill()
//
//                                .offset(x: -scrollOffset * 0.2)
//                                .ignoresSafeArea()
//
//                            // Z Level 1 - Nebulas (middle speed)
//                            Image("Nebulas")
//                                .resizable()
//                                .scaledToFill()
//
//                                .opacity(0.8)
//                                .offset(x: -scrollOffset * 0.5)
//                                .ignoresSafeArea()
//
//                            // Z Level 2 - Foreground planets (fastest)
//                            HStack(spacing: 60) {
//                                Image("planet1")
//                                    .resizable()
//                                    .frame(width: 100, height: 100)
//                                Image("planet2")
//                                    .resizable()
//                                    .frame(width: 200, height: 200)
//                                Image("planet3")
//                                    .resizable()
//                                    .frame(width: 200, height: 200)
//                            }
//                            .padding(.horizontal, 40)
//                        }
//                        .frame(width: screenWidth * 2, height: screenHeight)
//                    }
//                    .frame(width: screenWidth * 2, height: screenHeight)
//                }
//            }
//            .onAppear {
//                UIScrollView.appearance().bounces = false
//            }
//        }
//        .ignoresSafeArea()
//    }
//}
//
//
//
//
//#Preview {
//    LevelsBackgroundView()
//}

import SwiftUI

struct LevelsBackgroundView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            GeometryReader { outerProxy in
                HStack(spacing: 0) {
                    GeometryReader { innerProxy in
                        let scrollOffset = innerProxy.frame(in: .global).minX
                        
                        ZStack {
                            // Background Layer
                            Image("SpaceBackground")
                                .resizable()
                                .scaledToFill()
                                .offset(x: -scrollOffset * 0.2)
                                .ignoresSafeArea()

                            // Foreground Nebulas
                            Image("Nebulas")
                                .resizable()
                                .scaledToFill()
                                .offset(x: -scrollOffset * 0.5)
                                .opacity(0.9)
                                .ignoresSafeArea()
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}



#Preview {
    LevelsBackgroundView()
}
