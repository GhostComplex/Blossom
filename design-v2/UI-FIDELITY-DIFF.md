# UI 还原度精确对比：Design HTML CSS 值 vs Swift 代码值

**日期：** 2026-04-11  
**目的：** 逐值对比，开发直接改数值

---

## P0 — icon 颜色反了

### 问题：icon 内容用了彩色 SF Symbol，应该是白色 stroke

**Design HTML：**
```html
<svg stroke="white" stroke-width="2" fill="none">  <!-- 白色描边，无填充 -->
```

**Swift 代码（HomeView.swift:383-384）：**
```swift
Image(systemName: icon)
    .foregroundStyle(isCompleted ? Color.success : Color.primaryDark)  // ❌ 紫色图标
```

**应改为：**
```swift
Image(systemName: icon)
    .foregroundStyle(.white)  // ✅ 白色图标
```

### 问题：icon 背景颜色不够饱和

**Design HTML（每个卡片不同）：**
```css
/* 凯格尔 */ background: linear-gradient(135deg, rgba(249,181,196,0.5), rgba(249,181,196,0.8));  /* 粉色 */
/* 拉玛泽 */ background: linear-gradient(135deg, rgba(196,181,224,0.5), rgba(196,181,224,0.8));  /* 紫色 */
/* 待产包 */ background: linear-gradient(135deg, rgba(184,220,245,0.5), rgba(184,220,245,0.8));  /* 蓝色 */
/* 知识   */ background: linear-gradient(135deg, rgba(201,160,220,0.5), rgba(201,160,220,0.8));  /* 深紫 */
```

**Swift 代码（HomeView.swift:198-231）：**
```swift
iconGradient: [Color.accentPeach.opacity(0.6), Color.accentPeach.opacity(0.25)]  // ❌ 0.25 太淡
iconGradient: [Color.primary600.opacity(0.45), Color(hex: "C4B5E0").opacity(0.3)]  // ❌ 0.3 太淡
iconGradient: [Color.warmGold.opacity(0.5), Color.warmGold.opacity(0.25)]  // ❌ 0.25 太淡
iconGradient: [Color(hex: "C4B5E0").opacity(0.45), Color.primary600.opacity(0.25)]  // ❌ 0.25 太淡
```

**应改为（匹配 design HTML 的 0.5→0.8）：**
```swift
iconGradient: [Color.accentPeach.opacity(0.5), Color.accentPeach.opacity(0.8)]  // 粉色
iconGradient: [Color(hex: "C4B5E0").opacity(0.5), Color(hex: "C4B5E0").opacity(0.8)]  // 紫色
iconGradient: [Color.warmGold.opacity(0.5), Color.warmGold.opacity(0.8)]  // 蓝色
iconGradient: [Color(hex: "C9A0DC").opacity(0.5), Color(hex: "C9A0DC").opacity(0.8)]  // 深紫
```

---

## P0 — 进度条颜色

**Design HTML：**
```css
.pf { background: linear-gradient(90deg, var(--pink), var(--lavender)); }
/* --pink: #F9B5C4, --lavender: #C4B5E0 */
```

**Swift 代码（Theme.swift:102）：**
```swift
static let progressBar = LinearGradient(
    colors: [Color.accentPeach, Color.primary600],  // accentPeach=#F9B5C4, primary600=#C9A0DC
```

**值接近但视觉偏灰** — 可能是 `primary600` 太亮。改成：
```swift
colors: [Color(hex: "F9B5C4"), Color(hex: "C4B5E0")]  // 精确匹配 design HTML
```

---

## P1 — 卡片毛玻璃透明度

**Design HTML：**
```css
.tc {
    background: rgba(255,255,255,0.45);
    backdrop-filter: blur(24px);
    border: 1px solid rgba(255,255,255,0.6);
}
```

**Swift 代码（Theme.swift:40）：**
```swift
static let cardBg = Color.white.opacity(0.45)  // ✅ 数值正确
```

**但视觉上偏白** — SwiftUI 的 `.background(Color.white.opacity(0.45))` 在浅色背景上可能不等同于 CSS 的 `rgba(255,255,255,0.45) + backdrop-filter:blur(24px)`。需要确认 `glassCard` modifier 是否正确应用了 blur。

检查 `Theme.swift` 的 `glassCard` 实现：
```swift
// 需要确认 .background(.ultraThinMaterial) 或自定义 blur 是否生效
```

---

## P1 — 倒计时卡片渐变

**Design HTML：**
```css
background: linear-gradient(140deg,
    rgba(249,181,196,0.5) 0%,    /* 粉色 */
    rgba(196,181,224,0.45) 50%,  /* 紫色 */
    rgba(184,220,245,0.4) 100%   /* 蓝色 */
);
```

**Swift 代码（Theme.swift:85-87）：**
```swift
.init(color: Color.accentPeach.opacity(0.5), location: 0.0),
.init(color: Color(hex: "C4B5E0").opacity(0.45), location: 0.5),
.init(color: Color.warmGold.opacity(0.4), location: 1.0)
```

**数值匹配 ✅** — 但视觉偏淡。可能是 SwiftUI LinearGradient 的渲染和 CSS 不完全一致。尝试提高 opacity 到 0.6/0.55/0.5。

---

## P2 — 凯格尔圆环中心

