# UI 还原度逐屏对比报告

**日期：** 2026-04-11  
**对比基准：** `design-v2/design.html` vs App（HEAD `c8ee143`，clean build）

---

## 1. 首页

| # | 差异项 | Design HTML | App 当前 | 文件 |
|---|--------|------------|---------|------|
| 1.1 | icon 背景色 | 粉色 `rgba(249,181,196,0.5→0.8)` / 紫色 / 蓝色 / 深紫色 **各不同** | 灰紫色，区分度不够 | HomeView.swift |
| 1.2 | icon 内容 | **白色 stroke SVG** (fill:none) | 彩色 SF Symbol (实心) | HomeView.swift |
| 1.3 | 卡片毛玻璃 | `rgba(255,255,255,0.45)` 能透出背景渐变 | 偏白偏不透明 | Theme.swift |
| 1.4 | 进度条颜色 | `linear-gradient(90deg, #F9B5C4, #C4B5E0)` 粉→紫 | 灰色 | HomeView.swift |
| 1.5 | 倒计时卡片渐变 | 粉紫蓝三色渐变明显 | 渐变偏淡偏灰 | HomeView.swift |
| 1.6 | 「晚上好」字体 | Cormorant Garamond 纤细 | 系统粗黑体（中文 fallback 预期） | — |
| 1.7 | Tab Bar 圆底 | 无 | Liquid Glass 圆底 | iOS 26 限制已接受 |

## 2. 任务页

| # | 差异项 | Design HTML | App 当前 | 文件 |
|---|--------|------------|---------|------|
| 2.1 | 「任务」标题 | Cormorant Garamond 24px | 系统粗黑体（中文 fallback） | — |
| 2.2 | icon 背景+内容 | 同首页：彩色背景+白色 stroke | 灰色背景+彩色 icon | TasksView.swift |
| 2.3 | 「完成 0/3」字体 | Nunito 轻 | 系统字体（接近） | ✅ 可接受 |

## 3. 凯格尔

| # | 差异项 | Design HTML | App 当前 | 文件 |
|---|--------|------------|---------|------|
| 3.1 | 背景渐变 | 浅粉→浅紫渐变 | 偏白偏淡 | KegelExerciseView.swift |
| 3.2 | 圆环中心 | `rgba(255,255,255,0.4)` + blur | 偏白（PR#52 改善了但仍偏实） | KegelExerciseView.swift |
| 3.3 | 导航栏 | 无（全屏） | 已隐藏 ✅ | — |
| 3.4 | 组数指示器 | 文字「第 X 组 / 共 10 组」 | 已改 ✅ | — |

## 4. 拉玛泽

| # | 差异项 | Design HTML | App 当前 | 文件 |
|---|--------|------------|---------|------|
| 4.1 | icon 背景+内容 | 粉/紫/蓝渐变背景 + 白色 stroke | 紫色背景 + 彩色 icon | LamazeExerciseView.swift |
| 4.2 | 「知识卡片」icon 颜色 | 蓝色背景 | 绿色 | LamazeExerciseView.swift |

## 5. 待产包

| # | 差异项 | Design HTML | App 当前 | 文件 |
|---|--------|------------|---------|------|
| 5.1 | 未勾选圆圈 | 紫色半透明边框 `rgba(183,168,214,0.3)` | 已修 ✅ (PR#52) | — |
| 5.2 | 进度条 | 粉→紫渐变 | 粉紫色（接近但可能偏淡） | HospitalBagView.swift |

## 6. 知识页

| # | 差异项 | Design HTML | App 当前 | 文件 |
|---|--------|------------|---------|------|
| 6.1 | 「知识」标题 | Cormorant Garamond | 系统黑体（中文 fallback） | — |
| 6.2 | 分类卡片 icon | 粉色渐变圆 + 白色 stroke | 紫色渐变圆 + 紫色 icon | KnowledgeView.swift |
| 6.3 | 文章卡片样式 | 毛玻璃卡片 | 偏白不透明 | KnowledgeView.swift |

## 7. 胎动记录

| # | 差异项 | Design HTML | App 当前 | 文件 |
|---|--------|------------|---------|------|
| 7.1 | + 按钮 | 紫色圆形 56px | 紫色圆形 ✅ | — |
| 7.2 | 计数圆 | 毛玻璃 `rgba(255,255,255,0.45)` | 偏白（不够透） | FetalMovementCounterView.swift |
| 7.3 | 底部按钮 | 紫色「完成」+ 毛玻璃「取消」 | 灰紫色（颜色偏灰） | FetalMovementCounterView.swift |

## 8. 通知弹窗

| # | 差异项 | Design HTML | App 当前 | 文件 |
|---|--------|------------|---------|------|
| 8.1 | 弹窗背景 | `rgba(255,255,255,0.7)` + blur(24px) 半透明 | PR#52 改善了 | — |
| 8.2 | 铃铛 icon 背景 | 粉紫渐变 | 粉紫渐变 ✅ | — |
| 8.3 | 主按钮 | 紫色实底 | 紫色 ✅ | — |

---

## 优先修复清单（按影响大小排序）

### P0 — 最大视觉差异
1. **所有 icon：彩色背景+白色 stroke → 替换实心 SF Symbol**
   - 文件：HomeView, TasksView, LamazeExerciseView, KnowledgeView
   - 改法：icon 背景用 `linear-gradient` 渐变色（每个卡片不同颜色），icon 内容用 `Image(systemName: "xxx").renderingMode(.template).foregroundColor(.white)` 或自定义 SVG
   - 这是最大的单项差异

2. **进度条颜色：灰色 → 粉紫渐变**
   - 文件：HomeView
   - 改法：`LinearGradient(colors: [Color.pink, Color.lavender])`

### P1 — 透明度问题
3. **所有卡片毛玻璃更透**
   - 所有 View
   - 需要降低 white opacity，增加 blur

4. **倒计时卡片渐变更饱和**
   - HomeView
   - 渐变色值需要更接近 design HTML 的值

### P2 — 小差异
5. 凯格尔背景渐变偏淡
6. 胎动「完成」按钮颜色偏灰
7. 知识页文章卡片不够透
