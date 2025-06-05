//
//  OnboardingView.swift
//  Blinko
//
//  Created by Adrian Emmanuel Faz Mercado on 05/06/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var page = 0
    @AppStorage("selectedLanguage") var langCode: String = "es"
    @Binding var showOnboarding: Bool
    
    let languages = [
        ("Español", "es", "🇪🇸"),
        ("English", "en", "🇬🇧"),
        ("Italiano", "it", "🇮🇹"),
        ("日本語", "ja", "🇯🇵"),
        ("Português", "pt", "🇵🇹")
    ]
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
                        .overlay(
                            VStack(spacing: 20) {
                                Text("Welcome to **Blinko**!")
                                    .font(.custom("Baloo2-Bold", size: 75))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.7)
                                    .frame(maxWidth: geometry.size.width * 0.55)

                                Text("""
                                Blinko helps kids discover a new language through play and \n**real-world exploration**.
                                """)
                                    .font(.custom("Baloo2-Medium", size: 45))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                        )
                    
                    
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.lightYellow)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.yellowBlinko, lineWidth: 25)
                        )
                        .overlay(
                            VStack(spacing: 20) {
        
                                Text("""
                                Every level features four **real-world objects** that children can explore, learn about, and discover.
                                """)
                                    .font(.custom("Baloo2-Medium", size: 45))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                                    
                                
                                HStack(spacing: 40) {
                                    Image("apple")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120)
                                    
                                    Image("pencil")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120)
                                    
                                    Image("carrot")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120)
                                    
                                    
                                    Image("ruler")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120)
                                }
                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                        )
                    
                    
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.lightYellow)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.yellowBlinko, lineWidth: 25)
                        )
                        .overlay(
                            VStack(spacing: 0) {
       
                                Text("**Treasure Hunt**")
                                    .font(.custom("Baloo2-Medium", size: 50))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                                Text("""
                                Look for each object from the level in the real world and **snap a picture** with the camera. Discover its name in the new language!
                                """)
                                    .font(.custom("Baloo2-Medium", size: 40))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                                    

                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                        )
                    
                    
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.lightYellow)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.yellowBlinko, lineWidth: 25)
                        )
                        .overlay(
                            VStack(spacing: 0) {
       
                                Text("**Image-Matching Game**")
                                    .font(.custom("Baloo2-Medium", size: 50))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                                Text("""
                                 Listen to the word and tap the card with the matching object. Try to connect every sound to the **right drawing**!
                                """)
                                    .font(.custom("Baloo2-Medium", size: 40))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                                    
                                HStack(spacing: 30) {
                                    CardView(cardSize: 105, imageName: "apple", withLabel: true, label: "mela", cardColor: .pinkBlinko, langCode: "es")
                                   
                                    CardView(cardSize: 105, imageName: "pencil", withLabel: true, label: "matita", cardColor: .lilaBlinko, langCode: "es")
                                    
                                    CardView(cardSize: 105, imageName: "carrot", withLabel: true, label: "carota", cardColor: .orangeBlinko, langCode: "es")
                                    
                                    
                                    CardView(cardSize: 105, imageName: "ruler", withLabel: true, label: "righello", cardColor: .purpleBlinko, langCode: "es")
                                }.padding()

                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                        )
                    
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.lightYellow)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.yellowBlinko, lineWidth: 25)
                        )
                        .overlay(
                            VStack(spacing: 0) {
       
                                Text("**Find It Again!**")
                                    .font(.custom("Baloo2-Medium", size: 50))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                                Text("""
                                 You’ll hear a word in your new language and see its silhouette. Search for the real object nearby and show it to the camera to find out if you matched it!
                                """)
                                    .font(.custom("Baloo2-Medium", size: 40))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                                    
                             

                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                        )
                    
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.lightYellow)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.yellowBlinko, lineWidth: 25)
                        )
                        .overlay(
                            VStack(spacing: 0) {
       
                                Text("**Language Selection**")
                                    .font(.custom("Baloo2-Medium", size: 50))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                                Text("""
                                 Pick the language your child will learn!
                                """)
                                    .font(.custom("Baloo2-Medium", size: 40))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
       

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 28) {
                                        ForEach(languages, id: \.1) { lang in
                                            Button(action: {
                                                langCode = lang.1
                                            }) {
                                                VStack(spacing: 4) {
                                                    Text(lang.2)
                                                        .font(.system(size: 50))
                                                    Text(lang.0)
                                                        .font(.custom("Baloo2-Medium", size: 28))
                                                        .foregroundColor(.primary)
                                                }
                                                .padding()
                                                .background(langCode == lang.1 ? Color.yellow.opacity(0.5) : Color.white)
                                                .cornerRadius(24)
                                                .shadow(color: .gray.opacity(0.16), radius: 6, x: 0, y: 4)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .padding(20)
                                .frame(width: geometry.size.width*0.6)
                                    
                                
                                Button {
                                    showOnboarding = false
                                } label: {
                                    Text("Let's Go!")
                                        .foregroundStyle(.darkBlue)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.yellowBlinko))
                                        .fontWeight(.semibold)
                                        .font(.custom("Baloo2-Medium", size: 28))
                                        
                                        
                                }.padding()
                              

     

                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                        )
                    

                   
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
               
                    
                
                Image("Happy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width*0.35)
                    .position(x: geometry.size.width*0.8,y: geometry.size.height*0.85)
                
                
            }
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
