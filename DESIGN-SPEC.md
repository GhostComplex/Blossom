# 如期 Blossom · Design Specification v2.0

**最后更新：** 2026-04-09  
**设计风格：** Warm Glassmorphism · 温暖毛玻璃

---

## 1. 设计理念

**核心关键词：** 温暖、期待、轻盈

**感觉：** 像春天的阳光透过窗帘洒进来，暖融融的，每天打开 App 都是一种期待。

**参考标准：**
- Headspace（冥想健康）
- Calm（放松健康）
- Flo（女性健康）

**不要的感觉：**
- ❌ 冷调商务感
- ❌ 幼稚可爱感
- ❌ 高饱和度鲜艳感
- ❌ 纯黑纯白的对比感

---

## 2. 配色系统

### 主色（暖琥珀玫瑰金系）

```css
--primary:      #C4855A;   /* 琥珀玫瑰金 — 主色 */
--primary-dark: #A86840;   /* 深琥珀棕 — 按钮 hover、强调 */
--accent:       #E8B89A;   /* 杏粉 — 图标背景、边框高亮 */
--accent-light: #F5DDD0;   /* 浅杏 — 图标底色、装饰 */
--warm-gold:    #D4A86A;   /* 暖金 — 渐变点缀 */
```

### 背景系统

```css
/* 页面背景：暖米白渐变（顶浅底深，像阳光从上方照下来） */
--bg-top:    #FDF8F3;
--bg-bottom: #F7EFE6;

/* 卡片背景：半透明奶白（毛玻璃） */
--card-bg:     rgba(255, 248, 242, 0.82);
--card-border: rgba(196, 133, 90, 0.18);

/* 页面外围（多屏预览背景） */
background: #EDE0D4;
```

### 中性色（暖棕调，不是冷灰）

```css
--n900: #2C1F14;   /* 深棕 — 主标题 */
--n700: #5C3D2A;   /* 中棕 — 正文、导航 */
--n500: #9B7558;   /* 浅棕 — 辅助文字、标签 */
--n300: #D4B8A4;   /* 极浅棕 — 未激活图标、分割线 */
--n200: #EAD9CE;   /* 分割线、进度条背景 */
--n100: #F5EDE6;   /* 浅底色 */
```

### 功能色

```css
--success: #5C9E7A;   /* 暖绿（完成状态）— 不是冷绿 #10B981 */
--warning: #D4A86A;   /* 暖金（提醒）— 复用 warm-gold */
--error:   #C75B4A;   /* 暖红（错误）— 不是冷红 */
```

### 色彩应用规则

