# Design Alignment 验收报告 — 拾月 Blossom

**日期：** 2026-04-14
**版本：** main @ `3ca1584` (tag v0.1.2+)
**验收人：** Manta (PM) + SuperBoss (交叉验证)
**设计稿：** design-v2/design.html

---

## Summary

| 指标 | 数值 |
|------|------|
| 总 issue 数 | 19 |
| 验收通过 | 19 |
| 修复轮次 | 3 轮 |
| 总 PR 数 | 28+ |
| 总修改项 | 200+ |

---

## 覆盖的页面

### Round 1 — 全屏 Design Alignment（9 屏）

| Issue | 页面 | 修改项 | PR | 状态 |
|-------|------|--------|-----|------|
| #76 | HOME 首页 | 42 项 | #112, #116 | ✅ 通过 |
| #86 | Kegel 凯格尔运动 | 26 项 | #118, #124 | ✅ 通过 |
| #87 | Exercise Completion 完成页 | 25 项 | #119 | ✅ 通过 |
| #88 | Tasks 任务页 | 14 项 | #121 | ✅ 通过 |
| #89 | Hospital Bag 待产包 | 9 项 | #125 | ✅ 通过 |
| #90 | Knowledge 知识页 | 16 项 | #126 | ✅ 通过 |
| #91 | Article Detail 文章详情 | 14 项 | #127 | ✅ 通过 |
| #92 | Lamaze Detail 拉玛泽详情 | 13 项 | #128 | ✅ 通过 |
| #94 | Notification 通知弹窗 | 22 项 | #129 | ✅ 通过 |

### Round 1 — 补充修复

| Issue | 描述 | PR | 状态 |
|-------|------|-----|------|
| #115 | 倒计时卡片光晕装饰 | #116 | ✅ 通过 |
| #120 | 完成页按钮位置（居中修复） | #122 | ✅ 通过 |
| #96 | 结束确认弹窗（系统 Alert → 自定义毛玻璃） | #99 | ✅ 通过 |

### Round 1 — 新功能

| Issue | 描述 | PR | 状态 |
|-------|------|-----|------|
| #78 | 凯格尔准备开始页 | #131 | ✅ 通过 |
| #81 | 待产包添加物品弹窗 | #132 | ✅ 通过 |
| #65 | 拉玛泽 timer 重写（3 屏） | #133 | ✅ 通过 |
| #105 | App icon 白边修复 | #130 | ✅ 通过 |

### Round 2 — 参数复验 + 修复

| Issue | 描述 | PR | 状态 |
|-------|------|-----|------|
| #134 | Lamaze timer/prep 20 项参数修复 | #136 | ✅ 通过 |
| #135 | Completion/Knowledge/Tasks/Lamaze 4 项小修 | #137 | ✅ 通过 |

### Round 3 — 最终修复

| Issue | 描述 | PR | 状态 |
|-------|------|-----|------|
| #139 | Lamaze timer/prep 11 项参数修复 | #140 | ✅ 通过 |

---

## 主要修改内容

### 字体系统
- Cormorant Garamond → **Noto Serif SC**（中英文统一，5 字重）
- 正文字体统一为 **Nunito**
- 所有标题 letter-spacing 对齐设计稿

### 配色
- primary600 从旧琥珀色 `#C4855A` → 薰衣草紫 `#C9A0DC`
- 全局 subtitle 颜色 n500 → n300 (`#AEA3C4`)
- 倒计时卡片第三色 warmGold → 天蓝 `#B8DCF5`

### 间距/圆角
- glassCard border opacity 0.6 → 0.7
- glassCard shadow radius 8 → 16
- icon 尺寸 44 → 40，圆角 14 → 13
- 各页面 padding/margin 逐项对齐设计稿 CSS 值

### 新增组件
- ExitConfirmationOverlay（毛玻璃退出弹窗）
- 凯格尔/拉玛泽准备开始页（hasStarted 门控）
- 待产包添加物品底部弹窗（FlowLayout + SwiftData）
- 拉玛泽 ring-based countdown timer
- 自定义 Onboarding 日期选择器（内嵌滚轮）

### 设计稿同步
- design.html icon 标注 SF Symbols
- design.html 按钮加 icon（⏸ ✕ ▶）
- design.html 日期格式改中文
- design.html 新增 5 屏（Onboarding 选择态、凯格尔准备、拉玛泽准备/跟练/完成、待产包添加、结束确认弹窗）
- PRD 同步更新（Onboarding 章节、凯格尔/拉玛泽流程、待产包添加、胎动删除）

