# 文案验收测试用例 — 拾月 Blossom

**日期：** 2026-04-12
**版本：** main @ `e20a679`
**设备：** iPhone 17 Pro / iOS 26.4 (Simulator)
**PRD 版本：** v2.2
**验收范围：** 全 app 可见文案 vs PRD 定义

---

## 测试用例

### 1. Onboarding

| # | 验证项 | PRD 预期文案 | 代码实际文案 | 位置 |
|---|--------|-------------|-------------|------|
| 1.1 | 欢迎标题 | — | "欢迎来到拾月" | OnboardingView:62 |
| 1.2 | 副标题 | — | "告诉我们宝宝的预产期\n我们会陪你一起做好准备" | OnboardingView:70 |
| 1.3 | 日期标签 | — | "预产期" | OnboardingView:81 |
| 1.4 | 日期占位 | — | "点击选择日期" | OnboardingView:120 |
| 1.5 | 开始按钮 | — | "开始使用 →" | OnboardingView:146-148 |
| 1.6 | 日期选择器标题 | — | "选择预产期" | OnboardingView:223 |
| 1.7 | 确定按钮 | — | "确定" | OnboardingView:239 |

### 2. 首页 (HomeView)

| # | 验证项 | PRD 预期文案 | 代码实际文案 | 位置 |
|---|--------|-------------|-------------|------|
| 2.1 | 孕周显示 | — | "孕 X 周 + X 天" | HomeView:125 |
| 2.2 | 倒计时标题 | — | "距离与宝宝见面" | HomeView:136 |
| 2.3 | 倒计时数字 | — | "{N}" | HomeView:142 |
| 2.4 | 倒计时单位 | — | "天" | HomeView:146 |
| 2.5 | 预产期显示 | — | "预产期 YYYY年M月D日" | HomeView:159 |
| 2.6 | 待产包进度标题 | — | "待产包准备进度" | HomeView:245 |
| 2.7 | 待产包进度数字 | — | "X / Y" | HomeView:249 |

### 3. Tab Bar

| # | 验证项 | PRD 预期文案 | 代码实际文案 | 位置 |
|---|--------|-------------|-------------|------|
| 3.1 | Tab 1 | "首页" | "首页" | ContentView:tab |
| 3.2 | Tab 2 | "任务" | "任务" | ContentView:tab |
| 3.3 | Tab 3 | "待产包" | "待产包" | ContentView:tab |
| 3.4 | Tab 4 | "知识" | "知识" | ContentView:tab |

### 4. 任务页 (TasksView)

| # | 验证项 | PRD 预期文案 | 代码实际文案 | 位置 |
|---|--------|-------------|-------------|------|
| 4.1 | 导航标题 | — | "任务" | TasksView:58 |
| 4.2 | 完成统计 | — | "今天完成 X / 3 个任务" | TasksView:75 |
| 4.3 | 凯格尔标题 | "凯格尔运动" | "凯格尔运动" | TasksView:104 |
| 4.4 | 凯格尔描述 | — | "{level} · Xs收缩 - Xs放松 × 10" | TasksView:115 |
| 4.5 | 完成时间 | — | "今天 HH:mm 完成" | TasksView:121 |
| 4.6 | 拉玛泽标题 | "拉玛泽呼吸练习" | "拉玛泽呼吸练习" | TasksView:160 |
| 4.7 | 拉玛泽描述 | — | "6 阶段呼吸法，跟练模式" | TasksView:170 |
| 4.8 | 胎动标题 | — | "胎动记录（可选）" | TasksView:211 |
| 4.9 | 胎动空状态 | — | "今天还没有记录" | TasksView:216 |
| 4.10 | 胎动有数据 | — | "今天记录 X 次" | TasksView:220 |

### 5. 凯格尔运动 (KegelExerciseView)

| # | 验证项 | PRD 预期文案 | 代码实际文案 | 位置 |
|---|--------|-------------|-------------|------|
| 5.1 | 级别描述 | — | "{level} · Xs 收缩 / Xs 放松" | KegelExerciseView:91 |
| 5.2 | 收缩提示 | — | "收缩骨盆底肌" | KegelExerciseView:131 |
| 5.3 | 放松提示 | — | "放松休息" | KegelExerciseView:131 |
| 5.4 | 进度 | — | "第 X 组 / 共 Y 组" | KegelExerciseView:146 |
| 5.5 | 剩余提示 | — | "还剩 X 组（共 Y 组）" | KegelExerciseView:153 |
| 5.6 | 暂停/继续按钮 | — | "暂停" / "继续" | KegelExerciseView:165 |
| 5.7 | 结束按钮 | — | "结束" | KegelExerciseView:184 |
| 5.8 | 退出确认 | — | "当前进度不会保存" | KegelExerciseView:71 |

