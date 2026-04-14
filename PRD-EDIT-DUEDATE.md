# PRD: 点击首页倒计时卡片修改预产期

**Issue:** #166  
**状态:** 等待 approve  
**作者:** Manta  
**日期:** 2026-04-14  

---

## 1. 背景

用户在产检后预产期可能被医生调整，但当前 app 没有修改预产期的入口——只能在 onboarding 时设定。用户需要重装 app 才能改预产期。

## 2. 目标

让用户可以在首页点击倒计时卡片修改预产期，操作简单直接。

## 3. 用户场景

1. 用户产检后医生说预产期提前/推迟了几天
2. 打开 app，点击首页倒计时卡片
3. 底部弹出修改预产期 sheet
4. 滚动选择新日期，点确认
5. 首页倒计时和孕周立即刷新

## 4. 交互流程

```
首页
  └→ 点击倒计时卡片区域
      └→ 底部弹出 Sheet
          ├→ 显示当前预产期
          ├→ 日期选择器（年/月/日 wheel picker）
          ├→ "确认" → 更新预产期 → 关闭 sheet → 首页刷新
          └→ "取消" / 下拉关闭 → 不修改
```

## 5. Sheet 页面设计

### 5.1 布局（从上到下）

复用"添加物品弹窗"（⑥-b）的设计语言：

| 元素 | 规格 |
|------|------|
| 拖拽手柄 | 36x4px，圆角 2px，rgba(183,168,214,0.3)，居中 |
| 标题 | "修改预产期"，Noto Serif SC 20px，font-weight 400，color text-dark |
| 当前日期 | "当前预产期：2026年5月1日"，12px，color text-light |
| 日期选择器 | 年/月/日 三列，容器 rgba(255,255,255,0.6) + 1px border rgba(183,168,214,0.2)，border-radius 16px |
| 选中项 | 16px，font-weight 600，color text-dark，背景 rgba(183,168,214,0.12)，border-radius 10px |
| 未选中项 | 14px，color text-mid 或 text-light |
| 按钮区 | 左"取消" + 右"确认"，flex 等宽，gap 12px |

### 5.2 按钮样式（与结束确认弹窗一致）

| 按钮 | 背景 | 文字 |
|------|------|------|
| 取消 | rgba(255,255,255,0.6) + 1px border rgba(183,168,214,0.2) | text-dark, 14px, weight 500 |
| 确认 | var(--accent) + box-shadow 0 4px 16px rgba(196,160,220,0.2) | white, 14px, weight 600 |

### 5.3 Sheet 背景（与添加物品弹窗一致）
- 背景：rgba(255,255,255,0.85) + backdrop-filter: blur(24px)
- 圆角：22px 22px 0 0
- 边框：1px solid rgba(255,255,255,0.7)
- 遮罩层：rgba(0,0,0,0.3) + border-radius 50px

## 6. Design 截图

![edit-duedate-sheet](https://raw.githubusercontent.com/GhostComplex/Blossom/feat/edit-duedate/.github/screenshots/edit-duedate-sheet.png)

## 7. Design 参考

| 屏号 | 页面 | 说明 |
|------|------|------|
| ① HOME | 首页 | 改动：倒计时卡片添加 onTapGesture |
| EDIT-DUEDATE | 修改预产期 Sheet | 新增 |

## 8. 交互细节

- 点击区域：整个倒计时卡片（不只是"预产期"文字）
- Sheet 弹出方式：iOS .sheet modifier，支持下拉关闭
- 日期选择器：UIDatePicker wheel 模式，或自定义 Picker（年/月/日 三列）
- 日期范围：今天 ~ 今天 + 280 天
- 确认后：SwiftData 里的 dueDate 更新，首页倒计时和孕周立即重新计算
- 凯格尔等级不受影响（按 iCloud KeyValueStore 里的首次安装日期算）
- 无需二次确认弹窗（修改预产期不是高风险操作，用户可以随时再改）

## 9. 开发注意事项

1. 首页 HomeView 倒计时卡片添加 `.onTapGesture` → `.sheet(isPresented:)`
2. 新建 `EditDueDateSheet` View
3. 日期选择器复用 onboarding 的样式（inline wheel picker）
4. 更新 SwiftData 的 `UserProfile.dueDate`
5. 首页用 `@Query` 或 `@Bindable` 监听 dueDate 变化，自动刷新倒计时
