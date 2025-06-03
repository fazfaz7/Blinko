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
        case .normal: return "Neutral"
        case .wow: return "Surprised"
        case .happy: return "Happy"
        case .angry: return "Questioning"
        }
    }
}

struct MascotView: View {
    var mood: MascotMood
    var width: CGFloat = 300
    var height: CGFloat = 300
    var jump: Bool = false

    @State private var offset: CGFloat = 0
    @State private var isJumping = false
    @State private var idleTimer: Timer?

    var body: some View {
        Image(mood.imageName)
            .resizable()
            .frame(width: width, height: height)
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

        if jump == true {
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
            if !repeating {
                timer.invalidate()
                isJumping = false
            }
        }
    }

    private func startIdleBounce() {
        idleTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
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
