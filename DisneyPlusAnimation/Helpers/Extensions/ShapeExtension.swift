//
//  ShapeExtension.swift
//  ClockAnimation
//
//  Created by Leon Salvatore on 22.05.2025.
//

import SwiftUI

extension Shape where Self == DisneyArc {
    static var disneyArc: Self { DisneyArc() }
}

extension Shape where Self == StarShape {
    static var star: Self { StarShape() }
}

//MARK:
struct DisneyArc: Shape {
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        // Ellipse parameters
        let width = rect.width * 0.7
        let height = rect.height
        let centerX = rect.midX
        let centerY = rect.midY
        
        let rect = CGRect(
            x: centerX - width / 2.8,
            y: centerY - height / 3.1,
            width: width,
            height: height
        )
        
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: width / 2,
            startAngle: .degrees(210),
            endAngle: .degrees(-33),
            clockwise: false
        )
        
        
        return path
    }
    
    func point(at t: CGFloat, in rect: CGRect) -> CGPoint {
        let path = self.path(in: rect).trimmedPath(from: 0, to: t)
        return path.currentPoint ?? .zero
    }
}
//MARK:
struct DisneyPlusSymbol: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let lineThickness = rect.width * 0.1 // Thickness relative to symbol size
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let hight = rect.height * 0.6
        
        // Horizontal bar
        let horizontalRect = CGRect(
            x: center.x - rect.width * 0.3,
            y: center.y - lineThickness / 2,
            width: rect.width * 0.6,
            height: lineThickness
        )
        
        // Vertical bar
        let verticalRect = CGRect(
            x: center.x - lineThickness / 3,
            y: center.y - rect.height * 0.3,
            width: lineThickness,
            height: hight
        )
        path.addRoundedRect(in: horizontalRect, cornerSize: CGSize(width: lineThickness / 0.5, height: lineThickness / 2))
        path.addRoundedRect(in: verticalRect, cornerSize: CGSize(width: lineThickness / 2, height: lineThickness / 2))
        
        return path
    }
}

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let size = min(rect.width, rect.height) / 2
        
        let points = [
            CGPoint(x: center.x, y: center.y - size), // top
            CGPoint(x: center.x + size * 0.2, y: center.y - size * 0.2),
            CGPoint(x: center.x + size, y: center.y), // right
            CGPoint(x: center.x + size * 0.2, y: center.y + size * 0.2),
            CGPoint(x: center.x, y: center.y + size), // bottom
            CGPoint(x: center.x - size * 0.2, y: center.y + size * 0.2),
            CGPoint(x: center.x - size, y: center.y), // left
            CGPoint(x: center.x - size * 0.2, y: center.y - size * 0.2),
        ]
        
        path.move(to: points[0])
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        
        return path
    }
}
