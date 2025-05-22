//
//  ContentView.swift
//  DisneyPlusAnimation
//
//  Created by Leon Salvatore on 21.05.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var animate: Bool = false
    var body: some View {
        Group {
            if !animate {
                DisneyIntro()
            } else {
                ClockView()
                    .frame(width: 300, height: 300)
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                animate = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
