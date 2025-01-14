//
//  ContentView.swift
//  CircularLoaderAnimation
//
//  Created by hong on 1/13/25.
//

import SwiftUI

struct LoadingView: View {
    
    @State var isAnmating: Bool = false
    
    @State var circleStart: CGFloat = 0.17
    
    @State var circleEnd: CGFloat = 0.325
    
    @State var rotationDegree: Angle = .degrees(0)
    
    let circleTrackGradient = LinearGradient(colors: [Color.circleTrackStart, Color.circleTrackEnd], startPoint: .top, endPoint: .bottom)
    
    let circleFillGradient = LinearGradient(colors: [Color.circleRoundStart, Color.circleRoundEnd], startPoint: .top, endPoint: .bottom)

    let circleTrackGradientDark = LinearGradient(colors: [Color(hex: "#0A0A0A")], startPoint: .top, endPoint: .bottom)

    let trackerRotation: Double = 2
    
    let animationDuration: Double = 0.75
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .fill(colorScheme == .light ? circleTrackGradient : circleTrackGradientDark)
                .shadow(color: .label.opacity(0.015), radius: 5, x: 1, y: 1)
            
            Circle()
                .trim(from: circleStart, to: circleEnd)
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .fill(circleFillGradient)
                .rotationEffect(rotationDegree)
        }
        .frame(width: 40, height: 40)
        .onAppear {
            if isAnmating == true {
                return
            }
            isAnmating = true
            animationLoader()
            Timer.scheduledTimer(withTimeInterval: (trackerRotation * animationDuration) + animationDuration, repeats: true) { timer in
                self.animationLoader()
            }
        }
    }
    
    func getrotationDegree() -> Angle {
        return .degrees(360 * trackerRotation) + .degrees(120)
    }
    
    func animationLoader() {
        withAnimation(.spring(response: animationDuration * 2)) {
            rotationDegree = .degrees(-57.5)
            circleEnd = 0.325
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            withAnimation(.easeInOut(duration: trackerRotation * animationDuration)) {
                self.rotationDegree += self.getrotationDegree()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 1.25, repeats: false) { _ in
            withAnimation(.easeInOut(duration: trackerRotation * animationDuration / 2.25)) {
                circleEnd = 0.95
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: trackerRotation * animationDuration, repeats: false) { _ in
            rotationDegree = .degrees(47.5)
            withAnimation(.easeInOut(duration: animationDuration)) {
                circleEnd = 0.25
            }
        }
        
    }
}

fileprivate extension Color {
    static let label: Color = Color(UIColor.label)
    
    static let circleTrackStart: Color = Color(hex: "edf2ff")
    static let circleTrackEnd: Color = Color(hex: "ebf8ff")
    
    static let circleRoundStart: Color = Color(hex: "47c6ff")
    static let circleRoundEnd: Color = Color(hex: "5a83ff")
}

fileprivate extension Color {
    
    /// hex颜色初始化方法
    /// - Parameters:
    ///   - hex: #13c4c1、13c4c1 均可使用
    ///   - defaultColor: 如果输入违法的兜底颜色，不设置为黑色
    init(hex: String, defaultColor: Color = Color.black) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        let scanner = Scanner(string: hex)
        scanner.scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        if scanner.isAtEnd {  // 检查是否成功解析整个字符串
            switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                self = defaultColor
                return
            }
        } else {
            self = defaultColor
            return
        }

        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}


#Preview {
    LoadingView()
}

