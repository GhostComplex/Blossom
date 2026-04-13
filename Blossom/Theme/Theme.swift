//
//  Theme.swift
//  Blossom (拾月)
//
//  Design System v2: Soft Glassmorphism — 粉紫蓝
//  Based on DESIGN-SPEC-v2.md
//

import SwiftUI

// MARK: - Color Extension
extension Color {
    // Primary Colors (薰衣草紫系)
    static let primary600 = Color(hex: "C9A0DC")    // 薰衣草紫 — 主色、按钮、圆环
    static let primaryDark = Color(hex: "A87CC0")   // 深紫 — Active Tab、按钮深色
    static let accentPeach = Color(hex: "F9B5C4")   // 粉色 — 渐变起点、icon 背景
    static let accentLight = Color(hex: "FDDDE6")   // 浅粉 — 渐变辅助、icon 底色
    static let warmGold = Color(hex: "B8DCF5")      // 天蓝 — 渐变终点、icon 背景

    // Background Colors (粉紫蓝三色渐变)
    static let bgTop = Color(hex: "FEF6F8")         // 页面背景 — 粉白
    static let bgMid = Color(hex: "F6EDF8")         // 页面背景 — 淡紫
    static let bgBottom = Color(hex: "EDF2FC")       // 页面背景 — 淡蓝
    static let bgExtra = Color(hex: "F4F0FA")        // 页面背景 — 紫调收尾

    // Neutral Colors (紫调)
    static let n900 = Color(hex: "3A2F50")          // 深紫 — 主标题
    static let n700 = Color(hex: "5A4D6E")          // 中深紫 — 正文、导航
    static let n500 = Color(hex: "7A6E94")          // 中紫 — 辅助文字、标签
    static let n300 = Color(hex: "AEA3C4")          // 浅紫 — 未激活图标、描述
    static let n200 = Color(hex: "D4CCE0")          // 分割线、进度条背景
    static let n100 = Color(hex: "EDE7F8")          // 浅底色

    // Functional Colors
    static let success = Color(hex: "7BC4A0")       // 浅绿（完成状态）
    static let warning = Color(hex: "E8C97A")       // 暖金（提醒）
    static let error = Color(hex: "D47B8A")         // 柔红（错误）

    // Card Background
    static let cardBg = Color.white.opacity(0.45)

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
    // Page background gradient (170deg: 粉→紫→蓝→紫)
    static let pageBackground = LinearGradient(
        stops: [
            .init(color: Color.bgTop, location: 0.0),
            .init(color: Color.bgMid, location: 0.35),
            .init(color: Color.bgBottom, location: 0.70),
            .init(color: Color.bgExtra, location: 1.0)
        ],
        startPoint: UnitPoint(x: 0.41, y: 0.0),   // 170deg ≈ nearly vertical
        endPoint: UnitPoint(x: 0.59, y: 1.0)
    )

    // Countdown card gradient (140deg: 粉紫蓝半透明)
    static let countdownCard = LinearGradient(
        stops: [
            .init(color: Color.accentPeach.opacity(0.5), location: 0.0),
            .init(color: Color(hex: "C4B5E0").opacity(0.45), location: 0.5),
            .init(color: Color.warmGold.opacity(0.4), location: 1.0)
        ],
        startPoint: UnitPoint(x: 0.17, y: 0.0),   // 140deg
        endPoint: UnitPoint(x: 0.83, y: 1.0)
    )

    // Countdown text gradient (紫调)
    static let countdownText = LinearGradient(
        colors: [Color.primaryDark, Color.primary600],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Progress bar gradient (粉→紫)
    static let progressBar = LinearGradient(
        colors: [Color.accentPeach, Color(hex: "C4B5E0")],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Typography
struct AppFonts {
    // Cormorant Garamond for titles and numbers
    static func cormorant(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .light, .thin, .ultraLight:
            return .custom("NotoSerifSC-Regular", size: size)
        case .medium:
            return .custom("NotoSerifSC-Medium", size: size)
        case .semibold:
            return .custom("NotoSerifSC-SemiBold", size: size)
        case .bold, .heavy, .black:
            return .custom("NotoSerifSC-Bold", size: size)
        default:
            return .custom("NotoSerifSC-Regular", size: size)
        }
    }

    // Cormorant Garamond for titles (bundled variable font)
    static func title(_ size: CGFloat) -> Font {
        .custom("NotoSerifSC-Regular", size: size)
    }
    
    static func titleRegular(_ size: CGFloat) -> Font {
        .custom("NotoSerifSC-Regular", size: size)
    }

    // Nunito for body text
    static func nunito(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .medium:
            return .custom("Nunito-Medium", size: size)
        case .semibold:
            return .custom("Nunito-SemiBold", size: size)
        case .bold:
            return .custom("Nunito-Bold", size: size)
        default:
            return .custom("Nunito-Regular", size: size)
        }
    }

    // Body text fallback
    static func inter(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        nunito(size, weight: weight)
    }

    // Legacy alias
    static func playfair(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        cormorant(size, weight: weight)
    }

    // Specific sizes from design spec v2
    static let countdownNumber = Font.custom("NotoSerifSC-Light", size: 72)
    static let countdownUnit = Font.custom("Nunito-Regular", size: 15)
    static let pageTitle = Font.custom("NotoSerifSC-Regular", size: 28)
    static let sectionTitle = Font.custom("NotoSerifSC-Regular", size: 24)
    static let cardTitle = Font.custom("Nunito-Medium", size: 13)
    static let bodyText = Font.system(size: 13, weight: .regular)
    static let caption = Font.system(size: 12, weight: .regular)
    static let smallLabel = Font.system(size: 11, weight: .regular)
    static let tabLabel = Font.custom("Nunito-Medium", size: 9.5)
}

// MARK: - Corner Radius
struct AppRadius {
    static let sm: CGFloat = 10      // Small elements
    static let md: CGFloat = 14      // Buttons, icon backgrounds
    static let lg: CGFloat = 20      // Cards (was 22)
    static let xl: CGFloat = 28      // Main countdown card (was 26)
    static let full: CGFloat = 100   // Pill buttons, badges
    static let phone: CGFloat = 50   // Phone frame
}

// MARK: - Shadows (紫调)
struct AppShadow {
    static let sm = Shadow(color: Color(hex: "C4B5E0").opacity(0.08), radius: 4, x: 0, y: 2)
    static let md = Shadow(color: Color(hex: "C4B5E0").opacity(0.10), radius: 8, x: 0, y: 6)
    static let lg = Shadow(color: Color(hex: "C4B5E0").opacity(0.13), radius: 16, x: 0, y: 12)
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
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .opacity(0.7)
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(0.3))
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
            )
            .shadow(color: Color(hex: "C4B5E0").opacity(0.08), radius: 8, x: 0, y: 2)
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
