//
//  Theme.swift
//  Blossom (如期)
//
//  Design System: Warm Glassmorphism
//  Based on DESIGN-SPEC.md v2.0
//

import SwiftUI

// MARK: - Color Extension
extension Color {
    // Primary Colors (暖琥珀玫瑰金系)
    static let primary600 = Color(hex: "C4855A")    // 琥珀玫瑰金 — 主色
    static let primaryDark = Color(hex: "A86840")   // 深琥珀棕 — 按钮 hover、强调
    static let accentPeach = Color(hex: "E8B89A")    // 杏粉 — 图标背景、边框高亮
    static let accentLight = Color(hex: "F5DDD0")   // 浅杏 — 图标底色、装饰
    static let warmGold = Color(hex: "D4A86A")      // 暖金 — 渐变点缀
    
    // Background Colors
    static let bgTop = Color(hex: "FDF8F3")         // 页面背景顶部
    static let bgBottom = Color(hex: "F7EFE6")      // 页面背景底部
    
    // Neutral Colors (暖棕调)
    static let n900 = Color(hex: "2C1F14")          // 深棕 — 主标题
    static let n700 = Color(hex: "5C3D2A")          // 中棕 — 正文、导航
    static let n500 = Color(hex: "9B7558")          // 浅棕 — 辅助文字、标签
    static let n300 = Color(hex: "D4B8A4")          // 极浅棕 — 未激活图标、分割线
    static let n200 = Color(hex: "EAD9CE")          // 分割线、进度条背景
    static let n100 = Color(hex: "F5EDE6")          // 浅底色
    
    // Functional Colors
    static let success = Color(hex: "5C9E7A")       // 暖绿（完成状态）
    static let warning = Color(hex: "D4A86A")       // 暖金（提醒）
    static let error = Color(hex: "C75B4A")         // 暖红（错误）
    
    // Card Background
    static let cardBg = Color(hex: "FFF8F2").opacity(0.82)
    
    // Hex initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Gradient Definitions
extension LinearGradient {
    // Page background gradient (175deg: top light, bottom warm)
    static let pageBackground = LinearGradient(
        colors: [Color.bgTop, Color.bgBottom],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Countdown number gradient (warm gold)
    static let countdownText = LinearGradient(
        colors: [Color.warmGold, Color.primary600, Color.primaryDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Progress bar gradient
    static let progressBar = LinearGradient(
        colors: [Color.primaryDark, Color.warmGold],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Typography
struct AppFonts {
    // Playfair Display for titles and numbers
    static func playfair(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        .custom("PlayfairDisplay-SemiBold", size: size)
    }
    
    // System font fallback for Playfair
    static func title(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .serif)
    }
    
    // Inter for body text
    static func inter(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
    
    // Specific sizes from design spec
    static let countdownNumber = Font.system(size: 88, weight: .bold, design: .serif)
    static let countdownUnit = Font.system(size: 26, weight: .semibold, design: .serif)
    static let pageTitle = Font.system(size: 34, weight: .semibold, design: .serif)
    static let sectionTitle = Font.system(size: 20, weight: .semibold, design: .serif)
    static let cardTitle = Font.system(size: 17, weight: .semibold)
    static let bodyText = Font.system(size: 14, weight: .medium)
    static let caption = Font.system(size: 13, weight: .medium)
    static let smallLabel = Font.system(size: 12, weight: .medium)
    static let tabLabel = Font.system(size: 10, weight: .semibold)
}

// MARK: - Corner Radius
struct AppRadius {
    static let sm: CGFloat = 10      // Small elements
    static let md: CGFloat = 14      // Icon backgrounds
    static let lg: CGFloat = 22      // Cards
    static let xl: CGFloat = 26      // Main countdown card
    static let full: CGFloat = 100   // Buttons, badges
    static let phone: CGFloat = 50   // Phone frame
}

// MARK: - Shadows
struct AppShadow {
    static let sm = Shadow(color: Color(hex: "643214").opacity(0.07), radius: 4, x: 0, y: 2)
    static let md = Shadow(color: Color(hex: "643214").opacity(0.10), radius: 8, x: 0, y: 6)
    static let lg = Shadow(color: Color(hex: "643214").opacity(0.13), radius: 16, x: 0, y: 12)
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Spacing
struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
    
    // Page padding
    static let pageHorizontal: CGFloat = 20
    static let pageVertical: CGFloat = 22
    
    // Card padding
    static let cardPadding: CGFloat = 18
    static let cardSpacing: CGFloat = 12
}

// MARK: - Glassmorphism Modifier
struct GlassmorphismCard: ViewModifier {
    var cornerRadius: CGFloat = AppRadius.lg
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(Color.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.primary600.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: Color(hex: "643214").opacity(0.07), radius: 4, x: 0, y: 2)
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = AppRadius.lg) -> some View {
        modifier(GlassmorphismCard(cornerRadius: cornerRadius))
    }
}

// MARK: - Background Modifier
struct PageBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(LinearGradient.pageBackground.ignoresSafeArea())
    }
}

extension View {
    func pageBackground() -> some View {
        modifier(PageBackground())
    }
}
