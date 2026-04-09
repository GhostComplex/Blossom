# 如期 App - Design Specification v1.0

**最后更新：** 2026-04-08  
**设计风格：** Glassmorphism + Soft UI Evolution + Classic Elegant

---

## 1. 设计理念

**核心价值：**
- 温暖而不幼稚
- 精致而不冷淡
- 清晰而不花哨
- 成熟而不甜腻

**参考标准：**
- Headspace（冥想健康）
- Calm（放松健康）
- Flo（女性健康）

---

## 2. 配色系统

### 主色调（玫瑰金系）

```css
--primary: #C9A084;        /* 玫瑰金（金色基底+粉调） */
--primary-dark: #B5846C;   /* 深玫瑰金 */
--accent: #DDB8A8;         /* 温柔裸粉金 */
--accent-light: #F0DDD3;   /* 浅裸粉 */
```

### 中性色（Stone 灰）

```css
--neutral-50: #FAFAF9;     /* 浅灰背景 */
--neutral-100: #F5F5F4;
--neutral-200: #E7E5E4;    /* 分割线 */
--neutral-300: #D6D3D1;
--neutral-500: #78716C;    /* 次要文字 */
--neutral-700: #44403C;    /* 深灰文字 */
--neutral-900: #1C1917;    /* 主文字 */
```

### 功能色

```css
--success: #10B981;        /* 完成状态 - green-500 */
--warning: #F59E0B;        /* 提醒 - amber-500 */
--error: #EF4444;          /* 错误 - red-500 */
```

### 背景系统

```css
--bg: linear-gradient(180deg, #FAFAF9 0%, #F5F5F4 100%);
--glass-bg: rgba(255, 255, 255, 0.7);
--glass-border: rgba(201, 160, 132, 0.2);
```

### 色彩应用规则

| 元素 | 颜色 | 备注 |
|------|------|------|
| 页面背景 | `--bg` 渐变 | 顶部浅，底部稍深 |
| 卡片背景 | `--glass-bg` | 毛玻璃效果 |
| 卡片边框 | `--glass-border` | 玫瑰金半透明 |
| 主标题 | `--neutral-900` | 最高对比度 |
| 正文 | `--neutral-700` | 次级文字 |
| 辅助文字 | `--neutral-500` | 标签、说明 |
| 按钮 | `--primary` | 主要操作 |
| 图标激活 | `--primary` | 导航激活态 |
| 图标未激活 | `--neutral-500` | 导航默认态 |

---

## 3. 字体系统

### 字体家族

```css
/* 标题字体 - 衬线体 */
font-family: 'Playfair Display', serif;

/* 正文字体 - 无衬线体 */
font-family: 'Inter', -apple-system, sans-serif;
```

**Google Fonts 引入：**
```html
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
```

### 字体层级

| 用途 | 字体 | 大小 | 字重 | 行高 | 字间距 |
|------|------|------|------|------|--------|
| H1 大标题 | Playfair | 36px | 600 | 1.1 | -0.5px |
| H2 章节标题 | Playfair | 22px | 600 | 1.2 | -0.3px |
| 数字大号 | Playfair | 84px | 700 | 0.9 | -3px |
| 数字单位 | Playfair | 28px | 600 | 1.0 | 0.5px |
| 标签文字 | Playfair | 16px | 500 | 1.3 | 0.2px |
| 正文 | Inter | 15px | 600 | 1.4 | -0.2px |
| 小文字 | Inter | 13px | 500 | 1.3 | 0.2px |
| 徽章 | Inter | 12px | 600 | 1.0 | 0.3px |
| 导航标签 | Inter | 11px | 600 | 1.0 | 0.2px |

### 字体应用规则

- **标题/数字** → Playfair Display（优雅、高级感）
- **正文/按钮/标签** → Inter（清晰、现代）
- **中文** → 自动回退到系统字体（-apple-system）

---

## 4. 圆角系统

```css
--radius-sm: 10px;     /* 小元素：徽章、按钮 */
--radius-md: 16px;     /* 中元素：图标背景、进度卡片 */
--radius-lg: 20px;     /* 大元素：任务卡片 */
--radius-xl: 24px;     /* 超大元素：主卡片 */
--radius-2xl: 28px;    /* 最大：倒计时卡片 */
--radius-full: 9999px; /* 圆形：徽章、进度条 */
```

---

## 5. 阴影系统

```css
--shadow-xs: 0 1px 2px rgba(0, 0, 0, 0.04);
--shadow-sm: 0 2px 4px rgba(0, 0, 0, 0.06), 0 1px 2px rgba(0, 0, 0, 0.03);
--shadow-md: 0 4px 8px rgba(0, 0, 0, 0.08), 0 2px 4px rgba(0, 0, 0, 0.04);
--shadow-lg: 0 8px 16px rgba(0, 0, 0, 0.1), 0 4px 8px rgba(0, 0, 0, 0.05);
--shadow-xl: 0 16px 32px rgba(0, 0, 0, 0.12), 0 8px 16px rgba(0, 0, 0, 0.06);
```

