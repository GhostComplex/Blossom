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
| 验收通过 | 19（QA 验收通过，等 Juanjuan 确认关闭） |
| 修复轮次 | 3 轮 |
| 总 PR 数 | 28+ |

---

## 逐页 Design vs Actual 截图

### 1. HOME 首页 (#76)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/home.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/0bb35a9/qa-screenshots/issue-76/actual-home.png) |

修复 42 项：问候区字号/颜色/间距、倒计时卡片渐变/padding/光晕、任务格子间距/icon/副标题、进度条圆角。PR #112, #116。

---

### 2. Kegel 凯格尔运动 (#86)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/kegel.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/4651a82/qa-screenshots/issue-86-bubble/actual-kegel-no-bubble.png) |

修复 26 项：背景渐变、级别标签（去气泡）、ring 内径/glow、"秒"标签、按钮间距。PR #118, #124。

---

### 3. Exercise Completion 完成页 (#87, #120)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/completion.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/1029fa6/qa-screenshots/issue-120/actual-completion-fixed.png) |

修复 25 项 + 按钮位置居中修复：背景渐变、check circle、button/hint 顺序修正、padding 40→36。PR #119, #122。

---

### 4. Tasks 任务页 (#88)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/tasks.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-tasks.png) |

修复 14 项：标题间距、副标题 10.5px、icon 渐变 opacity、tracking。PR #121。

---

### 5. Hospital Bag 待产包 (#89)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/hospital-bag.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-bag.png) |

修复 9 项：+ 按钮颜色、分类计数字号、checkbox 颜色、物品名字号。PR #125。

---

### 6. Knowledge 知识页 (#90)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/knowledge.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-knowledge.png) |

修复 16 项：分类格子间距 11px、icon/副标题颜色、文章卡片样式。PR #126。

---

### 7. Article Detail 文章详情 (#91)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/article.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-article.png) |

修复 14 项：自定义导航栏、h2/h3 紫色标题、body 颜色/行高、紫色圆点列表。PR #127。

---

### 8. Lamaze Detail 拉玛泽详情 (#92)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/lamaze-hub.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-lamaze-hub.png) |

修复 13 项：icon 56→44、标题 14px、副标题 10.5px、颜色 n300。PR #128。

---

### 9. Notification 通知弹窗 (#94)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/notification.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-notification.png) |

修复 22 项：卡片宽度 280px、圆角 24px、铃铛 52px outline、shadow、颜色。PR #129。

---

### 10. Exit Confirmation 结束确认弹窗 (#96)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/exit-confirm.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/4651a82/qa-screenshots/issue-86-bubble/actual-kegel-no-bubble.png) |

新增组件：毛玻璃卡片替代系统 Alert。PR #99。

---

### 11. Kegel Prep 凯格尔准备页 (#78)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/kegel-prep.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-kegel-prep.png) |

新功能：hasStarted 门控 + 准备页面（级别 badge + ring + 开始按钮）。PR #131。

---

### 12. Hospital Bag Add 待产包添加物品 (#81)

| Design | Actual |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/bag-add.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/d8b7028/qa-screenshots/round1-supplement/actual-bag.png) |

新功能：底部弹窗（名称输入 + 数量 stepper + 分类 pills + 备注）。PR #132。

---

### 13. Lamaze Timer 拉玛泽跟练 (#65, #134, #139)

| Design Prep | Actual Prep |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/lamaze-prep.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/82fbbda/qa-screenshots/round3-fixes/my-actual-lamaze-prep-r3.png) |

| Design Timer | Actual Timer |
|--------|--------|
| ![design](https://raw.githubusercontent.com/GhostComplex/Blossom/12c36be/qa-screenshots/round1-supplement/lamaze-timer.png) | ![actual](https://raw.githubusercontent.com/GhostComplex/Blossom/82fbbda/qa-screenshots/round3-fixes/my-actual-lamaze-timer-r3.png) |

3 轮修复：Ring lineWidth 8→2/2.5、呼吸指令 22→26px、阶段标签样式、颜色统一。PR #133, #136, #140。

---

### 14. App Icon (#105)

| Before | After (桌面效果) |
|--------|--------|
| ![before](https://raw.githubusercontent.com/GhostComplex/Blossom//.github/screenshots/app-icon-original.png) | ![after](https://raw.githubusercontent.com/GhostComplex/Blossom/ee483ef/qa-screenshots/issue-105/actual-desktop-icon.png) |

修复：去除预烘焙圆角白边，RBF 渐变重建。PR #130。

---

### 15. 倒计时光晕 (#115)

包含在 HOME 截图中，右上角和左下角白色半透明圆形装饰。PR #116。

---

## 验收过程教训

1. **不能偷懒**：用别人截图、只写参数表不截图、"大体像"就标通过——都被 Juanjuan 抓到了
2. **CSS inline override**：每个参数必须同时看 class base 和 HTML inline style
3. **设计稿 3x 渲染**：Chrome `--force-device-scale-factor=3` 才够清楚
4. **自己截图**：XCUITest 跑 user flow，不用别人的截图

---

*验收人：Manta (PM) · 交叉验证：SuperBoss · 2026-04-14*
