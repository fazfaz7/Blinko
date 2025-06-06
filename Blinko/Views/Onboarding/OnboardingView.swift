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
                                Text(NSLocalizedString("welcome_title", comment: ""))
                                    .font(.custom("Baloo2-Bold", size: 75))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.7)
                                    .lineLimit(1)
                                    .frame(maxWidth: geometry.size.width * 0.55)

                                Text("welcome_description")
                                    .font(.custom("Baloo2-Medium", size: 45))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                        )
                        .tag(0)
                    
                    
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.lightYellow)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.yellowBlinko, lineWidth: 25)
                        )
                        .overlay(
                            VStack(spacing: 20) {
        
                                Text("onboarding_objects_title")
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
                        .tag(1)
                    
                    
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.lightYellow)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.yellowBlinko, lineWidth: 25)
                        )
                        .overlay(
                            VStack(spacing: 0) {
       
                                Text("treasure_hunt_title")
                                    .font(.custom("Baloo2-Medium", size: 50))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                                Text("treasure_hunt_description")
                                    .font(.custom("Baloo2-Medium", size: 40))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                                    

                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                        )
                        .tag(2)
                    
                    
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.lightYellow)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.yellowBlinko, lineWidth: 25)
                        )
                        .overlay(
                            VStack(spacing: 0) {
       
                                Text("image_matching_title")
                                    .font(.custom("Baloo2-Medium", size: 50))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                                Text("image_matching_description")
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
                        .tag(3)
                    
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.lightYellow)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.yellowBlinko, lineWidth: 25)
                        )
                        .overlay(
                            VStack(spacing: 0) {
       
                                Text("find_it_again_title")
                                    .font(.custom("Baloo2-Medium", size: 50))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                                Text("find_it_again_description")
                                    .font(.custom("Baloo2-Medium", size: 40))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                                    
                             

                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                        )
                        .tag(4)
                    
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.lightYellow)
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.yellowBlinko, lineWidth: 25)
                        )
                        .overlay(
                            VStack(spacing: 0) {
       
                                Text("language_selection_title")
                                    .font(.custom("Baloo2-Medium", size: 50))
                                    .foregroundColor(.darkBlue)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: geometry.size.width * 0.6)
                                Text("language_selection_description")
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
                                    Text("onboarding_lets_go")
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
                        .tag(5)
                    

                   
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
