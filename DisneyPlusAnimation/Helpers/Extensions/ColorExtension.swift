//
//  ColorExtension.swift
//  ClockAnimation
//
//  Created by Leon Salvatore on 22.05.2025.
//

import SwiftUI

extension Color {
    
    init(hex: String) {
        let hexSanitized = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexSanitized)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
    }
    
    // MARK: Static values
    static let disneyTop = Color.darkSlateTeal
    static let disneyBottom = Color.lightTeal
    static let disneyBackground = Color.charcoalTeal
}
