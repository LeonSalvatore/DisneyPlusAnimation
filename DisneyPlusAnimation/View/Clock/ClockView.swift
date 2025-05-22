//
//  ClockView.swift
//  ClockAnimation
//
//  Created by Leon Salvatore on 21.05.2025.
//

import SwiftUI

struct ClockView: View {
    let padding: CGFloat = 20

    @State private var config: ClockConfig = .init()
    
    // Timer for smooth second updates
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let size: CGSize = .iconSize
    
    var gradiant: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#080E32"), // Dark blue
                Color(hex: "#1CE783")  // Hulu green
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        
        VStack {
            
            Text(Date().asString())
                .font(.title.bold())
                .foregroundColor(.secondary)
            
            GeometryReader { proxy in
                let size = proxy.size

                ZStack(alignment: .center) {
                    
                   
                    // Clock face
                    Circle()
                        .stroke(config.style,lineWidth: 5)
                        .frame(height: config.clockDiameter)
                    
                    Circle()
                        .stroke(gradiant,lineWidth: 5)
                        .frame(height: config.clockDiameter + 4)
                 
                    
                    MickeyMouse(size: size)
                        .scaleEffect(0.5)

                     // MARK: Hour markers
                    ForEach(0..<12) { hour in
                        ClockHourMarker(hour: hour)
                           .rotationEffect(.degrees(Double(hour) * 30))
                      
                    }

                    // Second hand (thin red line)
                    ClockHand(angle: config.secondsAngle, length: config.clockDiameter * 0.45, width: 1)

                    // Minute hand
                    ClockHand(angle: config.minuteAngle, length: config.clockDiameter * 0.4, width: 3)

                    // Hour hand (shorter and thicker)
                    ClockHand(angle: config.hourAngle, length: config.clockDiameter * 0.25, width: 4)
                    
                    
                }
                .frame(height: config.clockDiameter, alignment: .center)
                .onAppear {
                    config.viewSize = size
                    updateTime()
                }
              
            }

        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle("Clock Animation")
        .foregroundStyle(config.style)
        .onReceive(timer) { _ in
            withAnimation(.spring(dampingFraction: 0.5)) {
                updateTime()
            }
        }
    }


    private func updateTime() {
        let defaultValue = 0
        let initialAngle: Angle = .ninety
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: .now)

          // Calculate precise angles (0° = 12:00, 90° = 3:00)
          let minutes = Double(components.minute ?? defaultValue)
          let hours = Double(components.hour ?? defaultValue)

          // Convert to 12-hour format and include minute progression
          let twelveHour = hours.truncatingRemainder(dividingBy: 12)
          let hourProgress = twelveHour + (minutes / 60)

        let seconds = Double(components.second ?? defaultValue)
        let nanoseconds = Double(components.nanosecond ?? defaultValue)
        let preciseSeconds = seconds + nanoseconds / 1_000_000_000
        
        
        /*
         60 seconds (or minutes) → each second moves the hand by 6 degrees:
         Angle =Seconds * 6
         */
        let totalElapsedSeconds = (minutes * 60) + preciseSeconds + 1
        config.secondsAngle = .degrees(totalElapsedSeconds * 6 - initialAngle.degrees)
        
        // 360° / 60 minutes = 6° per minute
        config.minuteAngle = .degrees(minutes * 6 - initialAngle.degrees)
        // 360° / 12 hours = 30° per hour
        config.hourAngle = .degrees(hourProgress * 30 - initialAngle.degrees)
        print(config.secondsAngle.degrees)
      }
    
 

}

// MARK: - Subviews



private struct ClockHourMarker: View {
    let hour: Int
    let markerLength: CGFloat = 10

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .frame(width: 2, height: markerLength)
            Spacer()
               
        }
        .rotationEffect(.degrees(Double(hour) * 30))
    }
}

struct ClockConfig {
    
    var hourAngle: Angle = .zero
    var minuteAngle: Angle = .zero
    var secondsAngle: Angle = .zero
    var viewSize: CGSize = .init()
    
    var clockDiameter: CGFloat {
        min(viewSize.width, viewSize.height)
    }
    
    var style: some ShapeStyle = Color.black
    
}



struct ClockIconView<S: ShapeStyle>: View {
    // State variables remain the same
    @State private var hourAngle: Angle = .zero
    @State private var minuteAngle: Angle = .zero
    @State private var secondAngle: Angle = .zero

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let iconSize: CGFloat = 18

