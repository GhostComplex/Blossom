# DIFF REPORT — Design HTML CSS vs Swift 代码（逐项全覆盖）

**日期：** 2026-04-11  
**对比：** `design-v2/design.html` CSS ↔ Swift 代码（HEAD `e60ce87`）

---

## Theme.swift — AppFonts

| Font 常量 | Design HTML 值 | Swift 当前值 | 匹配？ | 修改 |
|-----------|---------------|-------------|--------|------|
| countdownNumber | CG-Light 72px | CG-Light 72px | ✅ | — |
| countdownUnit | Nunito 15px w400 | CG-Regular 22px | ❌ | 改 `.system(size:15)` 或 Nunito |
| sectionTitle | CG-Regular 24px → **但 .greet-t 是 26px** | CG-Regular 24px | ⚠️ | 确认用途：问候语 26px vs 页面标题 24px |
| cardTitle | Nunito 13px w500 | `.system(size:14, weight:.medium)` | ❌ | size 14→13 |
| bodyText | Nunito 13px w400 | `.system(size:13, weight:.regular)` | ✅ | — |
| caption | Nunito 12px w400 | `.system(size:12, weight:.regular)` | ✅ | — |
| smallLabel | Nunito 11px w400 | `.system(size:11, weight:.regular)` | ✅ | — |
| tabLabel | Nunito 9.5px w500 | `.system(size:10, weight:.medium)` | ❌ | size 10→9.5 |

## Theme.swift — Colors & Gradients

| 元素 | Design HTML 值 | Swift 当前值 | 匹配？ | 行号 |
|------|---------------|-------------|--------|------|
| 背景渐变 | `170deg, #FEF6F8→#F6EDF8→#EDF2FC→#F4F0FA` | `pageBackground` | ⚠️ 需确认角度和色值 | Theme:73-79 |
| 装饰光晕（粉） | `rgba(249,181,196,0.25)` 260×260 | `rgba(249,181,196,0.25)` | ❌ 代码用 0.25 但 HomeView:56 | Home:56 |
| 装饰光晕（紫） | `rgba(196,181,224,0.2)` 220×220 | `rgba(196,181,224,0.2)` | ✅ | Home:70 |
| 倒计时卡片渐变 | `140deg, rgba(249,181,196,0.5)→rgba(196,181,224,0.45)→rgba(184,220,245,0.4)` | `countdownCard` | ⚠️ 需确认 | Theme:85-87 |
| 进度条 | `linear-gradient(90deg, #F9B5C4, #C4B5E0)` | `progressBar: [accentPeach, primary600]` | ❌ | Theme:102 |
| | | primary600=#C9A0DC ≠ #C4B5E0 | | 改 `Color(hex:"C4B5E0")` |

## HomeView.swift — 首页

| 元素 | Design HTML 值 | Swift 当前值 | 匹配？ | 行号 |
|------|---------------|-------------|--------|------|
| 问候日期字体 | Nunito 12px w400 | `AppFonts.caption` (12px) | ✅ | 99 |
| 问候语字体 | CG-Regular 26px | `AppFonts.sectionTitle` (CG-Regular 24px) | ❌ size | 103 |
| 孕周 badge bg | `rgba(255,255,255,0.35) + blur(8px)` | `Color.white.opacity(0.5)` | ❌ 0.5→0.35 | 130 |
| 孕周 badge border | `1px solid rgba(255,255,255,0.4)` | 无 border | ❌ 缺 | — |
| 孕周 badge 字色 | `var(--text-mid)` #7A6E94 | 需确认 | ⚠️ | 126 |
| 倒计时数字 | CG-Light 72px | `AppFonts.countdownNumber` (CG-Light 72px) | ✅ | 142 |
| 「天」字体 | Nunito 15px w400 | `AppFonts.countdownUnit` (CG-Regular 22px) | ❌ | 146 |
| 预产期字体 | Nunito 11px w400 | `AppFonts.caption` (12px) | ❌ 12→11 | 159 |
| 卡片 bg | `rgba(255,255,255,0.45) + blur(24px)` | `.ultraThinMaterial.opacity(0.6) + countdownCard gradient` | ⚠️ 实现方式不同 | 171-175 |
| 卡片 border | `1px solid rgba(255,255,255,0.5)` | `Color.white.opacity(0.6)` | ❌ 0.6→0.5 | 181 |
| 卡片 radius | 28px | `AppRadius.xl` 需确认值 | ⚠️ | 177 |
| 卡片 shadow | `0 8px 40px rgba(196,160,220,0.12)` | `0.10 radius 12` | ❌ | 183 |
| **icon 前景色** | **白色 stroke** | **Color.primaryDark (紫色)** | **❌ P0** | 383 |
| icon bg 凯格尔 | `rgba(249,181,196,0.5→0.8)` | `accentPeach.opacity(0.6→0.25)` | ❌ 0.25→0.8 | 198 |
| icon bg 拉玛泽 | `rgba(196,181,224,0.5→0.8)` | `primary600.opacity(0.45→0.3)` | ❌ 0.3→0.8 | 209 |
| icon bg 待产包 | `rgba(184,220,245,0.5→0.8)` | `warmGold.opacity(0.5→0.25)` | ❌ 0.25→0.8 | 220 |
| icon bg 知识 | `rgba(201,160,220,0.5→0.8)` | `C4B5E0.opacity(0.45→0.25)` | ❌ 0.25→0.8 | 231 |
| 卡片标题字体 | Nunito 13px w500 | `.system(size:14, weight:.medium)` | ❌ 14→13 | 402 |
| 卡片描述字体 | Nunito 10.5px w400 | `AppFonts.caption` (12px) | ❌ 12→10.5 | 406 |
| 进度条标题字体 | Nunito 12px w600 | `CG-Regular 16px` | ❌ | 245 |
| 进度条数字字体 | Nunito 12px w500 | `AppFonts.bodyText` (13px) | ❌ 13→12 | 249 |
| 进度条轨道 bg | `rgba(196,181,224,0.12)` | `Color.n200` | ❌ | 257 |
| 进度条高度 | 7px | 需确认 `.frame(height:7)` | ⚠️ | 256 |

