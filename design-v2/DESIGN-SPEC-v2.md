# 拾月 · Blossom — Design Spec v2.0

**最后更新：** 2026-04-11

---

## 配色系统

| 名称 | 色值 | 用途 |
|------|------|------|
| Pink | `#F9B5C4` | 渐变起点、icon 背景 |
| Pink Light | `#FDDDE6` | 渐变辅助 |
| Pink Pale | `#FEF0F3` | 页面背景渐变起点 |
| Lavender | `#C4B5E0` | 渐变中段、进度条 |
| Lavender Pale | `#EDE7F8` | 背景辅助 |
| Sky | `#B8DCF5` | 渐变终点、icon 背景 |
| Accent | `#C9A0DC` | 按钮、圆环、强调色 |
| Accent Dark | `#A87CC0` | Active Tab、按钮深色 |
| Text Dark | `#3A2F50` | 标题、主要文字 |
| Text Mid | `#7A6E94` | 正文、次要文字 |
| Text Light | `#AEA3C4` | 辅助文字、描述 |
| Success | `#7BC4A0` | 完成状态 |

## 背景渐变

**页面背景：**
```css
background: linear-gradient(170deg, #FEF6F8 0%, #F6EDF8 35%, #EDF2FC 70%, #F4F0FA 100%);
```

**倒计时卡片：**
```css
background: linear-gradient(140deg, rgba(249,181,196,0.5), rgba(196,181,224,0.45), rgba(184,220,245,0.4));
```

## 字体

| 用途 | 字体 | 字重 | 大小 |
|------|------|------|------|
| 页面大标题 | Cormorant Garamond | 400 | 24-28px |
| 倒计时数字 | Cormorant Garamond | 300 | 60-72px |
| 计时器数字 | Cormorant Garamond | 300 | 52-60px |
| 卡片标题 | Nunito | 500-600 | 13-14px |
| 正文 | Nunito | 400 | 12-13px |
| 描述/辅助 | Nunito | 400 | 10-11px |

## 卡片系统

```css
background: rgba(255,255,255,0.45);
backdrop-filter: blur(24px);
border: 1px solid rgba(255,255,255,0.6);
border-radius: 20px;
box-shadow: 0 2px 16px rgba(196,181,224,0.08);
```

## 按钮

**主按钮（浅色背景上）：**
```css
background: var(--accent); /* #C9A0DC */
color: white;
border-radius: 14px;
padding: 13px 32px;
font-weight: 600;
```

**次按钮：**
```css
background: rgba(255,255,255,0.5);
backdrop-filter: blur(8px);
border: 1px solid rgba(255,255,255,0.6);
color: var(--text-mid);
```

## Tab Bar

- 背景：`rgba(255,255,255,0.35)` + `blur(24px)`
- Active：`var(--accent-dark)` + 底部 4px 圆点
- Inactive：`var(--text-light)`
- 图标：SVG stroke 1.5px

## 圆环计时器

- Track：`2px solid rgba(183,168,214,0.2)`
- Progress：`2.5px solid var(--accent)`
- Glow：`box-shadow: 0 0 30px rgba(196,160,220,0.15)`
- Center：`rgba(255,255,255,0.4)` + `blur(16px)`

## 装饰元素

- 背景光晕：`radial-gradient` 粉色/紫色圆形
- 弧形装饰：1px 半透明 border 圆弧
- 白色圆形装饰：在卡片内 `::before` / `::after`

## App Icon

- 背景：粉紫蓝三色渐变
- 前景：含苞待放花朵（6 外瓣 + 6 内瓣 + 珍珠花蕊）
- 花瓣颜色：粉 `#F9B5C4` + 紫 `#D4BCE8` + 蓝 `#B8DCF5`
- 尺寸：1024 / 180 / 120

## Accessibility

- 所有页面使用深色文字 `#3A2F50` 在浅色背景上（对比度 10+）
- 不使用白色文字在浅色渐变上
- 按钮文字白色仅在 `var(--accent)` 背景上（对比度 4.5+）
