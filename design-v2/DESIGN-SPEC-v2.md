# 拾月 · Blossom — Design Spec v2.1（完整版）

**最后更新：** 2026-04-11  
**基准：** `design-v2/design.html`（所有值从 HTML CSS 提取）

---

## 1. 配色系统

| 变量名 | 色值 | 用途 |
|--------|------|------|
| `--pink` | `#F9B5C4` | icon 背景（凯格尔）、渐变起点 |
| `--pink-light` | `#FDDDE6` | 渐变辅助 |
| `--pink-pale` | `#FEF0F3` | 页面背景渐变起点 |
| `--lavender` | `#C4B5E0` | icon 背景（拉玛泽）、进度条终点 |
| `--lavender-pale` | `#EDE7F8` | 背景辅助 |
| `--sky` | `#B8DCF5` | icon 背景（待产包）、渐变终点 |
| `--accent` | `#C9A0DC` | 按钮、圆环 progress、icon 背景（知识） |
| `--accent-dark` | `#A87CC0` | Active Tab、按钮深色 |
| `--text-dark` | `#3A2F50` | 标题、主文字 |
| `--text-mid` | `#7A6E94` | 正文、次要文字 |
| `--text-light` | `#AEA3C4` | 辅助文字、Tab inactive |
| `--success` | `#7BC4A0` | 完成状态 |

## 2. 页面背景

```css
background: linear-gradient(170deg, #FEF6F8 0%, #F6EDF8 35%, #EDF2FC 70%, #F4F0FA 100%);
```
装饰光晕（::before / ::after）：
- 右上：`radial-gradient(circle, rgba(249,181,196,0.25) 0%, transparent 70%)` 260×260px
- 左下：`radial-gradient(circle, rgba(196,181,224,0.2) 0%, transparent 70%)` 220×220px

## 3. 字体

| 用途 | 字体 | PostScript Name | 字重 | 大小 |
|------|------|----------------|------|------|
| 问候语「下午好」 | Cormorant Garamond | CormorantGaramond-Regular | 400 | 26px |
| 倒计时数字「65」 | Cormorant Garamond | CormorantGaramond-Light | 300 | 72px |
| 「距离与宝宝见面」 | Nunito | — | 400 | 13px |
| 「天」 | Nunito | — | 400 | 15px |
| 预产期日期 | Nunito | — | 400 | 11px |
| 卡片标题「凯格尔运动」 | Nunito | — | 500 | 13px |
| 卡片描述「初级·3分钟」 | Nunito | — | 400 | 10.5px |
| 进度条标题 | Nunito | — | 600 | 12px |
| 进度条数字 | Nunito | — | 500 | 12px |
| 凯格尔级别 | Nunito | — | 400 | 11px (uppercase) |
| 凯格尔阶段 | Cormorant Garamond | CormorantGaramond-Regular | 400 | 26px |
| 凯格尔倒计时 | Cormorant Garamond | CormorantGaramond-Light | 300 | 60px |
| 凯格尔「秒」 | Nunito | — | 400 | 11px |
| 凯格尔组数 | Nunito | — | 400 | 12px |
| 凯格尔按钮 | Nunito | — | 600 | 13px |
| 完成页标题 | Cormorant Garamond | CormorantGaramond-Regular | 400 | 30px |
| 完成页正文 | Nunito | — | 300 | 14px |
| 完成页英文 | Nunito | — | 300 | 11px (italic) |
| 完成页按钮 | Nunito | — | 600 | 14px |
| Onboarding 标题 | Cormorant Garamond | CormorantGaramond-Regular | 400 | 28px |
| Onboarding 正文 | Nunito | — | 400 | 13px |
| 通知弹窗标题 | Cormorant Garamond | CormorantGaramond-Regular | 400 | 20px |
| 通知弹窗正文 | Nunito | — | 400 | 13px |
| 通知弹窗按钮 | Nunito | — | 600 | 14px |
| Tab Bar 文字 | Nunito | — | 500 | 9.5px |

## 4. 倒计时卡片

```css
background: linear-gradient(140deg, rgba(249,181,196,0.5) 0%, rgba(196,181,224,0.45) 50%, rgba(184,220,245,0.4) 100%);
backdrop-filter: blur(20px);
border: 1px solid rgba(255,255,255,0.5);
border-radius: 28px;
box-shadow: 0 8px 40px rgba(196,160,220,0.12);
```
倒计时数字颜色：`var(--text-dark)` #3A2F50
孕周 badge：`rgba(255,255,255,0.35) + blur(8px)` 文字 `var(--text-mid)`