## TasksView.swift — 任务页

| 元素 | Design HTML 值 | Swift 当前值 | 匹配？ | 行号 |
|------|---------------|-------------|--------|------|
| 「任务」标题 | CG-Regular 24px | `AppFonts.sectionTitle` | ⚠️ 需确认 | — |
| 「完成 0/3」 | Nunito 12px | `AppFonts.caption` | ✅ | 76 |
| icon 字号 | 16-18px stroke | `.system(size:22)` | ❌ 22→18 | 88,136,182 |
| icon 前景色 | **白色** | 系统默认（紫色） | **❌ P0** | 88 |
| icon bg | 同首页各色渐变 | `Color.accentLight` (单色) | ❌ 需换成渐变 | 91,139 |
| 卡片标题 | Nunito 13px w500 | `AppFonts.cardTitle` (14px medium) | ❌ 14→13 | 97 |
| 导航箭头 | `>` chevron 16px stroke | chevron.right (outline) | ⚠️ 确认颜色 | — |

## KegelExerciseView.swift — 凯格尔

| 元素 | Design HTML 值 | Swift 当前值 | 匹配？ | 行号 |
|------|---------------|-------------|--------|------|
| 级别字体 | Nunito 11px w400 uppercase | `AppFonts.caption` (12px) | ❌ 12→11 | 92 |
| 阶段标题 | **CG-Regular 26px** | **CG-Light 26px** | ❌ Regular→Light | 133 |
| 倒计时数字 | CG-Light 60px | CG-Light 60px | ✅ | 137 |
| 「秒」 | Nunito 11px | `AppFonts.caption` (12px) | ❌ | — |
| 组数 | Nunito 12px w400 | `AppFonts.bodyText` (13px) | ❌ 13→12 | 155 |
| 按钮字体 | Nunito 13px w600 | `.system(size:16, weight:.semibold)` | ❌ 16→13 | 168,187 |
| 圆环中心 white | 0.4 | 0.3 | ❌ 0.3→0.4 | 126 |
| 暂停按钮 bg | `rgba(255,255,255,0.5)` | `Color.white.opacity(0.5)` | ✅ | 173 |

## LamazeExerciseView.swift — 拉玛泽

| 元素 | Design HTML 值 | Swift 当前值 | 匹配？ | 行号 |
|------|---------------|-------------|--------|------|
| icon bg | 粉/紫/蓝各不同渐变 0.5→0.8 | `color.opacity(0.15)` | ❌ 0.15→0.5-0.8 | 204 |
| icon 内容 | 白色 stroke SVG | `.system(size:24)` 默认色 | ❌ 需 .white | 201 |
| icon 大小 | 44×44 radius 14px | `AppRadius.md` (需确认) | ⚠️ | 205 |
| 标题字体 | Nunito 14px w600 | `AppFonts.cardTitle` (14px medium) | ⚠️ medium vs semibold | 209 |

## ExerciseCompletionView.swift — 完成页

| 元素 | Design HTML 值 | Swift 当前值 | 匹配？ | 行号 |
|------|---------------|-------------|--------|------|
| 标题「做得真棒」 | **CG-Regular 30px** | **CG-Light 28px** | ❌ Regular/30 vs Light/28 | 34 |
| 正文 | Nunito 14px **w300** | `.system(size:14)` default | ⚠️ w300 vs default | — |
| 英文 hint | Nunito 11px w300 italic | CG-Regular 12px | ❌ 字体+样式不同 | 46 |
| 按钮字体 | Nunito 14px w600 | `.system(size:16, weight:.semibold)` | ❌ 16→14 | 55 |
| ✓ icon | stroke="#7A6E94" | 需确认 | ⚠️ | 89 |

