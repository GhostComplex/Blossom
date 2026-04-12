# 6 屏两列对比验收报告（修正版）

**代码版本：** main `ff5cb6d`（clean build, DerivedData 已删除）  
**日期：** 2026-04-12

---

## 1. 首页

| Design | 实现 |
|--------|------|
| ![design](../qa-screenshots/comparison/design-home.png) | ![app](../qa-screenshots/comparison/app-home.png) |

| 元素 | 状态 | 说明 |
|------|------|------|
| 背景粉紫蓝渐变 | ✅ | |
| 装饰光晕 | ✅ | |
| 倒计时卡片半透明渐变 | ✅ | |
| 倒计时数字衬线体 | ✅ | |
| icon 白色内容 | ✅ | |
| icon 彩色背景 | ✅ | |
| 毛玻璃卡片 | ✅ | |
| 自定义 Tab Bar | ✅ | |
| 进度条渐变 | ✅ | |
| 中文标题 | ⚠️ | 系统字体（CG 不含中文） |

## 2. 任务页

| Design | 实现 |
|--------|------|
| ![design](../qa-screenshots/comparison/design-tasks.png) | ![app](../qa-screenshots/comparison/app-tasks.png) |

| 元素 | 状态 | 说明 |
|------|------|------|
| icon 白色+彩色背景 | ✅ | |
| `>` 箭头导航 | ✅ | |
| 毛玻璃卡片 | ✅ | |
| Tab Bar 无圆底 | ✅ | |
| 中文标题 | ⚠️ | 系统字体 |

## 3. 待产包

| Design | 实现 |
|--------|------|
| ![design](../qa-screenshots/comparison/design-bag.png) | ![app](../qa-screenshots/comparison/app-bag.png) |

| 元素 | 状态 | 说明 |
|------|------|------|
| 背景渐变 | ❌ | 偏白，设计稿有粉紫渐变 |
| 进度条颜色 | ❌ | 偏灰，设计稿是粉紫渐变 |
| 物品行样式 | ❌ | 白底+灰线分隔，设计稿是毛玻璃卡片 |
| 未勾选圆圈 | ❌ | 灰色，设计稿是紫色半透明边框 |
| + 添加按钮 | ✅ | |
| 0/58 项 | ✅ | |
| Tab Bar | ✅ | |

## 4. 知识页

| Design | 实现 |
|--------|------|
| ![design](../qa-screenshots/comparison/design-knowledge.png) | ![app](../qa-screenshots/comparison/app-knowledge.png) |

| 元素 | 状态 | 说明 |
|------|------|------|
| 背景渐变 | ❌ | 几乎纯白，设计稿是粉紫蓝渐变 |
| 分类卡片 | ❌ | 白色实底，设计稿是毛玻璃半透明 |
| 分类 icon | ❌ | 彩色 icon（紫/粉），设计稿是白色 stroke + 彩色背景 |
| 文章卡片 | ❌ | 白色实底偏右，设计稿是毛玻璃全宽 |
| 热门文章标题 | ✅ | |
| Tab Bar | ✅ | |

## 5. 凯格尔

| Design | 实现 |
|--------|------|
| ![design](../qa-screenshots/comparison/design-kegel.png) | ![app](../qa-screenshots/comparison/app-kegel.png) |

| 元素 | 状态 | 说明 |
|------|------|------|
| 浅紫渐变背景 | ✅ | |
| 深色文字 | ✅ | |
| 紫色细线圆环 | ✅ | |
| 大号纤细数字 | ✅ | |
| 文字组数指示器 | ✅ | |
| 暂停/结束按钮 | ✅ | |
| 全屏无导航栏 | ✅ | |

## 6. 拉玛泽

| Design | 实现 |
|--------|------|
| ![design](../qa-screenshots/comparison/design-lamaze.png) | ![app](../qa-screenshots/comparison/app-lamaze.png) |

| 元素 | 状态 | 说明 |
|------|------|------|
| 三种模式卡片 | ✅ | |
| icon 彩色背景 | ✅ | |
| icon 白色内容 | ✅ | |
| `>` 箭头 | ✅ | |
| Tab Bar | ✅ | |

---

## 总结

| 分类 | ✅ | ❌ | ⚠️ |
|------|----|----|-----|
| 首页 | 9 | 0 | 1 |
| 任务 | 4 | 0 | 1 |
| 待产包 | 3 | **4** | 0 |
| 知识 | 2 | **4** | 0 |
| 凯格尔 | 7 | 0 | 0 |
| 拉玛泽 | 5 | 0 | 0 |
| **总计** | **30** | **8** | **2** |

## 需要修复的 8 项 ❌

### 待产包（4 项）
1. 背景渐变偏白 → 需要粉紫渐变
2. 进度条颜色偏灰 → 粉紫渐变
3. 物品行白底+灰线 → 毛玻璃卡片包裹
4. 未勾选圆圈灰色 → 紫色半透明边框

### 知识页（4 项）
5. 背景几乎纯白 → 粉紫蓝渐变
6. 分类卡片白色实底 → 毛玻璃半透明
7. 分类 icon 彩色 → 白色 stroke + 彩色背景
8. 文章卡片白色偏右 → 毛玻璃全宽
