# Blossom（拾月）

> 首个专为孕晚期（28-40周）设计的倒计时 + 任务助手

---

## 设计预览

完整设计稿（浏览器打开即可预览）：[design-v2/design.html](./design-v2/design.html)

---

## 产品简介

**拾月 · Blossom** 是一款专为孕晚期准妈妈设计的 iOS App。

不做全孕期管理，只专注孕晚期最后 3 个月：
- 🗓 每天打开看倒计时，感受宝宝即将到来的期待
- 💪 凯格尔运动计时器（3 级进阶，自动升级）
- 🫁 拉玛泽呼吸法跟练动画（6 阶段）
- 🎒 待产包 Checklist（58 项全量清单 + 自定义添加）
- 📖 分娩知识卡片（8 篇科学内容）

**商业模式：** 买断制 ¥18，无订阅 / 无广告 / 无内购

---

## 文件说明

### 📄 产品文档

| 文件 | 说明 |
|------|------|
| [PRD-v2.0.md](./PRD-v2.0.md) | 产品需求文档（功能 / User Journey / 数据结构） |
| [USER-FLOW.md](./USER-FLOW.md) | 用户流程（所有交互 / 跨 Tab 跳转） |
| [DESIGN-SPEC.md](./DESIGN-SPEC.md) | 设计规范（配色 / 字体 / 组件 / 间距） |

### 🎨 设计稿

| 文件 | 说明 |
|------|------|
| [design-v2/design.html](./design-v2/design.html) | 完整设计稿（所有页面 + 交互状态） |
| [app-icon.html](./app-icon.html) | App Icon 设计 |

### 📋 QA 文档

| 文件 | 说明 |
|------|------|
| [qa-reports/](./qa-reports/) | 所有验收报告 |
| [qa-reports/qa-copy-test-cases.md](./qa-reports/qa-copy-test-cases.md) | 文案验收测试用例 |
| [qa-reports/qa-copy-acceptance-report.md](./qa-reports/qa-copy-acceptance-report.md) | 文案验收报告（19/22 通过） |
| [qa-reports/QA-CHECKLIST.md](./qa-reports/QA-CHECKLIST.md) | QA 验收清单 |
| [qa-reports/QA-UI-REDESIGN.md](./qa-reports/QA-UI-REDESIGN.md) | UI 重设计验收报告 |
| [qa-reports/QA-COMPARISON-REPORT.md](./qa-reports/QA-COMPARISON-REPORT.md) | 设计对比验收报告 |

---

## 设计系统

**配色：** 粉紫渐变 + 毛玻璃卡片 + 水彩通透感
- 粉 `#FCAEC1` / 浅粉 `#FCD1DB`
- 薰衣草紫 `#B7A8D6` / 天蓝 `#ADD9F3`

**字体：**
- 标题/数字：Noto Serif SC（思源宋体，中英文统一）
- 正文/按钮：Nunito

**风格：** Glassmorphism + 粉紫渐变，参考 SYUU + Sense

---

## 技术栈

- **框架：** SwiftUI（iOS 17+）
- **数据：** SwiftData（本地）
- **通知：** UserNotifications（本地推送）
- **字体：** Noto Serif SC（5 字重） + Nunito

**Bundle ID：** `com.blossom.shiyue`

---

*产品经理：Manta · 最后更新 2026-04-13*
