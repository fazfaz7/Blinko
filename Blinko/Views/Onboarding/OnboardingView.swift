//
//  OnboardingView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 05/06/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var page = 0
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.darkBlue.ignoresSafeArea()
                
                Image("luna")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.height/2.5)
                    .position(x: geometry.size.width/2, y: geometry.size.height*0.1)
                
                Image("BluePlanet")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.85)
                    .frame(width: geometry.size.width)
                    .offset(y: geometry.size.height)
                
                TabView(selection: $page) {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.lightYellow)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.yellowBlinko, lineWidth: 25)
                        )
                    
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.lightYellow)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.yellowBlinko, lineWidth: 25)
                        )
                    
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.lightYellow)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.yellowBlinko, lineWidth: 25)
                        )
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
               
                    
                
                
            }
        }
    }
}

#Preview {
    OnboardingView()
}