**应用规则：**
- 徽章 → `shadow-xs`
- 卡片默认 → `shadow-sm`
- 卡片 hover → `shadow-md`
- 主卡片 → `shadow-lg`
- 弹窗/模态 → `shadow-xl`

---

## 6. 间距系统

```css
--space-2: 8px;
--space-3: 12px;
--space-4: 16px;
--space-5: 20px;
--space-6: 24px;
--space-8: 32px;
--space-10: 40px;
--space-12: 48px;
```

**8px 基准网格：** 所有间距、尺寸都是 8 的倍数。

---

## 7. 交互动效

### 动画曲线

```css
/* 标准缓动 - 所有交互默认使用 */
cubic-bezier(0.4, 0, 0.2, 1)

/* 快速淡入 - 文字/小元素 */
cubic-bezier(0, 0, 0.2, 1)

/* 弹性 - 强调动作 */
cubic-bezier(0.68, -0.55, 0.265, 1.55)
```

### 动画时长

| 用途 | 时长 | 曲线 |
|------|------|------|
| Hover 状态 | 200ms | cubic-bezier(0.4, 0, 0.2, 1) |
| 卡片点击 | 150ms | cubic-bezier(0.4, 0, 0.2, 1) |
| 页面切换 | 280ms | cubic-bezier(0, 0, 0.2, 1) |
| 进度条 | 500ms | cubic-bezier(0.4, 0, 0.2, 1) |
| 模态弹出 | 300ms | cubic-bezier(0.68, -0.55, 0.265, 1.55) |

### Hover 效果

**卡片 hover：**
```css
transform: translateY(-4px);
box-shadow: var(--shadow-md);
border-color: rgba(201, 160, 132, 0.35);
transition: all 280ms cubic-bezier(0.4, 0, 0.2, 1);
```

**按钮 hover：**
```css
transform: scale(1.02);
background: var(--primary-dark);
transition: all 200ms cubic-bezier(0.4, 0, 0.2, 1);
```

**导航 hover：**
```css
background: rgba(201, 160, 132, 0.1);
transition: all 200ms ease;
```

---

## 8. Glassmorphism 规范

### 毛玻璃效果

```css
background: rgba(255, 255, 255, 0.7);
backdrop-filter: blur(20px);
-webkit-backdrop-filter: blur(20px);
border: 1px solid rgba(201, 160, 132, 0.2);
```

**应用元素：**
- 倒计时卡片
- 任务卡片
- 进度卡片
- 底部导航

**注意事项：**
- 必须同时设置 `backdrop-filter` 和 `-webkit-backdrop-filter`
- 边框必须使用半透明玫瑰金
- 背景透明度 0.7 最佳（既有毛玻璃效果，又不影响文字对比度）

---

## 9. 图标系统

### 图标风格

**Heroicons 风格 - Outline 版本**
- 线宽：2px
- 尺寸：24x24px
- 圆角：圆润
- SVG mask 方式着色

### 图标应用

**导航图标（24x24）：**
```css
.nav-icon {
  width: 24px;
  height: 24px;
  background: var(--neutral-500);
  -webkit-mask-size: contain;
  mask-size: contain;
}

.nav-icon.active {
  background: var(--primary);
}
```

**任务图标（24x24）：**
```css
.task-icon {
  width: 24px;
  height: 24px;
  background: var(--primary-dark);
}
```

### 图标库

| 用途 | 图标 | SVG 路径 |
|------|------|----------|
| 首页 | home | Heroicons outline/home |
| 任务 | clipboard-check | Heroicons outline/clipboard-check |
| 待产包 | shopping-bag | Heroicons outline/shopping-bag |
| 知识 | book-open | Heroicons outline/book-open |
| 凯格尔 | hand | Heroicons outline/hand |
| 拉玛泽 | light-bulb | Heroicons outline/light-bulb |
| 日历 | calendar | Heroicons outline/calendar |
| 完成 | check | Heroicons outline/check |

---

## 10. 组件规范

### 10.1 倒计时卡片

**尺寸：**
- 宽度：100%
- 内边距：40px 32px
- 圆角：28px

**内容结构：**
1. 徽章（孕周）
2. 倒计时主体（数字 + 单位）
3. 预产期信息

**渐变光晕：**
- 右上角：250px 圆形，玫瑰金 15% 透明度
- 左下角：200px 圆形，裸粉 12% 透明度

### 10.2 任务卡片

**尺寸：**
- Grid 2 列布局
- Gap：16px
- 内边距：24px
- 圆角：20px

**内容结构：**
1. 图标背景（52x52，渐变）
2. 任务标题（15px，Inter 600）
3. 任务状态（13px，Inter 500）

