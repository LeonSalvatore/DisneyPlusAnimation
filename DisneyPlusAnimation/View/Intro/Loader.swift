//
//  Loader.swift
//  ClockAnimation
//
//  Created by Leon Salvatore on 22.05.2025.
//

import SwiftUI

struct Loader: View {
    
    @State private var isLoading = false
    
    var gradient: LinearGradient {
        .linearGradient(
            colors: [
                .glowingBlue,
                .glowingBlue,
                .glowingBlue,
                .glowingBlue,
                .glowingBlue.opacity(0.7),
                .glowingBlue.opacity(0.4),
                .glowingBlue.opacity(0.1),
                .clear
            ],
            startPoint: .top,
            endPoint: .bottom)
    }
    
    var body: some View {
        
        Circle()
            .stroke(gradient, lineWidth: 6)
            .rotationEffect(.degrees(isLoading ? 360 : .zero))
            .onAppear {
                withAnimation(.linear(duration: 0.7).repeatForever(autoreverses: false)) {
                    self.isLoading.toggle()
                }
            }
    }
}

#Preview {
    Loader()
}