    var hour: Date
    var color: S

    
    init(hour: Date, color: S) {
        self.hour = hour
        self.color = color
    }

    var body: some View {
        ZStack(alignment: .center) {
            // Clock face circle
            Circle()
                .stroke(lineWidth: 1.9) // Thinner border


            // Center dot
            Circle()
                .fill(color.opacity(0.2))
                .frame(height: 2)

            // Hour hand (shorter and thicker)
            ClockHand(angle: hourAngle,
                     length: iconSize * 0.25, // 6pt long
                     width: 1.5) // Slightly thicker

            // Minute hand
            ClockHand(angle: minuteAngle,
                     length: iconSize * 0.35, // ~8.4pt long
                     width: 1)
        }
        .foregroundStyle(color)
        .frame(width: iconSize, height: iconSize)
        .onAppear {
            updateTime()
        }
        .onReceive(timer) { _ in
            updateTime() // Remove animation for icon clarity
        }
    }

    // Reuse the same updateTime() from previous implementation
    private func updateTime() {
        let initialAngle: Angle = .ninety
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: hour)

          // Calculate precise angles (0° = 12:00, 90° = 3:00)
          let minutes = Double(components.minute ?? 0)
          let hours = Double(components.hour ?? 0)

          // Convert to 12-hour format and include minute progression
          let twelveHour = hours.truncatingRemainder(dividingBy: 12)
          let hourProgress = twelveHour + (minutes / 60)

        minuteAngle = .degrees(minutes * 6 - initialAngle.degrees) // 360° / 60 minutes = 6° per minute
        hourAngle = .degrees(hourProgress * 30 - initialAngle.degrees) // 360° / 12 hours = 30° per hour
      }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}

extension Angle {
    
    /// 90 degrees angle
    static let ninety = Angle(degrees: 90)
    /// 180 degrees angle
    static let eighteenZero = Angle(degrees: 180)
    /// 360 degrees
    static let threeHundredSixty = Angle(degrees: 360)
}

extension Date {
    
