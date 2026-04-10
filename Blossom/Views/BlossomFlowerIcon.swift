import SwiftUI

/// App icon 花朵 — 6 外瓣 + 6 内瓣 + 花蕊，纯 SwiftUI 绘制
struct BlossomFlowerIcon: View {
    let size: CGFloat
    
    // 色板（与 design.html / app-icon 一致）
    private let outerColors: [Color] = [
        Color(red: 232/255, green: 196/255, blue: 168/255), // #E8C4A8
        Color(red: 221/255, green: 184/255, blue: 168/255), // #DDB8A8
        Color(red: 201/255, green: 160/255, blue: 132/255), // #C9A084
    ]
    private let innerColor = Color(red: 240/255, green: 221/255, blue: 211/255) // #F0DDD3
    private let centerColor1 = Color(red: 245/255, green: 234/255, blue: 224/255) // #F5EAE0
    private let centerColor2 = Color(red: 201/255, green: 160/255, blue: 132/255) // #C9A084
    
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
        Color(red: 250/255, green: 245/255, blue: 240/255)
            .ignoresSafeArea()
        BlossomFlowerIcon(size: 200)
    }
}
