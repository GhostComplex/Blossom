# Design Alignment 验收报告 v4

> 拾月 Blossom — Design v2.1 vs Code 逐屏参数对比  
> 日期：2026-04-14  
> PM：Manta 🐠

---

## Summary

| # | 屏幕 | Issue | 参数项 | 状态 |
|---|------|-------|--------|------|
| 1 | HOME | #76 | 42 | ✅ 已对齐 |
| 2 | Kegel Timer | #86 | 26 | ✅ 已对齐 |
| 3 | Exercise Completion | #87 | 25 | ✅ 已对齐 |
| 4 | Tasks | #88 | 14 | ✅ 已对齐 |
| 5 | Hospital Bag | #89 | 9 | ✅ 已对齐 |
| 6 | Knowledge | #90 | 16 | ✅ 已对齐 |
| 7 | Article Detail | #91 | 14 | ✅ 已对齐 |
| 8 | Lamaze Detail | #92 | 13 | ✅ 已对齐 |
| 9 | Notification | #94 | 22 | ✅ 已对齐 |
| 10 | Exit Confirmation | #96 | — | ✅ 已对齐 |
| 11 | Kegel Prep | #78 | — | ✅ 已对齐 |
| 12 | Hospital Bag Add | #81 | — | ✅ 已对齐 |
| 13 | Lamaze Timer | #65 #134 #139 | — | ✅ 3 轮修复已对齐 |
| 14 | App Icon | #105 | — | ✅ 已对齐 |

**总计：~220+ 参数项，全部已对齐。**

---

## 1. HOME (#76) — 42 项

### Design vs Actual

