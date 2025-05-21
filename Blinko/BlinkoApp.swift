//
//  BlinkoApp.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 16/05/25.
//

import SwiftUI

@main
struct BlinkoApp: App {
    var body: some Scene {
        WindowGroup {
            ImageMatchingView(words: level1.words)
        }
    }
}
