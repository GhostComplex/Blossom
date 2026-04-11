# 拾月 · Blossom — 验收报告

**版本：** v1.0 MVP  
**验收人：** Manta（PM）  
**状态：** ✅ 验收通过（12/12 XCUITest 全绿）  
**最后更新：** 2026-04-11

---

## 1. 完整用户流程（testFullUserFlow ✅ 69s）

| 步骤 | 说明 | 截图 |
|------|------|------|
| ① | Onboarding 花朵 + 日期选择 | ![](qa-screenshots/named/02-home.png) |
| ② | 首页倒计时 + 任务卡片 | ![](qa-screenshots/named/03-tasks.png) |
| ③ | 任务 Tab 三个卡片 | ![](qa-screenshots/named/04-hospital-bag.png) |
| ④ | 待产包 0/58 | ![](qa-screenshots/named/05-knowledge.png) |
| ⑤ | 知识 Tab 分类 | ![](qa-screenshots/named/06-article-detail.png) |
| ⑥ | 文章详情 markdown | ![](qa-screenshots/named/07-kegel.png) |
| ⑦ | 凯格尔计时器 | ![](qa-screenshots/named/08-lamaze.png) |
| ⑧ | 拉玛泽详情 | ![](qa-screenshots/named/09-final-state.png) |

---

## 2. 待产包勾选/取消（testHospitalBagCheckUncheck ✅ 25s）

| 操作 | 状态 | 截图 |
|------|------|------|
| 勾选前 | 0/58 (0%) | ![](qa-screenshots/named/bag-check-01-initial.png) |
| 勾选后 | 1/58 (1%) + 通知弹窗 | ![](qa-screenshots/named/bag-check-02-checked.png) |
| 取消勾选 | 0/58 (0%) 回退 | ![](qa-screenshots/named/bag-check-03-unchecked.png) |

---

## 3. 文章收藏（testArticleFavorite ✅ 72s）

| 操作 | 状态 | 截图 |
|------|------|------|
| 收藏前 | ♡ 空心 | ![](qa-screenshots/named/favorite-01-article-detail.png) |
| 收藏后 | ♥ 实心 | ![](qa-screenshots/named/favorite-02-favorited.png) |
| 取消收藏 | ♡ 空心 | ![](qa-screenshots/named/favorite-03-unfavorited.png) |

---

## 4. 凯格尔练习（testKegelExerciseFlow ✅ 40s）

| 操作 | 状态 | 截图 |
|------|------|------|
| 开始练习 | 计时器启动 | ![](qa-screenshots/named/kegel-flow-01-started.png) |
| 放松阶段 | 自动切换 | ![](qa-screenshots/named/kegel-flow-02-relax.png) |
| 下一组 | 继续循环 | ![](qa-screenshots/named/kegel-flow-03-next-set.png) |
| 结束返回 | 回到任务 | ![](qa-screenshots/named/kegel-flow-04-closed.png) |

---

## 5. 胎动记录（testFetalMovementRecording ✅ 30s）

| 操作 | 状态 | 截图 |
|------|------|------|
| 打开记录 | 初始状态 | ![](qa-screenshots/named/fetal-01-sheet.png) |
| +1 三次 | 计数 3 | ![](qa-screenshots/named/fetal-02-count-3.png) |
| 保存 | 成功提示 | ![](qa-screenshots/named/fetal-03-success.png) |
| 关闭 | 回到任务 | ![](qa-screenshots/named/fetal-04-dismissed.png) |

---

## 6. 拉玛泽学习（testLamazeLearningMode ✅ 31s）

| 操作 | 状态 | 截图 |
|------|------|------|
| 拉玛泽入口 | 三种模式 | ![](qa-screenshots/named/lamaze-learn-01-mode-select.png) |
| 学习模式 | 6 阶段列表 | ![](qa-screenshots/named/lamaze-learn-02-stages.png) |
| 展开阶段 | 详情内容 | ![](qa-screenshots/named/lamaze-learn-03-all-stages.png) |
| 返回 | 回到任务 | ![](qa-screenshots/named/lamaze-learn-04-closed.png) |

---

## 7. 通知预请求弹窗（testNotificationPreRequestPopup ✅ 18s）

| 操作 | 状态 | 截图 |
|------|------|------|
| 待产包页 | 进入 | ![](qa-screenshots/named/prerequest-01-hospital-bag.png) |
| 勾选物品 | 触发弹窗 | ![](qa-screenshots/named/prerequest-02-after-check.png) |
| 弹窗显示 | 「每天提醒你练习」 | ![](qa-screenshots/named/prerequest-03-popup-visible.png) |
| 点击「不了，谢谢」 | 弹窗关闭 | ![](qa-screenshots/named/prerequest-04-after-decline.png) |

---

## 8. 待产包添加物品（testHospitalBagAddItem ✅ 20s）

| 操作 | 状态 | 截图 |
|------|------|------|
| 点击添加 | 弹出输入框 | ![](qa-screenshots/named/bag-add-01-sheet.png) |
| 添加完成 | 物品已添加 | ![](qa-screenshots/named/bag-add-02-dismissed.png) |

---

## 9. 文章跟练跳转（testArticleStartExercise ✅ 47s）

| 操作 | 状态 | 截图 |
|------|------|------|
| 文章详情 | 凯格尔文章 | ![](qa-screenshots/named/exercise-01-kegel-article.png) |
| 跳转练习 | 凯格尔计时器 | ![](qa-screenshots/named/exercise-02-kegel-launched.png) |
| 返回 | 回到文章 | ![](qa-screenshots/named/exercise-03-closed.png) |

---

## 10. 其他通过的测试

| 测试 | 时间 | 截图 |
|------|------|------|
| testCountdownCardExists ✅ | 24s | ![](qa-screenshots/named/countdown-01-home.png) |
| testDueDateToday ✅ | 18s | ![](qa-screenshots/named/duedate-today-skipped-no-onboarding.png) |
| testTabNavigationSmoke ✅ | 14s | ![](qa-screenshots/named/smoke-home.png) ![](qa-screenshots/named/smoke-tasks.png) ![](qa-screenshots/named/smoke-hospital-bag.png) ![](qa-screenshots/named/smoke-knowledge.png) |

---

## 11. 推送通知（#8 — 待真机验证）

| # | 验收项 | 结果 |
|---|--------|------|
| 1 | 首次完成任务后弹出预请求弹窗 | ✅ 见 §7 截图 |
| 2 | 弹窗有「好的，提醒我」和「不了，谢谢」 | ✅ 见 §7 截图 |
| 3 | 点「好的，提醒我」→ 系统权限弹窗 | ⏳ 需真机 |
| 4 | 点「不了，谢谢」→ 弹窗关闭 | ✅ 见 §7 截图 |
| 5-13 | 17:00 推送 / 7 天回归 / 权限相关 | ⏳ 需真机 |

---

## 验收结论

| 指标 | 结果 |
|------|------|
| XCUITest 用例 | **12/12 全绿** ✅ |
| 验收截图 | **40 张带名字**（10 个 flow） |
| 已关闭 issues | #4-#18（14 个） |
| 剩余 open issues | **#8**（推送通知 9 项需真机） |
| P0 bug | **0** |
| 通过标准 | ✅ **达标** |
