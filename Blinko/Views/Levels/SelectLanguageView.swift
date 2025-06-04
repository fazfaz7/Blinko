//
//  SelectLanguageView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 02/06/25.
//

import SwiftUI

struct SelectLanguageView: View {
    @AppStorage("selectedLanguage") var langCode: String = "es"
    
    var body: some View {
       
            VStack {
                Text("Choose Language")
                Picker("Choose Language", selection: $langCode) {
                    Text("Español").tag("es")
                    Text("English").tag("en")
                    Text("Italiano").tag("it")
                    Text("Japanese").tag("ja")
                    Text("Portoghese").tag("pt")
                }
            }

    }
}

#Preview {
    SelectLanguageView()
}
