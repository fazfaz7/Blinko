//
//  TestView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 21/05/25.
//

import SwiftUI

struct TestView: View {
   var onNext: () -> Void
    var body: some View {
        Button {
            onNext()
        } label: {
            Text("Change!")
        }
    }
}

#Preview {
    //TestView()
}