---

## 验收方法

### 参数级对比
每一屏对照 design.html CSS 值 vs Swift 代码值，逐参数列表。检查 CSS class base 和 HTML inline override。

### 截图对比
- Design 截图：Chrome headless 3x (`--force-device-scale-factor=3`)，1245×2700 分辨率
- Actual 截图：XCUITest 自动截图 或 simctl io screenshot，1206×2622
- 截图 push 到 `qa/round1-screenshots` branch，用 raw URL 在 issue 评论中显示

### 交叉验证
SuperBoss 独立对比同一屏参数，与 Manta 结果交叉验证。发现 Manta 遗漏的差异后开 issue 修复。

---

## 验收过程中发现的问题和教训

### PM 验收问题
1. **Round 1 偷懒**：部分 issue 用了 SuperCrew PR 里的截图代替自己截图，部分只写参数表不截图
2. **CSS inline override 遗漏**：只看 CSS class base，没看 HTML inline style，导致误报
3. **完成页按钮位置遗漏**：截图太小看不清元素位置，标了通过但按钮沉底了
4. **Lamaze timer 20 项差异完全漏掉**：Round 1 没有仔细对比新写的代码

### 改进措施
- 截图必须自己截（XCUITest 或 simctl），不用别人的
- 设计稿用 3x 分辨率渲染
- 每个参数同时检查 CSS class 和 HTML inline override
- 逐元素检查位置和间距，不能"大体像"就标通过

### 流程改进
- Issue 关闭权限只有 Juanjuan
- PR 用 `Ref #N` 不用 `Closes #N`
- 每个 PR merge 前必须有 Manta 的 Design vs Actual 截图验收
- main branch protection 开启

---

## 待 Juanjuan 验收

所有 19 个 issue 状态为 **In Review**（QA 验收通过），等 Juanjuan 统一验收后关闭。

验收截图链接汇总：
- #76 HOME: [评论](https://github.com/GhostComplex/Blossom/issues/76#issuecomment-4236641279)
- #86 Kegel: [评论](https://github.com/GhostComplex/Blossom/issues/86#issuecomment-4237315696)
- #87 Completion: [评论](https://github.com/GhostComplex/Blossom/issues/87#issuecomment-4237069006)
- #88 Tasks: [评论](https://github.com/GhostComplex/Blossom/issues/88#issuecomment-4237272087)
- #89 Hospital Bag: [评论](https://github.com/GhostComplex/Blossom/issues/89#issuecomment-4237451563)
- #90 Knowledge: [评论](https://github.com/GhostComplex/Blossom/issues/90#issuecomment-4237570595)
- #91 Article: [评论](https://github.com/GhostComplex/Blossom/issues/91#issuecomment-4237716984)
- #92 Lamaze Detail: [评论](https://github.com/GhostComplex/Blossom/issues/92#issuecomment-4238083236)
- #94 Notification: [评论](https://github.com/GhostComplex/Blossom/issues/94#issuecomment-4238270087)
- #96 Exit Confirmation: [评论](https://github.com/GhostComplex/Blossom/issues/96#issuecomment-4236351734)
- #65 Lamaze Timer: [评论](https://github.com/GhostComplex/Blossom/issues/65#issuecomment-4240368417)
- #78 Kegel Prep: [评论](https://github.com/GhostComplex/Blossom/issues/78#issuecomment-4240319213)
- #81 Hospital Bag Add: [评论](https://github.com/GhostComplex/Blossom/issues/81#issuecomment-4240364500)
- #105 App Icon: [评论](https://github.com/GhostComplex/Blossom/issues/105#issuecomment-4240541440)
- #115 倒计时光晕: [评论](https://github.com/GhostComplex/Blossom/issues/115#issuecomment-4240531064)
- #120 完成页按钮: [评论](https://github.com/GhostComplex/Blossom/issues/120#issuecomment-4240531142)
- #134 Lamaze R2: [评论](https://github.com/GhostComplex/Blossom/issues/134#issuecomment-4240457740)
- #135 小修: [评论](https://github.com/GhostComplex/Blossom/issues/135#issuecomment-4240441639)
- #139 Lamaze R3: [评论](https://github.com/GhostComplex/Blossom/issues/139#issuecomment-4240501131)