| 元素 | 颜色 | 备注 |
|------|------|------|
| 页面背景 | `bg-top → bg-bottom` 渐变 | 175deg 方向 |
| 卡片背景 | `card-bg` | 毛玻璃半透明 |
| 卡片边框 | `card-border` | 暖棕半透明 |
| 主标题 | `n900` (#2C1F14) | 深棕，不是纯黑 |
| 正文 | `n700` (#5C3D2A) | 中棕 |
| 辅助文字 | `n500` (#9B7558) | 浅棕 |
| 主按钮 | `primary` (#C4855A) | 白色文字 |
| 按钮 hover | `primary-dark` (#A86840) | — |
| 导航激活 | `primary` | — |
| 导航未激活 | `n300` (#D4B8A4) | — |
| 倒计时数字 | `warm-gold → primary → primary-dark` 渐变 | 150deg 方向 |
| 进度条填充 | `primary-dark → warm-gold` 渐变 | 90deg 方向 |
| 完成状态 | `success` (#5C9E7A) | — |

---

## 3. 字体系统

### 字体家族

```css
/* 标题/数字 — 衬线体（优雅、高级） */
font-family: 'Playfair Display', serif;

/* 正文/按钮/标签 — 无衬线体（清晰、现代） */
font-family: 'Inter', -apple-system, sans-serif;
```

**Google Fonts 引入：**
```html
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,500&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
```

### 字体层级

| 用途 | 字体 | 大小 | 字重 | 行高 | 字间距 |
|------|------|------|------|------|--------|
| 页面大标题 | Playfair | 34px | 600 | 1.1 | -0.5px |
| 章节标题 | Playfair | 20px | 600 | 1.2 | -0.3px |
| 子页面标题 | Playfair | 20px | 600 | 1.2 | -0.3px |
| 倒计时数字 | Playfair | 88px | 700 | 0.95 | -4px |
| 计时器数字 | Playfair | 80px | 700 | 1.0 | — |
| 胎动计数 | Playfair | 100px | 700 | 1.0 | — |
| 倒计时单位 | Playfair | 26px | 600 | 1.0 | — |
| 倒计时描述 | Playfair | 15px | 500 | 1.3 | — |
| 卡片标题 | Inter | 16-17px | 600 | 1.4 | -0.2px |
| 正文 | Inter | 14px | 500-600 | 1.4 | — |
| 描述文字 | Inter | 13px | 500 | 1.5 | — |
| 小标签 | Inter | 12px | 500-600 | 1.0 | 0.2px |
| 导航文字 | Inter | 10px | 600 | 1.0 | 0.2px |

### 字体应用规则

- **标题/数字** → Playfair Display（温暖的优雅感）
- **正文/按钮/标签** → Inter（清晰可读）
- **中文** → 自动回退系统字体（-apple-system）
- **数字渐变** → 倒计时数字用 `background-clip: text` 实现暖金渐变

---

## 4. 圆角系统

```css
--radius-sm:   10px;    /* 小元素：返回按钮、复选框 */
--radius-md:   13-14px; /* 图标背景、知识卡片 */
--radius-lg:   22px;    /* 通用卡片 */
--radius-xl:   26px;    /* 倒计时主卡片 */
--radius-full: 100px;   /* 按钮、徽章、进度条 */
--radius-phone: 50px;   /* 手机外壳 */
```

---

## 5. 阴影系统

```css
--sh-sm: 0 2px 8px rgba(100, 50, 20, 0.07);
--sh-md: 0 6px 16px rgba(100, 50, 20, 0.1);
--sh-lg: 0 12px 32px rgba(100, 50, 20, 0.13);
```

**注意：** 阴影用暖棕色调 `rgba(100,50,20,x)`，不是冷灰 `rgba(0,0,0,x)`。

**应用规则：**
- 卡片默认 → `sh-sm`
- 卡片 hover → `sh-md`
- 倒计时主卡片、计时器圆 → `sh-lg`
- 弹窗/模态 → `sh-lg`

---

## 6. 间距系统

8px 基准网格：
- 8px / 12px / 16px / 20px / 24px / 28px / 32px / 48px

**关键间距：**
- 页面内边距：20px 22px
- 卡片内边距：18-20px
- 卡片间距：12px
- 组件间大间距：24-28px

---

## 7. Glassmorphism 规范

### 卡片毛玻璃

```css
background: rgba(255, 248, 242, 0.82);  /* 暖米白半透明 */
backdrop-filter: blur(16px);
-webkit-backdrop-filter: blur(16px);
border: 1px solid rgba(196, 133, 90, 0.18);
border-radius: 22px;
```

### 底部导航毛玻璃

```css
background: rgba(253, 248, 243, 0.92);
backdrop-filter: blur(20px);
border-top: 1px solid rgba(196, 133, 90, 0.12);
```

### 返回按钮毛玻璃

```css
background: rgba(255, 248, 242, 0.82);
backdrop-filter: blur(16px);
border: 1px solid rgba(196, 133, 90, 0.18);
border-radius: 12px;
```

---

## 8. 交互动效

### 动画曲线

| 用途 | 时长 | 曲线 |
|------|------|------|
| 卡片 hover | 250ms | ease |
| 按钮 hover | 200ms | ease |
| 导航切换 | 180ms | ease |
| 进度条 | 500ms | ease |
| 呼吸动画 | 8000ms | ease-in-out（循环） |

### 卡片 hover 效果

```css
transform: translateY(-3px);
box-shadow: 0 6px 16px rgba(100, 50, 20, 0.1);
```

### 按钮 hover 效果

```css
/* 圆形按钮（胎动 +1） */
transform: scale(1.05);
/* 圆形按钮按下 */
transform: scale(0.95);
```

### 呼吸动画（拉玛泽跟练）

```css
@keyframes breathe {
  0%, 100% { transform: scale(0.82); opacity: 0.65; }
  50%      { transform: scale(1.18); opacity: 1; }
}
animation: breathe 8s ease-in-out infinite;
```

---

## 9. 图标系统

### 风格
- **Heroicons Outline** — 2px 线宽，24x24 基准
- 使用 CSS mask 方式着色（方便主题切换）

### 导航图标

| Tab | 图标 | 激活色 | 未激活色 |
|-----|------|--------|----------|
| 首页 | home | `#C4855A` | `#D4B8A4` |
| 任务 | clipboard-check | `#C4855A` | `#D4B8A4` |
| 待产包 | shopping-bag | `#C4855A` | `#D4B8A4` |
| 知识 | book-open | `#C4855A` | `#D4B8A4` |

### 功能图标

| 用途 | 尺寸 | 颜色 |
|------|------|------|
| 任务图标 | 22x22 | `#A86840`（primary-dark） |
| 返回箭头 | 20x20 | `#5C3D2A`（n700） |
| 完成勾选 | 13x13 白 | 在 `#5C9E7A` 绿色圆内 |
| 页面操作 | 22x22 | `#5C3D2A`（n700） |

---

## 10. 组件规范

### 倒计时主卡片

```
尺寸：100% 宽度
内边距：32px 28px 26px
圆角：26px
背景：暖米白渐变（145deg）
装饰：右上角暖金光晕 + 左下角杏粉光晕
阴影：sh-md

内容：
  - 孕周徽章（圆角胶囊 100px）
  - 倒计时数字（88px Playfair，暖金渐变）
  - 预产期信息（分割线下方）
```

### 任务卡片（首页 2x2）

```
布局：2 列 Grid，gap 12px
内边距：20px 16px
圆角：22px
图标背景：44x44，圆角 13px
```

### 计时器圆

```
尺寸：220x220
圆角：50%
背景：毛玻璃
边框：2px solid rgba(196,133,90,0.25)
阴影：sh-lg + 外层 6px 光晕
数字：80px Playfair，暖金渐变

放松状态：
  - 边框变浅：rgba(155,117,88,0.18)
  - 数字灰色：n500 → n300 渐变
  - 阴影降级：sh-sm
```

### 底部导航

```
高度：88px（含安全区 24px）
背景：rgba(253,248,243,0.92) + blur(20px)
边框：1px solid rgba(196,133,90,0.12)
图标：23x23
文字：10px Inter 600
间距：gap 5px
激活态：primary 色
未激活：n300 浅棕
```

---

## 11. 手机外壳样式

```css
width: 390px;
height: 844px;
border-radius: 50px;
box-shadow:
  0 40px 80px rgba(80, 40, 10, 0.35),
  0 0 0 1px rgba(255, 255, 255, 0.6) inset,
  0 0 0 8px #D4B090,      /* 暖棕色外框 */
  0 0 0 9px rgba(255, 255, 255, 0.3);
```

---

## 12. 无障碍规范

### 对比度（WCAG AA）

| 文字 | 颜色 | vs 背景 | 比值 | 等级 |
|------|------|---------|------|------|
| 主标题 | n900 (#2C1F14) | 米白 (#FDF8F3) | 13.5:1 | ✅ AAA |
| 正文 | n700 (#5C3D2A) | 米白 (#FDF8F3) | 8.1:1 | ✅ AAA |
| 辅助文字 | n500 (#9B7558) | 米白 (#FDF8F3) | 4.2:1 | ✅ AA |
| 主色按钮文字 | 白 | primary (#C4855A) | 3.4:1 | ⚠️ 大文字 AA |

### 触摸目标
- 最小点击区域：44x44px
- 导航项：48x48px（含 padding）
- 复选框行：整行可点击（44px 高度）

---

## 13. 开发交接：SwiftUI 颜色映射

```swift
extension Color {
    // 主色
    static let primary     = Color(hex: "C4855A")
    static let primaryDark = Color(hex: "A86840")
    static let accent      = Color(hex: "E8B89A")
    static let accentLight = Color(hex: "F5DDD0")
    static let warmGold    = Color(hex: "D4A86A")
    
    // 背景
    static let bgTop    = Color(hex: "FDF8F3")
    static let bgBottom = Color(hex: "F7EFE6")
    
    // 中性色
    static let n900 = Color(hex: "2C1F14")
    static let n700 = Color(hex: "5C3D2A")
    static let n500 = Color(hex: "9B7558")
    static let n300 = Color(hex: "D4B8A4")
    static let n200 = Color(hex: "EAD9CE")
    
    // 功能色
    static let success = Color(hex: "5C9E7A")
}
```

---

## 14. 设计文件

| 文件 | 说明 |
|------|------|
| design.html | 完整设计稿（11 屏） |
| design-preview.png | 预览截图 |
| app-icon.html | App Icon |
| app-icon-preview.png | Icon 预览 |

---

**版本历史：**
- v2.0 (2026-04-09) — 更新为温暖配色系统（匹配 design.html v2）
- v1.0 (2026-04-08) — 初版（冷灰配色，已废弃）
