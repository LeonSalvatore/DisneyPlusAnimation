//
//  Flare.swift
//  ClockAnimation
//
//  Created by Leon Salvatore on 22.05.2025.
//

import SwiftUI

struct Flare: View {
    
     var size: CGFloat
    
    var gradient: RadialGradient {
        RadialGradient(
            gradient: Gradient(colors: [
                Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), // Center glow 1
                Color(#colorLiteral(red: 0.5166926384, green: 0.8836110234, blue: 0.9044062495, alpha: 1)), // Center glow 2
                Color(#colorLiteral(red: 0.0332949385, green: 0.5296544433, blue: 0.5890406966, alpha: 1)), // Outer glow 3
                Color(#colorLiteral(red: 0.02226770483, green: 0.3427146077, blue: 0.3907223046, alpha: 1)), // Outer glow
                Color.clear // Fade out
            ]),
            center: .center,
            startRadius: 15,
            endRadius: 160
        )
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(gradient)
                .scaleEffect(size)
            
            ForEach(0..<20, id: \.self) { _ in
                StarShape()
                    .fill(gradient)
                    .frame(height:  size * CGFloat.random(in: 0...20))
                    .offset(x: CGFloat.random(in: -100...100), y: CGFloat.random(in: -100...100))
                    .opacity(CGFloat.random(in: 0.2...1))
            }
            .opacity(0.2)
        }
      
    }
}

#Preview {
    ZStack {
        Flare(size: 1)
    }
    .frame(maxWidth: .infinity, alignment: .center)
    .frame(maxHeight: .infinity, alignment: .center)
    .background(.charcoalTeal)
    .ignoresSafeArea(.all)
}