**Design HTML：**
```css
.ring-center {
    background: rgba(255,255,255,0.4);
    backdrop-filter: blur(16px);
}
```

**Swift 代码（KegelExerciseView.swift:120-126）：**
```swift
// Frosted center — design spec: rgba(255,255,255,0.4) + blur(16px)
.fill(.ultraThinMaterial)  // 材质
.fill(Color.white.opacity(0.3))  // overlay
```

**改为更匹配的值：**
```swift
.fill(Color.white.opacity(0.4))  // 匹配 design HTML
.blur(radius: 16)  // 匹配 design HTML
```

---

## 汇总修改文件清单

| 文件 | 改什么 |
|------|--------|
| HomeView.swift:383 | icon foregroundStyle → `.white` |
| HomeView.swift:198-231 | icon gradient opacity 0.25→0.8 |
| Theme.swift:102 | progressBar 颜色精确匹配 |
| Theme.swift:85-87 | 倒计时卡片渐变 opacity 提高 |
| KegelExerciseView.swift:126 | 圆环中心 white opacity 0.3→0.4 |
| TasksView.swift | 同 HomeView icon 修改 |
| KnowledgeView.swift | 同 HomeView icon 修改 |
| LamazeExerciseView.swift | 同 HomeView icon 修改 |

---

## 字体对比

### 首页

| 元素 | Design HTML | Swift 代码 | 匹配？ |
|------|------------|-----------|--------|
| 问候语「下午好」| Cormorant Garamond 26px w400 | 未找到对应代码（可能用 navigationTitle） | ❌ 中文 fallback 到系统字体 |
| 日期「April 11」| Nunito 12px w400 | 未确认 | ⚠️ |
| 倒计时数字「65」| Cormorant Garamond 72px **w300** | `CormorantGaramond-Light` size 应在首页确认 | ⚠️ 需确认 |
| 「天」| Nunito 15px w400 | 需确认 | ⚠️ |
| 卡片标题「凯格尔运动」| Nunito 13px **w500** | `.system(size:14, weight:.medium)` HomeView:402 | ⚠️ size 14 vs 13 |
| 卡片描述 | Nunito 10.5px w400 | 需确认 | ⚠️ |
| 进度条标题 | Nunito 12px **w600** | `.system(size:14, weight:.medium)` | ❌ w600 vs medium, 12 vs 14 |
| Tab Bar 文字 | Nunito 9.5px w500 | 系统默认 | ⚠️ |

### 凯格尔

| 元素 | Design HTML | Swift 代码 | 匹配？ |
|------|------------|-----------|--------|
| 级别文字 | Nunito 11px w400 uppercase | 需确认 | ⚠️ |
| 阶段标题 | Cormorant Garamond 26px **w400** | `CormorantGaramond-Light` 26px | ❌ w400(Regular) vs Light(300) |
| 倒计时数字 | Cormorant Garamond 60px **w300** | `CormorantGaramond-Light` 60px | ✅ |
| 「秒」| Nunito 11px w400 | 需确认 | ⚠️ |
| 组数「第 X 组」| Nunito 12px w400 | 需确认 | ⚠️ |
| 按钮文字 | Nunito 13px w600 | `.system(size:16, weight:.semibold)` | ❌ 13 vs 16, 600 vs semibold |

### 完成页

| 元素 | Design HTML | Swift 代码 | 匹配？ |
|------|------------|-----------|--------|
| 「做得真棒」| Cormorant Garamond 30px **w400** | `CormorantGaramond-Light` 28px | ❌ w400 vs Light, 30 vs 28 |
| 正文 | Nunito 14px w300 | `.system(size:14)` | ⚠️ w300 vs default |
| 英文 hint | Nunito 11px w300 italic | `CormorantGaramond-Regular` 12px | ❌ 字体不同 |
| 按钮 | Nunito 14px w600 | `.system(size:16, weight:.semibold)` | ❌ 14 vs 16 |

### 通知弹窗

| 元素 | Design HTML | Swift 代码 | 匹配？ |
|------|------------|-----------|--------|
| 标题 | Cormorant Garamond 20px w400 | `CormorantGaramond-Light` 20px | ❌ w400 vs Light |
| 正文 | Nunito 13px w400 | `.system(size:14)` | ❌ 13 vs 14 |
| 按钮 | Nunito 14px w600 | `.system(size:16, weight:.semibold)` | ❌ 14 vs 16 |

### Onboarding

| 元素 | Design HTML | Swift 代码 | 匹配？ |
|------|------------|-----------|--------|
| 「欢迎来到拾月」| Cormorant Garamond 28px w400 | `CormorantGaramond-SemiBold` 28px | ❌ w400 vs SemiBold |
| 正文 | Nunito 13px w400 | `.system(size:14, weight:.regular)` | ❌ 13 vs 14 |

### 字体修复总结

**高频问题：**
1. **Cormorant Garamond 字重** — Design HTML 多数用 w400(Regular)，代码用了 Light(300) 或 SemiBold(600)。统一改成 `CormorantGaramond-Regular`
2. **按钮字号偏大** — Design HTML 13-14px，代码 16px。统一改小
3. **正文字号偏大** — Design HTML 12-13px，代码 14px
4. **正文字体** — Design HTML 用 Nunito，代码用 `.system`。需要 bundle Nunito 或接受系统字体
