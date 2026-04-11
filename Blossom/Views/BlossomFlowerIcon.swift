import SwiftUI

/// App icon 花朵 — 6 外瓣 + 6 内瓣 + 花蕊，纯 SwiftUI 绘制
/// Design v2: pink / purple / blue petals
struct BlossomFlowerIcon: View {
    let size: CGFloat
    
    // 色板 — design-v2 粉紫蓝系
    private let outerColors: [Color] = [
        Color(red: 249/255, green: 181/255, blue: 196/255), // #F9B5C4 Pink
        Color(red: 196/255, green: 181/255, blue: 224/255), // #C4B5E0 Lavender
        Color(red: 184/255, green: 220/255, blue: 245/255), // #B8DCF5 Sky
    ]
    private let innerColor = Color(red: 253/255, green: 221/255, blue: 230/255) // #FDDDE6 Pink Light
    private let centerColor1 = Color(red: 237/255, green: 231/255, blue: 248/255) // #EDE7F8 Lavender Pale
    private let centerColor2 = Color(red: 201/255, green: 160/255, blue: 220/255) // #C9A0DC Accent
    
    var body: some View {
        Canvas { context, canvasSize in
            let cx = canvasSize.width / 2
            let cy = canvasSize.height / 2
            let scale = size / 620
            
            // 外瓣: 6 片, 每片旋转 60°
            for i in 0..<6 {
                let angle = Angle.degrees(Double(i) * 60)
                let color = outerColors[i % 3]
                let opacity = i % 2 == 0 ? 0.9 : 0.85
                drawPetal(
                    context: context, cx: cx, cy: cy, scale: scale,
                    rx: 52, ry: 118, offsetY: -135,
                    rotation: angle, color: color, opacity: opacity
                )
            }
            
            // 内瓣: 6 片, 偏移 30°
            for i in 0..<6 {
                let angle = Angle.degrees(Double(i) * 60 + 30)
                let opacity = i % 2 == 0 ? 0.95 : 0.9
                drawPetal(
                    context: context, cx: cx, cy: cy, scale: scale,
                    rx: 34, ry: 82, offsetY: -98,
                    rotation: angle, color: innerColor, opacity: opacity
                )
            }
            
            // 花蕊
            let centerRadius: CGFloat = 72 * scale
            let centerRect = CGRect(
                x: cx - centerRadius, y: cy - centerRadius,
                width: centerRadius * 2, height: centerRadius * 2
            )
            context.fill(
                Circle().path(in: centerRect),
                with: .radialGradient(
                    Gradient(colors: [centerColor1, centerColor2]),
                    center: CGPoint(x: cx, y: cy - 20 * scale),
                    startRadius: 0,
                    endRadius: centerRadius * 1.2
                )
            )
            
            // 花蕊高光点
            let highlights: [(CGFloat, CGFloat, CGFloat)] = [
                (0, -20, 6), (17, -10, 4.5), (-10, 12, 4.5)
            ]
            for h in highlights {
                let hx = cx + h.0 * scale
                let hy = cy + h.1 * scale
                let hr = h.2 * scale
                context.fill(
                    Circle().path(in: CGRect(x: hx - hr, y: hy - hr, width: hr * 2, height: hr * 2)),
                    with: .color(.white.opacity(0.5))
                )
            }
        }
        .frame(width: size, height: size)
    }
    
    private func drawPetal(
        context: GraphicsContext, cx: CGFloat, cy: CGFloat, scale: CGFloat,
        rx: CGFloat, ry: CGFloat, offsetY: CGFloat,
        rotation: Angle, color: Color, opacity: Double
    ) {
        var ctx = context
        ctx.translateBy(x: cx, y: cy)
        ctx.rotate(by: rotation)
        
        let petalRect = CGRect(
            x: -rx * scale,
            y: offsetY * scale - ry * scale,
            width: rx * 2 * scale,
            height: ry * 2 * scale
        )
        ctx.fill(
            Ellipse().path(in: petalRect),
            with: .color(color.opacity(opacity))
        )
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [
                Color(hex: "FEF6F8"),
                Color(hex: "F6EDF8"),
                Color(hex: "EDF2FC")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        BlossomFlowerIcon(size: 200)
    }
}