## 5. 任务卡片

```css
background: rgba(255,255,255,0.45);
backdrop-filter: blur(24px);
border: 1px solid rgba(255,255,255,0.7);
border-radius: 20px;
box-shadow: 0 2px 16px rgba(196,181,224,0.08);
```

### icon 规则：彩色渐变背景 + 白色 stroke icon

| 卡片 | icon 背景渐变 | icon SVG |
|------|-------------|---------|
| 凯格尔 | `linear-gradient(135deg, rgba(249,181,196,0.5), rgba(249,181,196,0.8))` | stroke="white" stroke-width="2" fill="none" |
| 拉玛泽 | `linear-gradient(135deg, rgba(196,181,224,0.5), rgba(196,181,224,0.8))` | stroke="white" stroke-width="2" fill="none" |
| 待产包 | `linear-gradient(135deg, rgba(184,220,245,0.5), rgba(184,220,245,0.8))` | stroke="white" stroke-width="2" fill="none" |
| 知识 | `linear-gradient(135deg, rgba(201,160,220,0.5), rgba(201,160,220,0.8))` | stroke="white" stroke-width="2" fill="none" |

icon 容器：`40×40px, border-radius: 13px`

## 6. 进度条

```css
/* 轨道 */
height: 7px;
background: rgba(196,181,224,0.12);
border-radius: 3px;

/* 填充 */
background: linear-gradient(90deg, #F9B5C4, #C4B5E0);
```

## 7. 按钮

**主按钮：**
```css
background: var(--accent); /* #C9A0DC */
color: white;
border-radius: 14px;
padding: 13px 32px;
font: Nunito 600 14px;
box-shadow: 0 4px 16px rgba(196,160,220,0.2);
```

**次按钮：**
```css
background: rgba(255,255,255,0.5);
backdrop-filter: blur(8px);
border: 1px solid rgba(255,255,255,0.6);
border-radius: 14px;
color: var(--text-mid);
font: Nunito 500 13px;
```

## 8. Tab Bar（自定义实现）

```css
/* 容器 */
background: rgba(255,255,255,0.35);
backdrop-filter: blur(24px);
border-top: 1px solid rgba(255,255,255,0.4);
padding: 8px 0 28px;

/* Tab item */
font: Nunito 500 9.5px;
color: #AEA3C4;  /* inactive */

/* Active */
color: #A87CC0;
```
icon: SVG 18×18, stroke: 1.5px, fill: none

## 9. 凯格尔计时器

```css
/* 背景 */
background: linear-gradient(165deg, #FEF2F6 0%, #F0E4F6 35%, #E8DEF4 65%, #E0D6F0 100%);

/* 圆环 track */
border: 2px solid rgba(183,168,214,0.2);

/* 圆环 progress */
border: 2.5px solid var(--accent);

/* 圆环 glow */
box-shadow: 0 0 30px rgba(196,160,220,0.15);

/* 圆环中心 */
background: rgba(255,255,255,0.4);
backdrop-filter: blur(16px);
```

## 10. 完成页

```css
background: linear-gradient(165deg, #FEF4F7 0%, #F0E6F6 30%, #E6EAF8 60%, #E8F0FC 100%);
```
✓ 圆：80×80, `rgba(196,160,220,0.15) + blur(12px) + border 1.5px rgba(196,160,220,0.3)`
glow: `box-shadow: 0 0 50px rgba(196,160,220,0.2), 0 0 100px rgba(196,160,220,0.1)`
装饰光圈：`radial-gradient` × 2

## 11. App Icon

- 背景：`linear-gradient(145deg, #FDDDE6 0%, #D4BCE8 40%, #B7A8D6 70%, #A8C8E8 100%)`
- 花瓣：粉 `#F9B5C4` + 紫 `#D4BCE8` + 蓝 `#B8DCF5`
- 尺寸：1024 / 180 / 120

## 12. Accessibility

- 深色文字 `#3A2F50` 在浅色背景：对比度 10+
- 白色文字仅在 `var(--accent)` 按钮上：对比度 4.5+
- 中文标题 Cormorant Garamond 不含中文字形 → fallback 到系统字体（预期行为）
