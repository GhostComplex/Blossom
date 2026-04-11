# 逐屏对比：Spec 问题 vs 开发问题

**目的：** 区分每个差异是「spec 写得不够/不一致」还是「开发没按 spec 实现」  
**对比三方：** Design HTML ↔ Design Spec ↔ Swift 代码

---

## 首页

| # | 元素 | HTML 值 | Spec 值 | Swift 代码值 | 问题归属 |
|---|------|---------|---------|-------------|---------|
| 1 | icon 内容色 | `stroke="white"` | **Spec 没写 icon 内容颜色**（v2.0），v2.1 补了「白色 stroke」 | `Color.primaryDark`（紫色） | **Spec 问题**（v2.0 没写清楚） + 开发猜了错的颜色 |
| 2 | icon 背景 opacity | `0.5 → 0.8` | v2.1 写了 `0.5 → 0.8` | `0.6 → 0.25` / `0.5 → 0.25` | **Spec 问题**（v2.0 没写）→ 开发用了自己的值 |
| 3 | 进度条颜色 | `#F9B5C4 → #C4B5E0` | v2.1 写了 `#F9B5C4 → #C4B5E0` | `accentPeach → primary600`（#C9A0DC） | **Spec 问题**（v2.0 只说了「进度条」没写颜色） |
| 4 | 卡片标题字号 | 13px | Spec 写了 13px | Swift 14px | **开发问题** |
| 5 | 卡片描述字号 | 10.5px | Spec 写了 10.5px | Swift 12px (caption) | **开发问题** |
| 6 | 「天」字体 | Nunito 15px | Spec 写了 Nunito 15px | `CG-Regular 22px` | **开发问题** |
| 7 | 孕周 badge opacity | `0.35` | Spec 写了 0.35（在卡片 CSS 里间接提到） | `0.5` | **开发问题** |
| 8 | 卡片 border opacity | `0.5` | Spec 写了 0.5 | `0.6` | **开发问题** |
| 9 | 卡片 shadow | `0 8px 40px rgba(196,160,220,0.12)` | Spec 写了 | `radius 12, opacity 0.10` | **开发问题** |
| 10 | 倒计时卡片内装饰圆 | `::before 100×100 white 0.2` / `::after 60×60 white 0.15` | **Spec 没写** | 代码有但值可能不同 | **Spec 问题**（装饰元素细节没列） |

## 任务页

| # | 元素 | HTML 值 | Spec 值 | Swift 代码值 | 问题归属 |
|---|------|---------|---------|-------------|---------|
| 11 | icon 内容色 | `stroke="white"` | v2.1 写了 | 系统默认色 | **Spec 问题**(v2.0) + **开发问题**(v2.1 后没改) |
| 12 | icon bg | 各色渐变 0.5→0.8 | v2.1 写了 | `Color.accentLight`（单色） | **Spec 问题**(v2.0) + **开发问题** |
| 13 | icon 字号 | 16-18px SVG | **Spec 没写 icon 大小** | `.system(size:22)` | **Spec 问题** |

## 凯格尔

| # | 元素 | HTML 值 | Spec 值 | Swift 代码值 | 问题归属 |
|---|------|---------|---------|-------------|---------|
| 14 | 阶段标题字重 | CG w400 (Regular) | Spec 写了 Regular | `CG-Light` (300) | **开发问题** |
| 15 | 按钮字号 | 13px | Spec 写了 13px | `16px` | **开发问题** |
| 16 | 圆环中心 opacity | 0.4 | Spec 写了 0.4 | `0.3` | **开发问题** |
| 17 | 弧形装饰 | `.kg-arc` 200×400 border | **Spec 没写** | 不确定是否实现 | **Spec 问题** |

## 完成页

| # | 元素 | HTML 值 | Spec 值 | Swift 代码值 | 问题归属 |
|---|------|---------|---------|-------------|---------|
| 18 | 标题字重 | CG w400 (Regular) | Spec 写了 Regular | `CG-Light` (300) | **开发问题** |
| 19 | 标题字号 | 30px | Spec 写了 30px | `28px` | **开发问题** |
| 20 | 英文 hint 字体 | Nunito 11px italic | Spec 写了 | `CG-Regular 12px` | **开发问题** |
| 21 | 按钮字号 | 14px | Spec 写了 14px | `16px` | **开发问题** |

## Onboarding

| # | 元素 | HTML 值 | Spec 值 | Swift 代码值 | 问题归属 |
|---|------|---------|---------|-------------|---------|
| 22 | 标题字重 | CG w400 (Regular) | Spec 写了 Regular | `CG-SemiBold` | **开发问题** |
| 23 | 正文字号 | 13px | Spec 写了 13px | `14px` | **开发问题** |
| 24 | 日期年份 | CG 20px | **Spec 没写日期具体字号** | `CG-SemiBold 24px` | **Spec 问题** |
| 25 | 日期月日 | CG 40px | **Spec 没写** | `CG-Bold 42px` | **Spec 问题** |

## 通知弹窗

| # | 元素 | HTML 值 | Spec 值 | Swift 代码值 | 问题归属 |
|---|------|---------|---------|-------------|---------|
| 26 | 标题字重 | CG w400 (Regular) | Spec 写了 Regular | `CG-Light` | **开发问题** |
| 27 | 按钮字号 | 14px | Spec 写了 14px | `16px` | **开发问题** |

## Tab Bar

| # | 元素 | HTML 值 | Spec 值 | Swift 代码值 | 问题归属 |
|---|------|---------|---------|-------------|---------|
| 28 | Tab Bar 圆底 | 无 | Spec 写了「无圆底」 | Liquid Glass 圆底 | **iOS 26 系统限制**（非 spec 也非开发问题）|
| 29 | Tab 文字字号 | 9.5px | Spec 写了 9.5px | `10px` | **开发问题** |

---

## 汇总

| 问题归属 | 数量 | 说明 |
|---------|------|------|
| **Spec 问题** | 10 项 | v2.0 写得不够详细（icon 颜色/大小、装饰元素、Onboarding 日期字号等） |
| **开发问题** | 17 项 | Spec 有写但代码值不对（字重/字号/opacity/颜色值偏差） |
| **系统限制** | 1 项 | iOS 26 Liquid Glass |
| **重叠** | 2 项 | Spec 没写 + 开发猜错（icon 问题） |

**结论：**
- Spec v2.0 确实不够详细，导致 icon 相关的 P0 问题（10 项是我的责任）
- 但即使 Spec 写清楚了的值，代码也有 17 处没对上（开发责任）
- Spec v2.1 已补全，17 项开发问题需要按 DIFF-REPORT.md 修复
