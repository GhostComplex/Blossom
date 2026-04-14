# Design Alignment 验收报告 — 拾月 Blossom

**日期：** 2026-04-14
**版本：** main @ `3ca1584`
**验收人：** Manta (PM) + SuperBoss (交叉验证)
**设计稿：** design-v2/design.html

---

## Summary

| 指标 | 数值 |
|------|------|
| 总 issue 数 | 19 |
| 状态 | 全部 QA 验收通过，等 Juanjuan 确认关闭 |
| 修复轮次 | 3 轮 |
| 总 PR 数 | 28+ |
| 总修改项 | 200+ |

---

## 详细总览

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

### Round 1 — 补充修复 + 新功能

| Issue | 描述 | PR | 状态 |
|-------|------|-----|------|
| #115 | 倒计时卡片光晕装饰 | #116 | ✅ 通过 |
| #120 | 完成页按钮位置（居中修复） | #122 | ✅ 通过 |
| #96 | 结束确认弹窗（系统 Alert → 毛玻璃） | #99 | ✅ QA 通过，待 Juanjuan 确认 |
| #78 | 凯格尔准备开始页 | #131 | ✅ 通过 |
| #81 | 待产包添加物品弹窗 | #132 | ✅ 通过 |
| #65 | 拉玛泽 timer 重写（3 屏） | #133 | ✅ 通过 |
| #105 | App icon 白边修复 | #130 | ✅ 通过 |

### Round 2 + Round 3 — 参数复验修复

| Issue | 描述 | 修改项 | PR | 状态 |
|-------|------|--------|-----|------|
| #134 | Lamaze timer/prep 参数修复 | 20 项 | #136 | ✅ 通过 |
| #135 | Completion/Knowledge/Tasks/Lamaze 小修 | 4 项 | #137 | ✅ 通过 |
| #139 | Lamaze timer/prep Round 3 修复 | 11 项 | #140 | ✅ 通过 |

---

## 主要修改内容

**字体：** Cormorant Garamond → Noto Serif SC（中英文统一，5 字重）+ Nunito（正文）
**配色：** primary600 → 薰衣草紫 #C9A0DC / subtitle n500 → n300 #AEA3C4
**组件：** ExitConfirmationOverlay / 凯格尔准备页 / 待产包添加弹窗 / 拉玛泽 ring timer / Onboarding 日期选择器

---

## 逐页 Design vs Actual 截图

### 1. HOME 首页 (#76)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/home.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/0bb35a9/qa-screenshots/issue-76/actual-home.png) |

---

### 2. Kegel 凯格尔运动 (#86)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/kegel.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/4651a82/qa-screenshots/issue-86-bubble/actual-kegel-no-bubble.png) |

---

### 3. Exercise Completion 完成页 (#87, #120)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/completion.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/1029fa6/qa-screenshots/issue-120/actual-completion-fixed.png) |

---

### 4. Tasks 任务页 (#88)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/tasks.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-tasks.png) |

---

### 5. Hospital Bag 待产包 (#89)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/hospital-bag.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/6f067eb/qa-screenshots/round1-supplement/my-actual-bag-add.png) |

---

### 6. Knowledge 知识页 (#90)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/knowledge.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-knowledge.png) |

---

### 7. Article Detail 文章详情 (#91)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/article.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-article.png) |

---

### 8. Lamaze Detail 拉玛泽详情 (#92)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/lamaze-hub.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-lamaze-hub.png) |

---

### 9. Notification 通知弹窗 (#94)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/notification.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-notification.png) |

---

### 10. Exit Confirmation 结束确认弹窗 (#96)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/exit-confirm.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/a23265b/qa-screenshots/issue-96/actual-exit-confirm.png) |

---

### 11. Kegel Prep 凯格尔准备页 (#78)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/kegel-prep.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-kegel-prep.png) |

---

### 12. Hospital Bag Add 待产包添加物品 (#81)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/bag-add.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/6f067eb/qa-screenshots/round1-supplement/my-actual-bag-add.png) |

---

### 13. Lamaze Timer 拉玛泽跟练 (#65, #134, #139)

| Design Prep | Actual Prep |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/lamaze-prep.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/82fbbda/qa-screenshots/round3-fixes/my-actual-lamaze-prep-r3.png) |

| Design Timer | Actual Timer |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/lamaze-timer.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/82fbbda/qa-screenshots/round3-fixes/my-actual-lamaze-timer-r3.png) |

---

### 14. App Icon (#105)

| Before | After (桌面效果) |
|--------|--------|
| ![before](https://raw.githubusercontent.com/GhostComplex/Blossom/3ca1584/.github/screenshots/app-icon-original.png) | ![after](https://raw.githubusercontent.com/GhostComplex/Blossom/ee483ef/qa-screenshots/issue-105/actual-desktop-icon.png) |

---

## 验收过程教训

1. **不偷懒**：截图自己截，不用别人的
2. **CSS inline override**：每个参数同时查 class base 和 HTML inline style
3. **3x 渲染**：Chrome `--force-device-scale-factor=3` 确保清晰
4. **逐元素位置检查**：不能"大体像"就标通过

---

*Manta (PM) · SuperBoss (交叉验证) · 2026-04-14*
