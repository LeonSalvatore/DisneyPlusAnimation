//
//  DisneyIntro.swift
//  ClockAnimation
//
//  Created by Leon Salvatore on 22.05.2025.
//

import SwiftUI

struct DisneyIntro: View {
    
    @State private var isAnimating = false
    @State private var animateColor = false
    @State private var makePlusSignGlow = false
    @State private var viewScale: CGFloat = 1
    @State private var opacity: Double = 1
    @State private var flareSize: CGFloat = 0
    
    @State private var config: DisneyAnimationConfig = .init()
    
    @ViewBuilder
    func disneyPlusGradient()-> some View {
        
        LinearGradient(
            gradient: Gradient(colors: [
                !animateColor ? .charcoalTeal : Color.disneyTop,
                !animateColor ? .charcoalTeal: Color.disneyBottom,
                !animateColor ? .charcoalTeal: Color.disneyBottom.opacity(0.8)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
    }
    
    var body: some View {
        
        VStack {
            ZStack(alignment: .center) {
                
                Group {
                    
                    DisneyArcAnimation(config: $config)
                        .glow(makePlusSignGlow, color: .white)
                        .shadow(color: makePlusSignGlow ? .glowingBlue.opacity(0.3) : .clear, radius: 0.6, x: 2.5, y: -3)
                    
                    HStack {
                        Text("Disney")
                            .font(.disney(.disneyFontSize))
                            .foregroundStyle(config.textColor)
                        
                        DisneyPlusSymbol()
                            .fill(!makePlusSignGlow ? config.textColor : .white)
                            .frame(width: 50, height: 50)
                            .glow(makePlusSignGlow, color: .glowingBlue)
                            .offset(x: -15, y: 10)
                            .shadow(color: makePlusSignGlow ? .glowingBlue.opacity(0.3) : .clear, radius: 0.6, x: 2.5, y: -3)
                            .blur(radius: makePlusSignGlow ? 1 : 0)
                        
                        
                    }
                    .foregroundStyle(.white)
                }
                .scaleEffect(viewScale, anchor: .center)
                
                Flare(size: flareSize)
                    .scaleEffect(0.35, anchor: .center)
                    .offset(x: 60, y: 10)
                    .opacity(0.8)
                    .zIndex(-100)
                
            }
            .onAppear {
                animateView()
                findFonts()
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(disneyPlusGradient())
    }
    
    private func findFonts() {
        
        for font in UIFont.familyNames.sorted() {
            print("📁 Font family: \(font)")
            for name in UIFont.fontNames(forFamilyName: font) {
                print("  🔤 Font name: \(name)")
            }
        }
    }
    private func animateView() {
        
        withAnimation(.easeOut(duration: 4), completionCriteria: .logicallyComplete) {
            viewScale = 0.8
        } completion: {
            
        }
        
        withAnimation(.easeOut(duration: 1.8), completionCriteria: .logicallyComplete) {
            isAnimating = true
            
        } completion: {
            
            withAnimation(.easeOut(duration: 2)) {
                isAnimating = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.easeOut(duration: 0.8), completionCriteria: .logicallyComplete) {
                flareSize = 1
            } completion: {
                withAnimation(.easeOut(duration: 1.5)) {
                    makePlusSignGlow = true
                    flareSize = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.smooth(duration: 2)) {
                        animateColor = true
                        makePlusSignGlow = false
                        config.textColor = .white
                        config.color = .white
                    }
                }
            }
        }
    }
}

#Preview {
    DisneyIntro()
}


struct Glow: ViewModifier {
    var isGlowing: Bool
    var glowColor: Color

    func body(content: Content) -> some View {
        content
            .shadow(color: isGlowing ? glowColor.opacity(0.6) : .clear, radius: isGlowing ? 10 : 0)
            .shadow(color: isGlowing ? glowColor.opacity(0.4) : .clear, radius: isGlowing ? 20 : 0)
            .shadow(color: isGlowing ? glowColor.opacity(0.2) : .clear, radius: isGlowing ? 30 : 0)
    }
}

extension View {
    func glow(_ isGlowing: Bool, color: Color = .blue) -> some View {
        self.modifier(Glow(isGlowing: isGlowing, glowColor: color))
    }
}





struct PreciseTaperedArcView: View {
    @State private var trimEnd: CGFloat = 0.0

    var body: some View {
        TaperedArcShape(trimEnd: trimEnd)
            .frame(width: 300, height: 300)
            .background(Color(red: 10/255, green: 58/255, blue: 72/255))
            .onAppear {
                withAnimation(.easeOut(duration: 2.0)) {
                    trimEnd = 1.0
                }
            }
    }
}

struct TaperedArcShape: View {
    var trimEnd: CGFloat  // between 0 and 1

    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius: CGFloat = min(size.width, size.height) * 0.4
                let startAngle = CGFloat.pi * 1.25  // flipped to match reference
                let endAngle = CGFloat.pi * 2.0
                let steps = 150

                let maxIndex = Int(CGFloat(steps) * trimEnd)

                for i in 0..<maxIndex {
                    let t = CGFloat(i) / CGFloat(steps - 1)
                    let angle1 = startAngle + (endAngle - startAngle) * t
                    let angle2 = startAngle + (endAngle - startAngle) * (t + 1.0 / CGFloat(steps))

                    let point1 = CGPoint(
                        x: center.x + radius * cos(angle1),
                        y: center.y + radius * sin(angle1)
                    )
                    let point2 = CGPoint(
                        x: center.x + radius * cos(angle2),
                        y: center.y + radius * sin(angle2)
                    )

                    var segment = Path()
                    segment.move(to: point1)
                    segment.addLine(to: point2)

                    let lineWidth = 2.0 + t * 10.0

                    context.stroke(
                        segment,
                        with: .color(.white),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                }
            }
        }
    }
}
#Preview("ARC") {
    PreciseTaperedArcView()
}
