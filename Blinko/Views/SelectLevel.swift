//
//  SelectLevel.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 22/05/25.
//

import SwiftUI

struct SelectLevel: View {
    let levels: [Level] = [level1_data, level2_data, level3_data]
    @ObservedObject var userProgress: UserProgress
    @State private var selectedLevel: Level? = nil
    @State private var showLanguageSheet: Bool = false

    var body: some View {
        NavigationStack {
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showLanguageSheet = true
                    } label: {
                        Image(systemName: "gear")
                            .font(.title)
                    }
                        

                }.padding()
                Spacer()
                HStack {
                    ForEach(Array(levels.enumerated()), id: \.element.id) { idx, level in
                        let isUnlocked = userProgress.isLevelUnlocked(levelIndex: idx, levels: levels)
                        
                        Button {
                            if isUnlocked {
                                selectedLevel = level
                            }
                        } label: {
                            Text("LEVEL \(idx + 1)")
                                .foregroundStyle(isUnlocked ? .green : .red)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).stroke(isUnlocked ? Color.green : Color.red, lineWidth: 2))
                        }
                        .disabled(!isUnlocked)
                    }
                }
                .padding()
                
                Spacer()
            }.padding()
        }
        .fullScreenCover(item: $selectedLevel) { level in
            ChooseMinigameView(
                level: level,
                userProgress: userProgress
            ) {
                selectedLevel = nil
            }
        }
        .sheet(isPresented: $showLanguageSheet, content: {
            SelectLanguageView()
        })
        .statusBarHidden()
    }
}


#Preview {
    SelectLevel(userProgress: UserProgress())
}