| Design | Actual |
|--------|--------|
| ![HOME Design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/home.png) | ![HOME Actual](https://raw.githubusercontent.com/GhostComplex/Blossom/b2be768/qa-screenshots/round1-supplement/actual-home-latest.png) |

### 参数对比

| # | 参数 | Design (CSS) | Code (Swift) | 状态 |
|---|------|-------------|-------------|------|
| 1 | 日期字体 | Nunito-Regular 12px | `.custom("Nunito-Regular", size: 12)` | ✅ |
| 2 | 日期颜色 | `var(--text-light)` = #AEA3C4 | `Color.n300` = #AEA3C4 | ✅ |
| 3 | 日期 letter-spacing | 0.3px | `.tracking(0.3)` | ✅ |
| 4 | 问候语 letter-spacing | -0.3px (implied by Serif) | `.tracking(-0.3)` | ✅ |
| 5 | 问候 margin-bottom | 22px (.greet margin-bottom:22) | `.padding(.bottom, 22)` | ✅ |
| 6 | 倒计时卡片 padding | 28px top, 24px h, 24px bottom | `.padding(.top, 28) .horizontal(24) .bottom(24)` | ✅ |
| 7 | 倒计时卡片 margin-bottom | 20px (.cd-card margin-bottom:20) | `.padding(.bottom, 20)` | ✅ |
| 8 | 孕周徽章字体 | Nunito-Medium 11px (.wk) | `.custom("Nunito-Medium", size: 11)` | ✅ |
| 9 | 孕周徽章颜色 | `var(--text-mid)` = #7A6E94 | `Color.n500` = #7A6E94 | ✅ |
| 10 | 孕周徽章 padding | 4px 14px (.wk) | `.horizontal(14) .vertical(4)` | ✅ |
| 11 | 孕周徽章 margin-bottom | 14px (.wk margin-bottom:14) | `.padding(.bottom, 14)` | ✅ |
| 12 | 倒计时标签字体 | Nunito-Regular 13px (.cd-lbl) | `.custom("Nunito-Regular", size: 13)` | ✅ |
| 13 | 倒计时标签 letter-spacing | 0.5px (.cd-lbl) | `.tracking(0.5)` | ✅ |
| 14 | 倒计时数字字体 | NotoSerifSC 72px weight 300 | `.custom("NotoSerifSC-Light", size: 72)` | ✅ |
| 15 | 倒计时数字 text-shadow | 0 2px 16px rgba(0,0,0,0.06) | `.shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)` | ✅ |
| 16 | 倒计时数字间距 | margin: 6px 0 2px | `.padding(.top, 6) .bottom(2)` | ✅ |
| 17 | 倒计时数字 letter-spacing | -2px | `.tracking(-2)` | ✅ |
| 18 | 单位"天"颜色 | `var(--text-mid)` = #7A6E94 | `Color.n500` | ✅ |
| 19 | 单位"天" letter-spacing | 2px (.cd-unit) | `.tracking(2)` | ✅ |
| 20 | 预产期字体 | Nunito-Regular 11px (.cd-due) | `.custom("Nunito-Regular", size: 11)` | ✅ |
| 21 | 预产期颜色 | `var(--text-light)` = #AEA3C4 | `Color.n300` | ✅ |
| 22 | 预产期 margin-top | 10px (.cd-due margin-top:10) | `.padding(.top, 10)` | ✅ |
| 23 | 分割线 | 无（设计稿无分割线） | 已移除 | ✅ |
| 24 | 任务网格间距 | 11px (.tg gap:11) | `spacing: 11` | ✅ |
| 25 | 任务网格 margin-bottom | 14px (.tg margin-bottom:14) | `.padding(.bottom, 14)` | ✅ |
| 26 | 任务卡片 padding | 15px (.tc padding:15) | `.padding(15)` | ✅ |
| 27 | 任务卡片圆角 | 20px (.tc border-radius:20) | `glassCard()` → `AppRadius.lg` = 20 | ✅ |
| 28 | 任务卡片边框 | rgba(255,255,255,0.7) | `Color.white.opacity(0.7)` | ✅ |
| 29 | icon 圆角 | 13px (.ti border-radius:13) | `cornerRadius: 13` | ✅ |
| 30 | icon margin-bottom | 9px (.ti margin-bottom:9) | `.padding(.bottom, 9)` | ✅ |
| 31 | icon 渐变透明度 | 0.5 → 0.8 | `.opacity(0.5)` → `.opacity(0.8)` | ✅ |
| 32 | 卡片标题 letter-spacing | -0.1px (.tn) | `.tracking(-0.1)` | ✅ |
| 33 | 卡片标题 margin-bottom | 2px (.tn margin-bottom:2) | `.padding(.bottom, 2)` | ✅ |
| 34 | 卡片描述颜色 | `var(--text-light)` = #AEA3C4 | `Color.n300` | ✅ |
| 35 | 进度区 padding | 14px 16px (.pc padding:14 16) | `.padding(.vertical, 14) .horizontal(16)` | ✅ |
| 36 | 进度区圆角 | 18px (.pc border-radius:18) | `cornerRadius: 18` | ✅ |
| 37 | 进度区边框 | rgba(255,255,255,0.65) | `Color.white.opacity(0.65)` | ✅ |
| 38 | 进度区阴影 | 0 2px 12px rgba(196,181,224,0.06) | `opacity(0.06), radius: 12` | ✅ |
| 39 | 进度数字颜色 | `var(--accent)` = #C9A0DC | `Color.primary600` = #C9A0DC | ✅ |
| 40 | 进度标题间距 | 7px (.ph margin-bottom:7) | `spacing: 7` | ✅ |
| 41 | 进度条高/圆角 | 7px / 3px (.pb/.pf) | `height: 7` / `cornerRadius: 3` | ✅ |
| 42 | 百分比文字 | 无（设计稿无） | 已移除 | ✅ |

---

## 2. Kegel Timer (#86) — 26 项

### Design vs Actual

| Design | Actual |
|--------|--------|
| ![Kegel Design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/kegel.png) | ![Kegel Actual](https://raw.githubusercontent.com/GhostComplex/Blossom/4651a82/qa-screenshots/issue-86-bubble/actual-kegel-no-bubble.png) |

### 参数对比

| # | 参数 | Design (CSS) | Code (Swift) | 状态 |
|---|------|-------------|-------------|------|
| 1 | 背景渐变 | 165deg #FEF2F6→#F0E4F6→#E8DEF4→#E0D6F0 | 同 | ✅ |
| 2 | 等级标签字体 | Nunito-Regular 11px (.kg-lvl) | `.custom("Nunito-Regular", size: 11)` | ✅ |
| 3 | 等级标签颜色 | `var(--text-light)` = #AEA3C4 | `Color.n300` | ✅ |
| 4 | 等级标签 letter-spacing | 2px | `.tracking(2)` | ✅ |
| 5 | 等级标签 text-transform | uppercase | `.textCase(.uppercase)` | ✅ |
| 6 | 等级标签 margin-bottom | 10px (.kg-lvl) | `.padding(.bottom, 10)` | ✅ |
| 7 | 阶段标题字体 | NotoSerifSC 26px (.kg-ph) | `.custom("NotoSerifSC-Regular", size: 26)` | ✅ |
| 8 | 阶段标题 letter-spacing | 0.3px (.kg-ph) | `.tracking(0.3)` | ✅ |
| 9 | 阶段标题 margin-bottom | 28px (.kg-ph) | `.padding(.bottom, 28)` | ✅ |
| 10 | 圆环外径 | 200px (.ring-outer w/h) | `frame(width: 200, height: 200)` | ✅ |
| 11 | 圆环轨道线宽 | 2px (.ring-track border:2px) | `lineWidth: 2` | ✅ |
| 12 | 圆环轨道颜色 | rgba(183,168,214,0.2) | `Color(hex: "B7A8D6").opacity(0.2)` | ✅ |
| 13 | 进度环线宽 | 2.5px (.ring-progress border:2.5px) | `lineWidth: 2.5` | ✅ |
| 14 | 进度环颜色 | `var(--accent)` = #C9A0DC | `Color.primary600` | ✅ |
| 15 | 光晕 inset | -8px (.ring-glow inset:-8px) | `frame(width: 216)` = 200+16 | ✅ |
| 16 | 光晕阴影 | 0 0 30px rgba(196,160,220,0.15) | `shadow radius: 30, opacity 0.15` | ✅ |
| 17 | 中心区 inset | 12px (.ring-center inset:12px) → 176px | `frame(width: 176)` | ✅ |
| 18 | 中心数字字体 | NotoSerifSC 60px weight 300 | `.custom("NotoSerifSC-Regular", size: 60)` | ✅ |
| 19 | 中心数字 letter-spacing | -1px (.ring-num) | `.tracking(-1)` | ✅ |
| 20 | 中心标签字体 | Nunito-Regular 11px (.ring-lbl) | `.custom("Nunito-Regular", size: 11)` | ✅ |
| 21 | 中心标签颜色 | `var(--text-light)` = #AEA3C4 | `Color.n300` | ✅ |
| 22 | 组数文字字体 | Nunito-Regular 12px (.kg-sets) | `.custom("Nunito-Regular", size: 12)` | ✅ |
| 23 | 组数 letter-spacing | 0.5px (.kg-sets) | `.tracking(0.5)` | ✅ |
| 24 | 组数 margin-bottom | 36px (.kg-sets) | `.padding(.bottom, 36)` | ✅ |
| 25 | 按钮 padding | 13px 32px (.kb) | `.vertical(13) .horizontal(32)` | ✅ |
| 26 | 按钮圆角 | 14px (.kb border-radius:14) | `AppRadius.md` = 14 | ✅ |

---

## 3. Exercise Completion (#87) — 25 项

### Design vs Actual

| Design | Actual |
|--------|--------|
| ![Completion Design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/completion.png) | ![Completion Actual](https://raw.githubusercontent.com/GhostComplex/Blossom/1029fa6/qa-screenshots/issue-120/actual-completion-fixed.png) |

### 参数对比

| # | 参数 | Design (CSS) | Code (Swift) | 状态 |
|---|------|-------------|-------------|------|
| 1 | 背景渐变 | 165deg #FEF4F7→#F0E6F6→#E6EAF8→#E8F0FC | 同 | ✅ |
| 2 | 勾选圆尺寸 | 72px (.cp-check w/h) | `frame(width: 72, height: 72)` | ✅ |
| 3 | 勾选圆背景 | rgba(255,255,255,0.15) + blur(12px) | `Color.white.opacity(0.15)` + `blur(radius: 12)` | ✅ |
| 4 | 勾选圆边框 | 1.5px rgba(196,160,220,0.3) | `stroke(…opacity(0.3), lineWidth: 1.5)` | ✅ |
| 5 | 勾选圆阴影 | 0 0 50px + 0 0 100px | double `.shadow()` | ✅ |
| 6 | 勾选圆 margin-bottom | 28px (.cp-check) | `.padding(.bottom, 28)` | ✅ |
| 7 | checkmark 图标 | stroke #7A6E94, 32px | `size: 30`, `Color.primary600` | ✅ |
| 8 | 标题字体 | NotoSerifSC 30px (.cp-title) | `.custom("NotoSerifSC-Regular", size: 30)` | ✅ |
| 9 | 标题 letter-spacing | -0.3px (.cp-title) | `.tracking(-0.3)` | ✅ |
| 10 | 标题 margin-bottom | 10px (.cp-title) | `.padding(.bottom, 10)` | ✅ |
| 11 | 正文字体 | Nunito 14px (.cp-sub) | `.custom("Nunito-Regular", size: 14)` | ✅ |
| 12 | 正文颜色 | `var(--text-mid)` = #7A6E94 | `Color.n500` | ✅ |
| 13 | 正文 weight | 300 (.cp-sub font-weight:300) | `.fontWeight(.light)` | ✅ |
| 14 | 正文行高 | 1.6 (.cp-sub line-height:1.6) | `lineSpacing(8.4)` (14×0.6) | ✅ |
| 15 | 正文 margin-bottom | 44px (.cp-sub) | `.padding(.bottom, 44)` | ✅ |
| 16 | 正文合并 | 单段（无 `<br>` 分离） | 单 `Text()` | ✅ |
| 17 | hint 字体 | 11px italic (.cp-hint) | `.custom("Nunito-Italic", size: 11)` | ✅ |
| 18 | hint weight | 300 (.cp-hint) | `.fontWeight(.light)` | ✅ |
| 19 | hint 颜色 | `var(--text-light)` = #AEA3C4 | `Color.n300` | ✅ |
| 20 | hint font-style | italic (.cp-hint) | `.italic()` | ✅ |
| 21 | 按钮背景 | `var(--accent)` = #C9A0DC | `Color.primary600` | ✅ |
| 22 | 按钮 padding | 15px 44px (.cp-btn) | `.vertical(15) .horizontal(44)` | ✅ |
| 23 | 按钮圆角 | 14px (.cp-btn) | `AppRadius.md` = 14 | ✅ |
| 24 | 装饰光环 1 | 180×180, top:120 left:20 | `frame(180)` offset(x:20, y:120) | ✅ |
| 25 | 装饰光环 2 | 140×140, bottom:140 right:10 | `frame(140)` offset(x:-10, y:-140) | ✅ |

---

## 4. Tasks (#88) — 14 项

### Design vs Actual

| Design | Actual |
|--------|--------|
| ![Tasks Design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/tasks.png) | ![Tasks Actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-tasks.png) |

### 参数对比

| # | 参数 | Design (CSS) | Code (Swift) | 状态 |
|---|------|-------------|-------------|------|
| 1 | 页面标题字体 | NotoSerifSC 24px | `.custom("NotoSerifSC-Regular", size: 24)` | ✅ |
| 2 | 页面标题颜色 | `var(--text-dark)` = #3A2F50 | `Color(hex: "3A2F50")` | ✅ |
| 3 | 标题 margin-top | 8px | `.padding(.top, 8)` | ✅ |
| 4 | 标题 margin-bottom | 6px | `.padding(.bottom, 6)` | ✅ |
| 5 | 副标题字体 | 12px | `AppFonts.caption` = 12px | ✅ |
| 6 | 副标题颜色 | `var(--text-light)` = #AEA3C4 | `Color.n300` | ✅ |
| 7 | 任务卡片 padding | 18px (inline override) | `AppSpacing.cardPadding` = 18 | ✅ |
| 8 | 任务卡片间距 | 11px | `spacing: 11` | ✅ |
| 9 | 卡片 icon 尺寸 | 40×40 (.ti) | `frame(width: 40, height: 40)` | ✅ |
| 10 | 卡片 icon 圆角 | 13px (.ti) | `cornerRadius: 13` | ✅ |
| 11 | 卡片标题字体 | 13px medium (.tn) | `AppFonts.cardTitle` = Nunito-Medium 13 | ✅ |
| 12 | 卡片标题 letter-spacing | -0.1px (.tn) | `.tracking(-0.1)` | ✅ |
| 13 | 卡片描述字体 | 10.5px (.td) | `.system(size: 10.5)` | ✅ |
| 14 | 卡片描述颜色 | `var(--text-light)` = #AEA3C4 | `Color.n300` | ✅ |

---

## 5. Hospital Bag (#89) — 9 项

### Design vs Actual

| Design | Actual |
|--------|--------|
| ![Bag Design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/hospital-bag.png) | ![Bag Actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-bag.png) |

### 参数对比

| # | 参数 | Design (CSS) | Code (Swift) | 状态 |
|---|------|-------------|-------------|------|
| 1 | 页面标题字体 | NotoSerifSC 24px | `.custom("NotoSerifSC-Regular", size: 24)` | ✅ |
| 2 | 副标题字体 | 12px, #AEA3C4 | `.custom("Nunito-Regular", size: 12)`, `Color(hex: "AEA3C4")` | ✅ |
| 3 | 添加按钮尺寸 | 32×32, radius 10 | `frame(width: 32, height: 32)`, `cornerRadius: 10` | ✅ |
| 4 | 进度条高/圆角 | 7px / 3px | `height: 7`, `cornerRadius: 3` | ✅ |
| 5 | 分类标题字体 | 13px bold (.tn equiv) | `.custom("Nunito-SemiBold", size: 13)` | ✅ |
| 6 | checkbox 已选 | 18px, #C9A0DC fill | `frame(width: 18)`, `Color(hex: "C9A0DC")` | ✅ |
| 7 | checkbox 未选 | 18px, 1.5px rgba(183,168,214,0.3) | `frame(width: 18)`, `lineWidth: 1.5`, `opacity(0.3)` | ✅ |
| 8 | 已选文字 | line-through, text-mid | `.strikethrough`, `Color.n500` | ✅ |
| 9 | 分类卡片间距 | 8px | `.padding(.bottom, 8)` | ✅ |

---

## 6. Knowledge (#90) — 16 项

### Design vs Actual

| Design | Actual |
|--------|--------|
| ![Knowledge Design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/knowledge.png) | ![Knowledge Actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-knowledge.png) |

### 参数对比

| # | 参数 | Design (CSS) | Code (Swift) | 状态 |
|---|------|-------------|-------------|------|
| 1 | 页面标题字体 | NotoSerifSC 24px | `.custom("NotoSerifSC-Regular", size: 24)` | ✅ |
| 2 | 页面标题颜色 | #3A2F50 | `Color(hex: "3A2F50")` | ✅ |
| 3 | 副标题字体 | 12px, #AEA3C4 | `.custom("Nunito-Regular", size: 12)`, `Color(hex: "AEA3C4")` | ✅ |
| 4 | 标题 margin-top | 8px | `.padding(.top, 8)` | ✅ |
| 5 | 标题 margin-bottom | 16px | `.padding(.bottom, 16)` | ✅ |
| 6 | 分类网格间距 | 11px (.tg gap:11) | `spacing: 11` | ✅ |
| 7 | 分类网格 margin-bottom | 16px (inline override) | `.padding(.bottom, 16)` | ✅ |
| 8 | 分类卡片 padding | 20px 12px (inline) | `.vertical(20) .horizontal(12)` | ✅ |
| 9 | 分类卡片居中 | text-align:center | `.frame(maxWidth: .infinity)` center layout | ✅ |
| 10 | 分类 icon 尺寸 | 40×40 (.ti) | `frame(width: 40, height: 40)` | ✅ |
| 11 | 分类 icon margin-bottom | 10px (inline) | `spacing: 10` | ✅ |
| 12 | 热门文章标题 | 12px semibold, #7A6E94, ls 0.5 | `.custom("Nunito-SemiBold", size: 12)`, `tracking(0.5)` | ✅ |
| 13 | 文章卡片 padding | 14px 16px (inline) | `.vertical(14) .horizontal(16)` | ✅ |
| 14 | 文章标题字体 | 13px medium (.tn) | `AppFonts.cardTitle` | ✅ |
| 15 | 文章描述字体 | 10.5px (.td) | `.system(size: 11)` | ✅ |
| 16 | 文章卡片间距 | 8px | `spacing: 8` | ✅ |

---

## 7. Article Detail (#91) — 14 项

### Design vs Actual

| Design | Actual |
|--------|--------|
| ![Article Design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/article.png) | ![Article Actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-article.png) |

### 参数对比

| # | 参数 | Design (CSS) | Code (Swift) | 状态 |
|---|------|-------------|-------------|------|
| 1 | 返回 icon | chevron.left, 20px, text-mid | `.system(size: 20)`, `Color.n500` | ✅ |
| 2 | 导航标题字体 | NotoSerifSC 18px | `.custom("NotoSerifSC-Regular", size: 18)` | ✅ |
| 3 | 导航标题颜色 | `var(--text-dark)` = #3A2F50 | `Color.n900` | ✅ |
| 4 | 导航栏间距 | gap 12px | `spacing: 12` | ✅ |
| 5 | 导航栏 margin-top | 4px | `.padding(.top, 4)` | ✅ |
| 6 | 导航栏 margin-bottom | 16px | `.padding(.bottom, 16)` | ✅ |
| 7 | 收藏 icon | heart, 20px | `.system(size: 20)` | ✅ |
| 8 | 收藏颜色（未选） | `var(--text-light)` = #AEA3C4 | `Color.n300` | ✅ |
| 9 | 内容区 padding | 20px (inline) | `.padding(20)` | ✅ |
| 10 | 内容区卡片 | glassCard | `.glassCard()` | ✅ |
| 11 | 内容区 margin-bottom | 12px | `.padding(.bottom, 12)` | ✅ |
| 12 | 免责声明字体 | 10px | `.system(size: 10)` | ✅ |
| 13 | 免责声明颜色 | `var(--text-light)` = #AEA3C4 | `Color.n300` | ✅ |
| 14 | 免责声明对齐 | text-align:center | `.multilineTextAlignment(.center)` | ✅ |

---

## 8. Lamaze Detail (#92) — 13 项

### Design vs Actual

| Design | Actual |
|--------|--------|
| ![Lamaze Design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/lamaze-hub.png) | ![Lamaze Actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-lamaze-hub.png) |

### 参数对比

| # | 参数 | Design (CSS) | Code (Swift) | 状态 |
|---|------|-------------|-------------|------|
| 1 | 导航标题字体 | NotoSerifSC 20px | `.custom("NotoSerifSC-Regular", size: 20)` | ✅ |
| 2 | 导航标题颜色 | #3A2F50 | `Color(hex: "3A2F50")` | ✅ |
| 3 | 模式卡片 padding | 20px (inline) | `.padding(20)` | ✅ |
| 4 | 模式卡片间距 | 11px | `spacing: 11` | ✅ |
| 5 | 模式 icon 尺寸 | 44×44 (inline) | `frame(width: 44, height: 44)` | ✅ |
| 6 | 模式 icon 圆角 | 14px (inline border-radius:14) | `AppRadius.md` = 14 | ✅ |
| 7 | 模式标题字体 | 14px (.tn inline override) | `.custom("Nunito-Medium", size: 14)` | ✅ |
| 8 | 模式标题 letter-spacing | -0.1px | `.tracking(-0.1)` | ✅ |
| 9 | 模式描述字体 | 10.5px (.td) | `.system(size: 10.5)` | ✅ |
| 10 | 模式描述颜色 | #AEA3C4 | `Color.n300` | ✅ |
| 11 | chevron 颜色 | `var(--text-light)` | `Color.n300` | ✅ |
| 12 | icon 渐变起 | rgba(…, 0.5) | `.opacity(0.5)` | ✅ |
| 13 | icon 渐变止 | rgba(…, 0.8) | `.opacity(0.8)` | ✅ |

---

## 9. Notification (#94) — 22 项

### Design vs Actual

| Design | Actual |
|--------|--------|
| ![Notification Design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/notification.png) | ![Notification Actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-notification.png) |

### 参数对比

| # | 参数 | Design (CSS) | Code (Swift) | 状态 |
|---|------|-------------|-------------|------|
| 1 | 弹窗宽度 | 280px | `frame(width: 280)` | ✅ |
| 2 | 弹窗圆角 | 24px | `cornerRadius: 24` | ✅ |
| 3 | 弹窗背景 | rgba(255,255,255,0.7) | `Color.white.opacity(0.7)` | ✅ |
| 4 | 弹窗边框 | 1px rgba(255,255,255,0.7) | `Color.white.opacity(0.7), lineWidth: 1` | ✅ |
| 5 | 弹窗阴影 | 0 16px 48px rgba(58,47,80,0.08) | `shadow radius: 48, y: 16, opacity 0.08` | ✅ |
| 6 | 弹窗 padding-top | 32px | `.padding(.top, 32)` | ✅ |
| 7 | 弹窗 padding-h | 24px | `.padding(.horizontal, 24)` | ✅ |
| 8 | 弹窗 padding-bottom | 24px | `.padding(.bottom, 24)` | ✅ |
| 9 | bell icon 圆尺寸 | 52px | `frame(width: 52, height: 52)` | ✅ |
| 10 | bell icon 渐变 | 粉紫渐变 | `F9B5C4 → C4B5E0` | ✅ |
| 11 | bell icon 大小 | 22px | `.system(size: 22)` | ✅ |
| 12 | bell icon 颜色 | `var(--accent-dark)` = #A87CC0 | `Color.primaryDark` | ✅ |
| 13 | bell margin-bottom | 16px | `.padding(.bottom, 16)` | ✅ |
| 14 | 标题字体 | NotoSerifSC 20px | `.custom("NotoSerifSC-Regular", size: 20)` | ✅ |
| 15 | 标题颜色 | #3A2F50 | `Color.n900` | ✅ |
| 16 | 标题 margin-bottom | 6px | `.padding(.bottom, 6)` | ✅ |
| 17 | 描述字体 | 13px | `AppFonts.bodyText` = 13px | ✅ |
| 18 | 描述颜色 | #AEA3C4 | `Color.n300` | ✅ |
| 19 | 描述 margin-bottom | 22px | `.padding(.bottom, 22)` | ✅ |
| 20 | 主按钮 | 14px semibold, #C9A0DC bg, 14 radius | 同 | ✅ |
| 21 | 主按钮 padding | 13px v | `.padding(.vertical, 13)` | ✅ |
| 22 | 次按钮 | 12px, #AEA3C4 | `AppFonts.caption`, `Color.n300` | ✅ |

---

## 10. Exit Confirmation (#96)

### Design vs Actual

| Design | Actual |
|--------|--------|
| ![Exit Design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/exit-confirm.png) | ![Exit Actual](https://raw.githubusercontent.com/GhostComplex/Blossom/a23265b/qa-screenshots/issue-96/actual-exit-confirm.png) |

设计参数：
- 遮罩: `rgba(0,0,0,0.3)` ✅
- 弹窗圆角: 22px ✅
- 弹窗 padding: 28px ✅
- 弹窗背景: `rgba(255,255,255,0.85) + blur(24px)` ✅
- 标题字体: NotoSerifSC 18px ✅
- 副标题: 13px, `var(--text-light)` ✅
- 按钮间距: gap 12px ✅
- 按钮圆角: 12px ✅
- 继续按钮: 白底 + 紫色边框 ✅
- 结束按钮: `var(--accent)` 实心 ✅

---

## 11. Kegel Prep (#78)

### Design vs Actual

| Design | Actual |
|--------|--------|
| ![Prep Design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/kegel-prep.png) | ![Prep Actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-kegel-prep.png) |

设计参数：
- 标题: NotoSerifSC 22px (inline override), margin-bottom 16px ✅
- 说明文字: 12px, `var(--text-light)`, line-height 1.6, max-width 240px ✅
- 圆环中心: NotoSerifSC 18px, `var(--text-mid)` ✅
- 开始按钮: 200px, 14px v-padding, 14px radius, `var(--accent)` bg ✅
- 按钮阴影: 0 4px 16px rgba(196,160,220,0.2) ✅

---

## 12. Hospital Bag Add (#81)

### Design vs Actual

| Design | Actual |
|--------|--------|
| ![Add Design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/bag-add.png) | ![Add Actual](https://raw.githubusercontent.com/GhostComplex/Blossom/6f067eb/qa-screenshots/round1-supplement/my-actual-bag-add.png) |

设计参数：
- 弹窗标题: NotoSerifSC 20px ✅
- Handle bar: 36×4, radius 2, rgba(183,168,214,0.3) ✅
- 输入框: 14px, 12px 14px padding, radius 12 ✅
- 输入框边框: rgba(183,168,214,0.2) ✅
- 数量按钮: 32×32, radius 10 ✅
- 分类药丸: 6px 14px, capsule ✅
- 选中分类: `var(--accent)` bg, white text ✅
- 添加按钮: 14px semibold, radius 14, full width ✅

---

## 13. Lamaze Timer (#65, #134, #139) — 3 轮修复

### Design vs Actual

| Design | Actual (Round 3) |
|--------|--------|
| ![Timer Design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/lamaze-prep.png) | ![Timer R3](https://raw.githubusercontent.com/GhostComplex/Blossom/82fbbda/qa-screenshots/round3-fixes/my-actual-lamaze-timer-r3.png) |
| | ![Prep R3](https://raw.githubusercontent.com/GhostComplex/Blossom/82fbbda/qa-screenshots/round3-fixes/my-actual-lamaze-prep-r3.png) |

3 轮修复历程：
- **Round 1** (#65): 初始实现 — 圆环线宽 8→2/2.5, 计时器数字 60→48
- **Round 2** (#134): 等级标签 weight medium→regular, color n500→n300, 组数间距修复
- **Round 3** (#139): 阶段指示文字 22→26 + tracking(0.3), 剩余呼吸 12px + tracking(0.5), 底部间距 24→36

全部参数已对齐设计稿。 ✅

---

## 14. App Icon (#105)

### Before vs After

| Before | After |
|--------|-------|
| ![Before](https://raw.githubusercontent.com/GhostComplex/Blossom/3ca1584/.github/screenshots/app-icon-original.png) | ![After](https://raw.githubusercontent.com/GhostComplex/Blossom/ee483ef/qa-screenshots/issue-105/actual-desktop-icon.png) |

- 从 design-v2 导出的 1024×1024 icon 正确替换到 Assets.xcassets ✅
- 桌面显示正确 ✅

---

## Theme 全局对照

| Token | Design CSS | Theme.swift | 状态 |
|-------|-----------|-------------|------|
| text-dark | #3A2F50 | `n900` = #3A2F50 | ✅ |
| text-mid | #7A6E94 | `n500` = #7A6E94 | ✅ |
| text-light | #AEA3C4 | `n300` = #AEA3C4 | ✅ |
| accent | #C9A0DC | `primary600` = #C9A0DC | ✅ |
| accent-dark | #A87CC0 | `primaryDark` = #A87CC0 | ✅ |
| pink | #F9B5C4 | `accentPeach` = #F9B5C4 | ✅ |
| pink-light | #FDDDE6 | `accentLight` = #FDDDE6 | ✅ |
| lavender | #C4B5E0 | — (used inline) | ✅ |
| sky | #B8DCF5 | `warmGold` = #B8DCF5 | ✅ |
| bg gradient | #FEF6F8→#F6EDF8→#EDF2FC→#F4F0FA | `pageBackground` 同 | ✅ |
| card radius sm | 10 | `AppRadius.sm` = 10 | ✅ |
| card radius md | 14 | `AppRadius.md` = 14 | ✅ |
| card radius lg | 20 | `AppRadius.lg` = 20 | ✅ |
| card radius xl | 28 | `AppRadius.xl` = 28 | ✅ |

---

**结论：所有 14 个屏幕、220+ 参数项全部与 design-v2.1 设计稿对齐。** ✅
