import SwiftUI

/// App icon 花朵 — 6 椭圆花瓣 + 花心，纯 SwiftUI 绘制
/// Design v2: 粉紫交替渐变，径向渐变花心 + 白色高光
struct BlossomFlowerIcon: View {
    let size: CGFloat
    
    // 呼吸动画
    @State private var isBreathing = false
    
    // 设计稿色值
    // 花瓣渐变 — 粉色 (奇数瓣)
    private let pinkStart = Color(red: 249/255, green: 181/255, blue: 196/255)   // #F9B5C4
    private let pinkEnd   = Color(red: 232/255, green: 160/255, blue: 184/255)   // #E8A0B8
    // 花瓣渐变 — 紫色 (偶数瓣)
    private let purpleStart = Color(red: 212/255, green: 188/255, blue: 232/255) // #D4BCE8
    private let purpleEnd   = Color(red: 183/255, green: 168/255, blue: 214/255) // #B7A8D6
    // 花心径向渐变
    private let centerInner = Color(red: 254/255, green: 240/255, blue: 243/255) // #FEF0F3
    private let centerOuter = Color(red: 232/255, green: 216/255, blue: 240/255) // #E8D8F0
    
    var body: some View {
        Canvas { context, canvasSize in
            let cx = canvasSize.width / 2
            let cy = canvasSize.height / 2
            let scale = size / 620
            
            // 6 片椭圆花瓣，每 60° 旋转，粉紫交替
            for i in 0..<6 {
                let angle = Angle.degrees(Double(i) * 60)
                let isPink = i % 2 == 0
                let opacity: Double = isPink ? 0.8 : 0.75
                let startColor = isPink ? pinkStart : purpleStart
                let endColor = isPink ? pinkEnd : purpleEnd
                
                drawPetal(
                    context: context, cx: cx, cy: cy, scale: scale,
                    rx: 48, ry: 105, offsetY: -120,
                    rotation: angle,
                    startColor: startColor, endColor: endColor,
                    opacity: opacity
                )
            }
            
            // 花心 — 径向渐变圆 r=65
            let centerRadius: CGFloat = 65 * scale
            let centerRect = CGRect(
                x: cx - centerRadius, y: cy - centerRadius,
                width: centerRadius * 2, height: centerRadius * 2
            )
            context.fill(
                Circle().path(in: centerRect),
                with: .radialGradient(
                    Gradient(colors: [centerInner, centerOuter]),
                    center: CGPoint(x: cx, y: cy),
                    startRadius: 0,
                    endRadius: centerRadius
                )
            )
            
            // 白色高光点 — 2 个
            let highlights: [(dx: CGFloat, dy: CGFloat, r: CGFloat, alpha: Double)] = [
                (0, -15, 5, 0.5),   // 上方高光
                (15, -5, 4, 0.4)    // 右侧高光
            ]
            for h in highlights {
                let hx = cx + h.dx * scale
                let hy = cy + h.dy * scale
                let hr = h.r * scale
                context.fill(
                    Circle().path(in: CGRect(x: hx - hr, y: hy - hr, width: hr * 2, height: hr * 2)),
                    with: .color(.white.opacity(h.alpha))
                )
            }
        }
        .frame(width: size, height: size)
        .scaleEffect(isBreathing ? 1.06 : 1.0)
        .animation(
            .easeInOut(duration: 3).repeatForever(autoreverses: true),
            value: isBreathing
        )
        .onAppear { isBreathing = true }
    }
    
    private func drawPetal(
        context: GraphicsContext, cx: CGFloat, cy: CGFloat, scale: CGFloat,
        rx: CGFloat, ry: CGFloat, offsetY: CGFloat,
        rotation: Angle,
        startColor: Color, endColor: Color,
        opacity: Double
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
        
        // Linear gradient along the petal length
        ctx.fill(
            Ellipse().path(in: petalRect),
            with: .linearGradient(
                Gradient(colors: [startColor.opacity(opacity), endColor.opacity(opacity)]),
                startPoint: CGPoint(x: 0, y: petalRect.minY),
                endPoint: CGPoint(x: 0, y: petalRect.maxY)
            )
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