### 6. 拉玛泽呼吸 (LamazeExerciseView)

| # | 验证项 | PRD 预期文案 | 代码实际文案 | 位置 |
|---|--------|-------------|-------------|------|
| 6.1 | 导航标题 | — | "拉玛泽呼吸练习" | LamazeExerciseView:51 |
| 6.2 | 选择标题 | — | "选择练习阶段" | LamazeExerciseView:114 |
| 6.3 | 副标题 | — | "6 阶段呼吸法" | LamazeExerciseView:135 |
| 6.4 | 免责声明 | "本内容仅供参考，不构成医学建议，请遵医嘱" | "⚠️ 免责声明：本内容仅供参考，不构成医学建议。如有疑问，请咨询专业医生。" | LamazeExerciseView:148 |
| 6.5 | 开始按钮 | — | "开始" | LamazeExerciseView:262 |
| 6.6 | 适用时机标签 | — | "适用时机" | LamazeExerciseView:300 |
| 6.7 | 呼吸节奏标签 | — | "呼吸节奏" | LamazeExerciseView:310 |
| 6.8 | 呼吸描述 | — | "吸气 X 秒 → 呼气 X 秒" | LamazeExerciseView:314 |
| 6.9 | 重复次数 | — | "重复 X 次" | LamazeExerciseView:318 |
| 6.10 | 练习中吸气 | — | "🫁 深吸气..." | LamazeExerciseView:352 |
| 6.11 | 练习中呼气 | — | "💨 慢慢呼气..." | LamazeExerciseView:352 |
| 6.12 | 跟随提示 | — | "跟随圆圈扩大吸气" / "跟随圆圈缩小呼气" | LamazeExerciseView:356 |
| 6.13 | 剩余呼吸 | — | "还剩 X 次呼吸" | LamazeExerciseView:361 |
| 6.14 | 结束按钮 | — | "结束" | LamazeExerciseView:375 |
| 6.15 | 下一阶段按钮 | — | "下一阶段" | LamazeExerciseView:388 |
| 6.16 | 完成提示 | — | "已完成 {stage} 练习" | LamazeExerciseView:415 |

### 7. 运动完成页 (ExerciseCompletionView)

| # | 验证项 | PRD 预期文案 | 代码实际文案 | 位置 |
|---|--------|-------------|-------------|------|
| 7.1 | 完成标题 | — | "做得真棒" | ExerciseCompletionView:33 |
| 7.2 | 完成描述 | — | "今日{name}已完成，坚持就是最好的准备。" | ExerciseCompletionView:38 |
| 7.3 | 英文引用 | — | "It's the moment you show up for you." | ExerciseCompletionView:45 |
| 7.4 | 返回按钮 | — | "返回首页" | ExerciseCompletionView:54 |

### 8. 胎动记录 (FetalMovementCounterView)

| # | 验证项 | PRD 预期文案 | 代码实际文案 | 位置 |
|---|--------|-------------|-------------|------|
| 8.1 | 导航标题 | — | "记录胎动" | FetalMovementCounterView:119 |
| 8.2 | 计数标签 | — | "胎动次数" | FetalMovementCounterView:28 |
| 8.3 | 操作提示 | — | "感受到胎动时点击 +1" | FetalMovementCounterView:79 |
| 8.4 | 取消按钮 | — | "取消" | FetalMovementCounterView:89 |
| 8.5 | 完成按钮 | — | "完成" | FetalMovementCounterView:105 |
| 8.6 | 完成 Toast | — | "已记录 X 次胎动" | FetalMovementCounterView:130 |

### 9. 待产包 (HospitalBagView)

| # | 验证项 | PRD 预期文案 | 代码实际文案 | 位置 |
|---|--------|-------------|-------------|------|
| 9.1 | 导航标题 | — | "待产包" | HospitalBagView:43 |
| 9.2 | 进度统计 | — | "已准备 X / Y 项" | HospitalBagView:77 |
| 9.3 | 数量显示 | — | "×N" | HospitalBagView:262 |
| 9.4 | 添加按钮 | — | "添加物品" | HospitalBagView:299-300 |