## OnboardingView.swift

| 元素 | Design HTML 值 | Swift 当前值 | 匹配？ | 行号 |
|------|---------------|-------------|--------|------|
| 标题字体 | **CG-Regular 28px** | **CG-SemiBold 28px** | ❌ SemiBold→Regular | 63 |
| 正文字体 | Nunito 13px | `.system(size:14)` | ❌ 14→13 | 71 |
| 日期年份 | CG 20px | CG-SemiBold 24px | ❌ | 91 |
| 日期月日 | CG 40px accent-dark | CG-Bold 42px | ❌ Bold→Regular, 42→40 | 100,109 |
| 「点击选择日期」 | Nunito 10px | `.system(size:12)` | ❌ 12→10 | 121 |

## NotificationPreRequestView.swift — 通知弹窗

| 元素 | Design HTML 值 | Swift 当前值 | 匹配？ | 行号 |
|------|---------------|-------------|--------|------|
| 标题字体 | **CG-Regular 20px** | **CG-Light 20px** | ❌ Light→Regular | 68 |
| 正文字体 | Nunito 13px | `AppFonts.bodyText` (13px) | ✅ | 73 |
| 按钮字体 | Nunito 14px w600 | `.system(size:16, weight:.semibold)` | ❌ 16→14 | 83 |
| 「不了，谢谢」 | Nunito 12px | `AppFonts.bodyText` (13px) | ❌ 13→12 | 94 |

## KnowledgeView.swift — 知识页

| 元素 | Design HTML 值 | Swift 当前值 | 匹配？ | 行号 |
|------|---------------|-------------|--------|------|
| 分类 icon bg | 粉/紫各不同 0.5→0.8 | 0.6→0.25 / 0.5→0.3 | ❌ | 118-120 |
| 分类 icon 内容 | 白色 stroke | `.system(size:22)` 默认色 | ❌ 需 .white | 128 |
| 分类标题 | CG 但 HTML 用 Nunito 13px | CG-Light 16px | ❌ | 142 |
| 文章卡片标题 | Nunito 13px w500 | `AppFonts.cardTitle` (14px) | ❌ 14→13 | 165 |
| 「热门文章」标题 | Nunito 12px w600 | 需确认 | ⚠️ | — |

## HospitalBagView.swift — 待产包

| 元素 | Design HTML 值 | Swift 当前值 | 匹配？ | 行号 |
|------|---------------|-------------|--------|------|
| + 按钮 | 毛玻璃 + 紫色 icon | `Color.white.opacity(0.5)` + purple icon | ⚠️ | 53 |
| 分类标题 | Nunito 13px w600 | `AppFonts.cardTitle` (14px medium) | ❌ 14→13, medium→semibold | 78 |

## FetalMovementCounterView.swift — 胎动

| 元素 | Design HTML 值 | Swift 当前值 | 匹配？ | 行号 |
|------|---------------|-------------|--------|------|
| 计数数字 | CG-Light 48px | CG-Light 52px | ❌ 52→48 | 57 |
| + 按钮大小 | 56×56 | 需确认 | ⚠️ | 72 |
| + 按钮字号 | 24px w300 | `.system(size:24, weight:.medium)` | ❌ medium→light | 72 |
| 完成按钮 | Nunito 13px w600 | `.system(size:16, weight:.semibold)` | ❌ 16→13 | 90,106 |

## 自定义 Tab Bar（替代系统 TabView）

见 DESIGN-SPEC-v2.md §8。需要完全自定义实现，去掉 iOS 26 Liquid Glass。

---

## 修改汇总

**P0（最大视觉差异）：**
1. HomeView:383 — icon foregroundStyle → `.white`
2. HomeView:198-231 — icon gradient opacity 0.25→0.8
3. TasksView:88,136,182 — icon 同上
4. KnowledgeView:118-120,128 — icon 同上
5. LamazeExerciseView:201,204 — icon 同上
6. Theme:102 — progressBar `#C4B5E0` 替换 `primary600`
7. 自定义 Tab Bar 替代系统 TabView

**P1（字体修复）：**
8. Theme:countdownUnit — CG 22px → Nunito 15px
9. Theme:cardTitle — 14px → 13px
10. Theme:tabLabel — 10px → 9.5px
11. 所有按钮 — 16px → 13-14px
12. 所有 CG-Light → CG-Regular（阶段标题、完成页、通知弹窗标题）
13. OnboardingView:63 — CG-SemiBold → CG-Regular

**P2（透明度/间距微调）：**
14. HomeView:130 — badge opacity 0.5 → 0.35
15. HomeView:181 — card border 0.6 → 0.5
16. HomeView:183 — shadow radius 12 → 20
17. KegelExerciseView:126 — ring center 0.3 → 0.4
18. FetalMovementCounterView:57 — countdown 52px → 48px
