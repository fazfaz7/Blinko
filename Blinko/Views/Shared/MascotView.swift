//
//  MascotMood.swift
//  Blinko
//
//  Created by Vincenzo Gerelli on 26/05/25.
//


import SwiftUI

enum MascotMood {
    case normal, wow, happy, angry

    var imageName: String {
        switch self {
        case .normal: return "normal_blinko"
        case .wow: return "wow_blinko"
        case .happy: return "happy_blinko"
        case .angry: return "angry_blinko"
        }
    }
}

struct MascotView: View {
    var mood: MascotMood

    @State private var offset: CGFloat = 0
    @State private var isJumping = false
    @State private var idleTimer: Timer?

    var body: some View {
        Image(mood.imageName)
            .resizable()
            .frame(width: 300, height: 300)
            .offset(y: offset)
            .onChange(of: mood) {
                handleMoodChange()
            }
            .onAppear {
                handleMoodChange()
            }
    }

    private func handleMoodChange() {
        idleTimer?.invalidate()

        if mood == .happy {
            startJumping(repeating: true)
        } else if mood == .normal {
            startIdleBounce()
        }
    }

    private func startJumping(repeating: Bool) {
        guard !isJumping else { return }
        isJumping = true

        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: repeating) { timer in
            bounce()
            if !repeating || mood != .happy {
                timer.invalidate()
                isJumping = false
            }
        }
    }

    private func startIdleBounce() {
        idleTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            bounce()
        }
    }

    private func bounce() {
        withAnimation(.interpolatingSpring(stiffness: 150, damping: 5)) {
            offset = -30
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.2)) {
                offset = 0
            }
        }
    }
}

#Preview {
    ZStack{
        HStack{
            MascotView(mood: .normal)
            MascotView(mood: .angry)
            MascotView(mood: .wow)
            MascotView(mood: .happy)
            Spacer()
        }.padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.black.opacity(0.2))
    .ignoresSafeArea()
    
}
