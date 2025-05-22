//
//  ClockHand.swift
//  ClockAnimation
//
//  Created by Leon Salvatore on 21.05.2025.
//

import SwiftUI

struct ClockHand: View {
        
    let angle: Angle
    let length: CGFloat
    let width: CGFloat

    var body: some View {
        Capsule()
            .fill(Color.black.gradient)
            .frame(width: length, height: width)
            .offset(x: length / 2)
            .rotationEffect(angle)
    }
}

#Preview {
    ClockHand(angle: .zero, length: 100, width: 4)
}
