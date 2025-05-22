//
//  DisneyArcAnimation.swift
//  ClockAnimation
//
//  Created by Leon Salvatore on 22.05.2025.
//


import SwiftUI

struct DisneyAnimationConfig {
    
    var color: Color = .init(hex: "#D16E38")
    var highlightPosition: CGFloat = 0.5
    var drawArc: CGFloat = 0.0
    var lineWeight: CGFloat = 1
    var location: CGFloat = 1
    var lastLocationOpacity: Double = 0
    var animationDuration: Double = 1.9
    var animationCompletionDuration: Double = 1
    var textColor: Color = .charcoalTeal
    var animateStarAlongPath: Bool = false
    
    
    mutating func finish() {
        lineWeight = 5
        location = 1
        color = .white
        lastLocationOpacity = 1
        
    }
}
struct DisneyArcAnimation: View {
    
    @State private var animateGradient = false
    @Binding var config: DisneyAnimationConfig
    
    let configRect = CGRect(x: 0, y: 0, width: 250, height: 200)
    
    var gradiant: LinearGradient {
        
        let grad = Gradient(stops: [
            .init(color: config.color.opacity(config.lastLocationOpacity), location: 0),
            .init(color: config.color.opacity(0.9), location: config.highlightPosition)
        ])
        return LinearGradient(
            gradient: grad,
            startPoint: .leading ,
            endPoint: animateGradient ? .trailing : .leading
        )
        
    }
    
    var body: some View {
        
        ZStack {
            let arc = DisneyArc()
            arc
                .rotation(.degrees(10))
                .trim(from: .zero, to: config.drawArc)
                .stroke(gradiant,style: .init(lineWidth: config.lineWeight, lineCap: .round))
                .frame(width: 250, height: 150)
                .offset(x: -27, y: -7)
                .overlay(alignment: .center) {
                    // Stars along the path
                    if config.animateStarAlongPath {
                        ForEach(0..<20, id: \.self) { i in
                            let t = CGFloat(i) / 9
                            let point = arc.point(at: t, in: configRect)
                            
                            StarShape()
                                .stroke(gradiant,style: .init(lineWidth: config.lineWeight * 0.3, lineCap: .round))
                                .frame(height: CGFloat.random(in: 0...3))
                                .position(x: point.x - 27, y: point.y - 13)
                                .opacity(CGFloat.random(in: 0.2...1))
                        }
                        .frame(width: configRect.width, height: configRect.height)
                        .compositingGroup()
                    
                    }
                    
                }
                .onAppear {
                    withAnimation(.easeOut(duration: config.animationDuration), completionCriteria: .logicallyComplete) {
                        config.drawArc = 1.0
                        config.highlightPosition = 0.9
                        animateGradient = true
                        config.animateStarAlongPath = true
                        
                        
                    } completion: {
                        withAnimation(.easeInOut(duration: 1)) {
                            config.highlightPosition = 0
                            config.animateStarAlongPath = false
                            config.color = .black
                        }
                        
                        withAnimation(.easeIn(duration: config.animationCompletionDuration)) {
                            config.lineWeight = 5
                            config.location = 1
                            config.lastLocationOpacity = 1
                            config.textColor = .black
                            animateGradient = false
                           
                            
                        }
                    }
                    
                }
        }
        .frame(height: configRect.height, alignment: .center)
        
        
    }
}

#Preview {
    @Previewable @State var cong = DisneyAnimationConfig()
    DisneyArcAnimation(config: $cong)
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(.charcoalTeal)
        .ignoresSafeArea(.all)
}