### 10. 知识页 (KnowledgeView)

| # | 验证项 | PRD 预期文案 | 代码实际文案 | 位置 |
|---|--------|-------------|-------------|------|
| 10.1 | 页面标题 | — | "知识" | KnowledgeView:26 |
| 10.2 | 副标题 | — | "分娩准备 · 科学备产" | KnowledgeView:30 |
| 10.3 | 分类标题 | — | "热门文章" | KnowledgeView:77 |
| 10.4 | 阅读时间 | — | "X 分钟阅读" | KnowledgeView:193 |
| 10.5 | 免责声明 | "仅供参考，请遵医嘱" | "⚠️ 免责声明：本文内容仅供参考，不构成医学建议。如有疑问，请咨询专业医生。" | KnowledgeView:255 |
| 10.6 | 跟练按钮 | — | "开始跟练" | KnowledgeView:267/280 |

### 11. 通知预请求弹窗 (NotificationPreRequestView)

| # | 验证项 | PRD 预期文案 | 代码实际文案 | 位置 |
|---|--------|-------------|-------------|------|
| 11.1 | 标题（运动触发） | "每天提醒你练习" | "每天提醒你练习" | NotificationPreRequestView:22 |
| 11.2 | 描述（运动触发） | "每天练几分钟，和宝宝见面那天会更从容。" | "每天练几分钟，和宝宝见面那天会更从容。" | NotificationPreRequestView:29 |
| 11.3 | 标题（待产包触发） | "别忘了每天的小任务" | "别忘了每天的小任务" | NotificationPreRequestView:24 |
| 11.4 | 描述（待产包触发） | "我们会在合适的时候提醒你练习和准备。" | "我们会在合适的时候提醒你练习和准备。" | NotificationPreRequestView:31 |
| 11.5 | 主按钮 | "好的，提醒我" | "好的，提醒我" | NotificationPreRequestView:82 |
| 11.6 | 次按钮 | "不了，谢谢" | "不了，谢谢" | NotificationPreRequestView:93 |

### 12. 推送通知文案 (NotificationManager)

| # | 验证项 | PRD §4.5.4 预期文案 | 代码实际文案 | 位置 |
|---|--------|-------------------|-------------|------|
| 12.1 | 通知标题（每日） | — | "今日任务提醒" | NotificationManager:188 |
| 12.2 | 凯+拉都未完成 | "今天的凯格尔和拉玛泽还没做哦，花几分钟练一下吧" | "今天的凯格尔和拉玛泽还没做哦，花几分钟练一下吧" | NotificationManager:43 |
| 12.3 | 仅凯格尔未完成 | "今天的凯格尔运动还没做，3 分钟就搞定" | "今天的凯格尔运动还没做，3 分钟就搞定" | NotificationManager:44 |
| 12.4 | 仅拉玛泽未完成 | "今天的拉玛泽呼吸还没练，为分娩做准备吧" | "今天的拉玛泽呼吸还没练，为分娩做准备吧" | NotificationManager:45 |
| 12.5 | 7天未打开 | "好久没来了，看看待产包还有什么没准备的？" | "好久没来了，看看待产包还有什么没准备的？" | NotificationManager:46 |
| 12.6 | 回归通知标题 | — | "好久不见" | NotificationManager:266 |

### 13. 完成 Toast (PRD §4.2)

| # | 验证项 | PRD 预期文案 | 代码实际文案 | 位置 |
|---|--------|-------------|-------------|------|
| 13.1 | 凯格尔完成 Toast | "✓ 今日凯格尔运动已完成" | 需验证实际显示 | — |

---

## 已知文案差异（代码审查发现）

1. **免责声明文案不一致：** PRD 写"仅供参考，请遵医嘱"，代码实际是"⚠️ 免责声明：本内容仅供参考，不构成医学建议。如有疑问，请咨询专业医生。" — 代码版更完整，需确认是否是有意更新
2. **拉玛泽练习中用了 emoji（🫁💨）** — AGENTS.md 规定"不在通知文案里用 emoji"，但这不是通知，是 app 内练习引导。需确认是否允许
3. **凯格尔完成 Toast** — PRD 写 "✓ 今日凯格尔运动已完成"，需要实际运行验证是否一致
4. **通知标题** — PRD §4.5.4 只定义了 body 文案，没定义 title。代码用了"今日任务提醒"和"好久不见"，需确认是否 OK
