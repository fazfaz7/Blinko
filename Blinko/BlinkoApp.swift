//
//  BlinkoApp.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 16/05/25.
//

import SwiftUI

@main
struct BlinkoApp: App {
    
    @StateObject var userProgress = UserProgress()
    var body: some Scene {
        WindowGroup {
            //SelectLevel(userProgress: UserProgress())
            CompleteView()
        }
    }
}
