import SwiftUI

struct PulsingPlanetView: View {
    let imageName: String
    let color: Color
    let pulse: Bool

    @State private var pulseAnim = false
    @State private var enableAura = false

    var body: some View {
        ZStack {
            if pulse {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(enableAura ? 0 : 0.3)
                    .scaleEffect(enableAura ? 3 : 1)
                    .blur(radius: enableAura ? 2 : 0)
                    .onAppear {
                        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                            enableAura = true
                        }
                    }

                PlanetGradientOverlay(
                    imageName: imageName,
                    baseColor: color,
                    pulse: pulseAnim
                )
            }

            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(pulseAnim ? 1.1 : 1.0)
                .shadow(color: color.opacity(pulseAnim ? 0.9 : 0.3), radius: pulseAnim ? 20 : 10)
                .onAppear {
                    if pulse {
                        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            pulseAnim = true
                        }
                    }
                }
        }
        .onDisappear {
                    withAnimation() {
                        pulseAnim = false
                        enableAura = false
                    }
                }
    }
}


struct PulsePlanetAura: View {
    let imageName: String
    let color: Color
    @State private var enablePulse = false
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .opacity(enablePulse ? 0 : 0.3)
            .scaleEffect(enablePulse ? 3 : 1)
            .blur(radius: enablePulse ? 2 : 0)
            .onAppear {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    enablePulse = true
                }
            }
    }
}

