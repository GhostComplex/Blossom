# 拾月 · Blossom — 验收报告

**版本：** v1.0 MVP  
**验收人：** Manta（PM）  
**状态：** ✅ 验收通过（12/12 XCUITest 全绿）  
**最后更新：** 2026-04-11

---

## 验收方式

- 模拟器：iPhone 17 Pro / iOS 26.4
- 方法：XCUITest 真实用户点击模拟（12 个测试用例）
- 每个 flow 有操作前→操作后多张截图
- 截图存放在 `qa-screenshots/flow-screenshots/` 按 flow 分目录

---

## 1. 完整用户流程（testFullUserFlow ✅ 125s）

完整路径：Onboarding → 首页 → 任务 Tab → 待产包 Tab → 知识 Tab → 文章详情 → 凯格尔 → 拉玛泽

| 步骤 | 截图 |
|------|------|
| ① Onboarding 花朵 + 日期选择 | `flow-screenshots/full-flow/step-01.png` |
| ② 首页倒计时 + 任务卡片 | `flow-screenshots/full-flow/step-02.png` |
| ③ 任务 Tab | `flow-screenshots/full-flow/step-03.png` |
| ④ 待产包 Tab (0/58) | `flow-screenshots/full-flow/step-04.png` |
| ⑤ 知识 Tab | `flow-screenshots/full-flow/step-05.png` |
| ⑥ 文章详情 markdown 渲染 | `flow-screenshots/full-flow/step-06.png` |
| ⑦ 凯格尔计时器 | `flow-screenshots/full-flow/step-07.png` |
| ⑧ 拉玛泽详情 | `flow-screenshots/full-flow/step-08.png` |
| ⑨ 最终状态 | `flow-screenshots/full-flow/step-09.png` |

---

## 2. 待产包勾选/取消（testHospitalBagCheckUncheck ✅ 62s）

| 步骤 | 状态 | 截图 |
|------|------|------|
| ① 勾选前 | 0/58 (0%) | `flow-screenshots/bag-check/step-01.png` |
| ② 勾选后 | 1/58 (1%) + 通知弹窗触发 | `flow-screenshots/bag-check/step-02.png` |
| ③ 取消勾选 | 0/58 (0%) 回退 | `flow-screenshots/bag-check/step-03.png` |

---

## 3. 文章收藏（testArticleFavorite ✅ 74s）

| 步骤 | 状态 | 截图 |
|------|------|------|
| ① 文章详情（收藏前） | ♡ 空心 | `flow-screenshots/article-favorite/step-01.png` |
| ② 点击收藏后 | ♥ 实心 | `flow-screenshots/article-favorite/step-02.png` |
| ③ 取消收藏后 | ♡ 空心 | `flow-screenshots/article-favorite/step-03.png` |

---

## 4. 凯格尔练习流程（testKegelExerciseFlow ✅ 80s）

| 步骤 | 状态 | 截图 |
|------|------|------|
| ① 任务列表 → 点击凯格尔 | 进入计时器 | `flow-screenshots/kegel-flow/step-01.png` |
| ② 收缩阶段 | 倒计时 + 进度圆 | `flow-screenshots/kegel-flow/step-02.png` |
| ③ 放松阶段 | 自动切换 | `flow-screenshots/kegel-flow/step-03.png` |
| ④ 结束/返回 | 回到任务列表 | `flow-screenshots/kegel-flow/step-04.png` |

---

## 5. 胎动记录（testFetalMovementRecording ✅ 87s）

| 步骤 | 状态 | 截图 |
|------|------|------|
| ① 打开记录页 | 计数 0 | `flow-screenshots/fetal-movement/step-01.png` |
| ② 点击 +1 三次 | 计数 3 | `flow-screenshots/fetal-movement/step-02.png` |
| ③ 保存成功 | Toast 提示 | `flow-screenshots/fetal-movement/step-03.png` |
| ④ 关闭回到任务页 | 记录已保存 | `flow-screenshots/fetal-movement/step-04.png` |

---

## 6. 拉玛泽学习模式（testLamazeLearningMode ✅ 70s）

| 步骤 | 状态 | 截图 |
|------|------|------|
| ① 拉玛泽入口（三种模式） | 跟练/学习/知识 | `flow-screenshots/lamaze-learn/step-01.png` |
| ② 学习模式 6 阶段列表 | 清洁呼吸→用力呼吸 | `flow-screenshots/lamaze-learn/step-02.png` |

---

## 7. 其他通过的测试

| 测试 | 时间 | 结果 | 说明 |
|------|------|------|------|
| testCountdownCardExists | 28s | ✅ | 首页有「距离与宝宝见面」+「天」+「预产期」 |
| testDueDateToday | 29s | ✅ | 预产期设为今天不崩溃 |
| testHospitalBagAddItem | 35s | ✅ | 待产包添加自定义物品 |
| testArticleStartExercise | 71s | ✅ | 文章跟练按钮跳转到练习页 |
| testTabNavigationSmoke | 15s | ✅ | 4 个 Tab 都能渲染 |
| testNotificationPreRequestPopup | 21s | ✅ | 通知预请求弹窗 + 「不了，谢谢」关闭 |

---

## 8. 推送通知（#8 — 待真机验证）

| # | 验收项 | 结果 |
|---|--------|------|
| 1 | 首次完成任务后弹出预请求弹窗 | ✅ |
| 2 | 弹窗有「好的，提醒我」和「不了，谢谢」 | ✅ |
| 3 | 点「好的，提醒我」→ 系统权限弹窗 | ⏳ |
| 4 | 点「不了，谢谢」→ 弹窗关闭 | ✅ |
| 5-8 | 17:00 智能推送 | ⏳ 需真机 |
| 9 | 拒绝权限后不推送 | ⏳ 需真机 |
| 10 | 预产期过后停止 | ⏳ 需真机 |
| 11 | App 被杀掉后触发 | ⏳ 需真机 |
| 12-13 | 7 天回归提醒 | ⏳ 需真机 |

---

## 验收结论

| 指标 | 结果 |
|------|------|
| XCUITest 用例 | 12/12 全绿 ✅ |
| 用户 flow 截图 | 25 张（6 个 flow） |
| 已关闭 issues | #4 #5 #6 #7 #9 #10 #11 #12 #13 #14 #15 #16 #17 #18 |
| 剩余 open issues | #8（推送通知 9 项需真机） |
| P0 bug | 0 |
| 通过标准 | ✅ 达标（≥90% 通过，无 P0） |

---

**版本历史：**
- v3.0 (2026-04-11) — 按 flow 组织截图，12/12 全绿最终版
- v1.1 — 每项新增 UI 截图列
- v1.0 — 初版验收计划