**状态样式：**
- 完成：绿色文字 + 勾选图标
- 待完成：灰色文字
- 进度：玫瑰金文字

### 10.3 进度卡片

**尺寸：**
- 宽度：100%
- 内边距：24px
- 圆角：20px

**进度条：**
- 高度：6px
- 背景：`--neutral-200`
- 填充：玫瑰金渐变
- 圆角：100px（全圆）
- 动画：500ms 缓动

### 10.4 底部导航

**尺寸：**
- 高度：88px（包含安全区 24px）
- 毛玻璃背景：rgba(255,255,255,0.85)
- 边框：玫瑰金 15% 透明度

**导航项：**
- 图标：24x24
- 文字：11px，Inter 600
- 间距：6px
- Padding：12px 16px
- 激活态：玫瑰金
- 默认态：灰色

---

## 11. 响应式规范

**设计基准：** iPhone 13 Pro (390x844)

**适配策略：**
- 宽度：100% 流式布局
- 最小宽度：375px（iPhone SE）
- 最大宽度：430px（iPhone 14 Pro Max）
- 间距：按比例缩放

**安全区：**
- 顶部状态栏：54px
- 底部安全区：24px（Home Indicator）

---

## 12. 无障碍规范

### 对比度

**文字对比度（WCAG AA）：**
- 主文字（neutral-900）vs 白背景：**14.8:1** ✅ AAA
- 正文（neutral-700）vs 白背景：**9.2:1** ✅ AAA
- 辅助文字（neutral-500）vs 白背景：**4.6:1** ✅ AA
- 玫瑰金（primary）vs 白背景：**3.8:1** ⚠️ （仅装饰用）

### 触摸目标

- 最小点击区域：44x44px
- 导航图标：48x48px 点击区（含 padding）
- 任务卡片：整个卡片可点击

### 焦点状态

```css
:focus-visible {
  outline: 2px solid var(--primary);
  outline-offset: 2px;
}
```

---

## 13. 性能规范

### 图片

- 格式：WebP（备选 PNG）
- 压缩：TinyPNG 压缩至 <100KB
- 图标：全部使用 SVG mask

### 动画

- 使用 CSS transform（GPU 加速）
- 避免 width/height 动画
- 使用 will-change 提示浏览器

### 字体

- 字重：仅加载必需字重（400/500/600/700）
- 显示：`font-display: swap`
- 子集：中文使用系统字体

---

## 14. 导出资源

### App Icon

- 尺寸：1024x1024
- 格式：PNG（无透明度）
- 内容：玫瑰金色系抽象图形（待设计）

### 截图模板

- 尺寸：1290x2796（iPhone 14 Pro Max）
- 背景：品牌渐变
- 标题：Playfair Display
- 说明：Inter

---

## 15. 设计文件

**Figma 文件结构：**
```
如期 App
├── Design System
│   ├── Colors
│   ├── Typography
│   ├── Components
│   └── Icons
├── Pages
│   ├── 01-首页
│   ├── 02-任务详情
│   ├── 03-待产包
│   └── 04-知识卡片
└── Prototypes
    └── User Flow
```

---

## 16. 开发交接

### CSS Variables 导出

```css
:root {
  /* Colors */
  --primary: #C9A084;
  --primary-dark: #B5846C;
  --accent: #DDB8A8;
  --accent-light: #F0DDD3;
  
  /* Neutrals */
  --neutral-50: #FAFAF9;
  --neutral-100: #F5F5F4;
  --neutral-200: #E7E5E4;
  --neutral-300: #D6D3D1;
  --neutral-500: #78716C;
  --neutral-700: #44403C;
  --neutral-900: #1C1917;
  
  /* Functional */
  --success: #10B981;
  --warning: #F59E0B;
  --error: #EF4444;
  
  /* Shadows */
  --shadow-xs: 0 1px 2px rgba(0, 0, 0, 0.04);
  --shadow-sm: 0 2px 4px rgba(0, 0, 0, 0.06), 0 1px 2px rgba(0, 0, 0, 0.03);
  --shadow-md: 0 4px 8px rgba(0, 0, 0, 0.08), 0 2px 4px rgba(0, 0, 0, 0.04);
  --shadow-lg: 0 8px 16px rgba(0, 0, 0, 0.1), 0 4px 8px rgba(0, 0, 0, 0.05);
  
  /* Spacing (8px grid) */
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-5: 20px;
  --space-6: 24px;
  --space-8: 32px;
  --space-10: 40px;
  --space-12: 48px;
  
  /* Radius */
  --radius-sm: 10px;
  --radius-md: 16px;
  --radius-lg: 20px;
  --radius-xl: 24px;
  --radius-2xl: 28px;
  --radius-full: 9999px;
}
```

---

**版本历史：**
- v1.0 (2026-04-08) - 初版设计规范