    func asString(format: String = "HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}


struct MickeyMouse: View {
    
    @State private var isBlinking = false
    @State private var smileProgress: CGFloat = 0 // 0 = no smile, 1 = full smile
    var size: CGSize
    
    var body: some View {
        let headDiameter = min(size.width, size.height)
        let earDiameter = headDiameter * 3 / 5
        let earOffsetY = headDiameter / 2
        let faceInset = headDiameter * 0.8
        let eyeWidth = headDiameter * 0.2
        let eyeHeight = headDiameter * 0.4
        let pupilSize = eyeWidth * 0.5
        let eyeSpacing = headDiameter * 0.12
        let eyeOffsetY = -headDiameter * 0.1
        
        let beige = Color(red: 1.0, green: 0.87, blue: 0.69)

        ZStack {
            // Ears
            Circle()
                .fill(Color.black)
                .frame(width: earDiameter, height: earDiameter)
                .offset(x: -headDiameter * 0.35, y: -earOffsetY)
            Circle()
                .fill(Color.black)
                .frame(width: earDiameter, height: earDiameter)
                .offset(x: headDiameter * 0.35, y: -earOffsetY)

            //MARK: Head
            Circle()
                .fill(Color.black)
                .frame(width: headDiameter, height: headDiameter)
            
         //    Skin-tone face inset (composed of 3 ellipses)
            Group {
                    // Left cheek
                    Ellipse()
                        .fill(beige)
                        .frame(width: faceInset * 0.5, height: faceInset * 0.8)
                        .offset(x: -faceInset * 0.15, y: -headDiameter * 0.1)
                    
                    //MARK: Right cheek
                    Ellipse()
                        .fill(beige)
                        .frame(width: faceInset * 0.5, height: faceInset * 0.8)
                        .offset(x: faceInset * 0.15, y: -headDiameter * 0.1)
                

//           //MARK: Forehead/center lobe (vertical oval)
                Ellipse()
                    .fill(beige)
                    .frame(width: faceInset * 1, height: faceInset * 0.50)
                    .offset(y: headDiameter * 0.25)
                    
            }

            //MARK: Eyes group
            Group {
                //MARK: Left eye white
                Ellipse()
                    .fill( isBlinking ? .black : .white)
                    .frame(width: eyeWidth,
                           height: isBlinking ? 2 : eyeHeight)
                    .offset(x: -eyeSpacing, y: -headDiameter / 8)
//
//                //MARK: Right eye white
                Ellipse()
                    .fill( isBlinking ? .black : .white)
                    .frame(width: eyeWidth,
                           height: isBlinking ? 2 : eyeHeight)
                    .offset(x: eyeSpacing, y: -headDiameter / 8)
//
//
//                //MARK: Pupils (animated for blink later)
//                // Left pupil
                Circle()
                    .fill(Color.black.gradient)
                    .frame(height: isBlinking ? .zero : pupilSize)
                    .offset(x: -eyeSpacing, y: eyeOffsetY * 0)
//
//                // Right pupil
                Circle()
                    .fill(Color.black.gradient)
                    .frame(height: isBlinking ? .zero : pupilSize)
                    .offset(x: eyeSpacing, y: eyeOffsetY * 0)
            }
            
            Path { path in
                let start = CGPoint(x: size.width / 2 - headDiameter * 0.18, y: size.height / 2 + headDiameter * 0.15)
                let end = CGPoint(x: size.width / 2 + headDiameter * 0.18, y: size.height / 2 + headDiameter * 0.15)
                
                // 👇 Move control point above the line instead of below
                let control = CGPoint(x: size.width / 2, y: size.height / 2 + headDiameter * 0.05)
                
                path.move(to: start)
                path.addQuadCurve(to: end, control: control)
            }
            .stroke(Color.black, lineWidth: 2)
            .offset(y: -8)

            //MARK: Nose
            Ellipse()
                .fill(Color.black.gradient)
                .frame(width: headDiameter * 0.19, height: headDiameter * 0.09)
                .offset(y: headDiameter * 0.14)

            Ellipse()
                .fill(Color.white)
                .frame(width: headDiameter * 0.05, height: headDiameter * 0.018)
                .offset(y: headDiameter * 0.14)
                .blur(radius: 1)
          
            //MARK: Smile lines
            Path { path in
                // Main smile curve
                let start = CGPoint(x: size.width / 2 - headDiameter * 0.18, y: size.height / 2 + headDiameter * 0.15)
                let end = CGPoint(x: size.width / 2 + headDiameter * 0.18, y: size.height / 2 + headDiameter * 0.15)
                let control = CGPoint(x: size.width / 2, y: size.height / 2 + headDiameter * 0.3)
                
                path.move(to: start)
                path.addQuadCurve(to: end, control: control)

                // Left cheek curve (small upward arc)
                let leftCheekEnd = CGPoint(x: start.x - headDiameter * 0.05, y: start.y - headDiameter * 0.03)
                let leftControl = CGPoint(x: start.x - headDiameter * 0.03, y: start.y - headDiameter * 0.05)
                path.move(to: start)
                path.addQuadCurve(to: leftCheekEnd, control: leftControl)

                // Right cheek curve (small upward arc)
                let rightCheekEnd = CGPoint(x: end.x + headDiameter * 0.05, y: end.y - headDiameter * 0.03)
                let rightControl = CGPoint(x: end.x + headDiameter * 0.03, y: end.y - headDiameter * 0.05)
                path.move(to: end)
                path.addQuadCurve(to: rightCheekEnd, control: rightControl)
            }
            .stroke(Color.black, lineWidth: 4)
            .offset(y: headDiameter * 0.1)

            //MARK: Mouth
            Path { path in
                let rect = CGRect(x: size.width / 2 - headDiameter * 0.15,
                                  y: size.height / 2 + headDiameter * 0.18,
                                  width: headDiameter * 0.3,
                                  height: headDiameter * 0.15)
                path.addArc(center: CGPoint(x: rect.midX, y: rect.minY),
                            radius: rect.width / 2,
                            startAngle: .degrees(0),
                            endAngle: .degrees(180),
                            clockwise: false)
                path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            }
            .fill(Color.black.gradient)
            .offset(y: headDiameter * 0.1)

//            //MARK: Tongue
            Ellipse()
                .fill(Color.red.gradient)
                .frame(width: headDiameter * 0.12, height: headDiameter * 0.05)
                .offset(y: headDiameter * 0.29)
                .shadow(radius: 2)
                .offset(y: headDiameter * 0.1)
        }
        //MARK: Blinking animation on appear
        .onAppear {
            withAnimation(.easeInOut(duration: 0.15).delay(0.3)) {
                isBlinking = true
            }
            withAnimation(.easeInOut(duration: 0.15).delay(0.6)) {
                isBlinking = false
            }
        }
       
    }
}


