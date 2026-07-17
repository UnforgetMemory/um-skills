# 📋 GitHub Project 管理规范

## 📌 前提：Markdown 是知识载体，不是项目管理工具

```
vision.md / architecture.md / roadmap.md
```

是最低成本方案，适合起步阶段。但项目长期演化后，手写 Markdown 维护 roadmap 会产生以下问题：

- **计划 vs 实际脱节**：Markdown 不会自动反映真实进度
- **任务状态模糊**：Todo / Doing / Done 不足以描述 Review、Blocked、验证中
- **多人协作困难**：无法分配 Owner、设置 Deadline、追踪依赖

### 正确的分工

| 内容 | 工具 | Markdown 的角色 |
|------|------|----------------|
| **当前任务** | GitHub Project / Linear | 保存**为什么这样规划**，而非具体任务列表 |
| **技术决策** | ADR（`docs/ADR/`） | ADR 本身就是 Markdown——这是合理的，因为决策需要永久保存 |
| **代码事实** | Git | Markdown 不追踪代码状态 |
| **架构原则** | `architecture.md` | 回答**为什么这样设计**，而非模块今天长什么样 |

> **GitHub Project 管变化，ADR 管决策，代码管事实，文档管理解。**

---

GitHub Project 是 **软件生命管理系统**，不是 Todo List。

## 层级结构

```
Vision
    ↓
Roadmap
    ↓
Epic
    ↓
Issue
    ↓
Task
    ↓
Verification
```

## Issue 规范

**禁止**:
```
实现播放器   ← 过于模糊，无法执行
```

**必须**:
```
EPIC: Player System

Tasks:
- PlayerEngine 抽象
- Android 平台实现
- Desktop 平台实现
- 状态管理
- 错误恢复
- 字幕集成
```

## 状态流转

**禁止**: `Todo → Doing → Done`（过于简单，无法反映真实进度）

**使用**:

```
Backlog
    ↓
Ready
    ↓
Implementing
    ↓
Review
    ↓
Verified
    ↓
Done
```

## 完成定义 (`Done`)

代码完成 ≠ Done。

必须满足所有条件：

```
Code
    ↓
Test
    ↓
Review
    ↓
Documentation
    ↓
Verification
```

每一项都必须真实执行，不可跳步。

---

## 🎯 Vision 定位

`vision.md` 回答**「为什么存在？」**，而非**「今天做什么？」**。

```
vision.md 示例：

# UM Multimedia Vision

目标：构建跨平台个人媒体生态。

核心能力：
- 本地媒体管理
- 在线 Provider
- AI 增强
- 字幕处理
- 多端同步
```

**Vision 的维护节奏**：一年可能改几次，类似公司战略。禁止每日更新。

---

## 🗺️ 单一事实来源（Single Source of Truth）

信息不一致是项目腐化的早期信号。必须遵守以下映射：

| 内容 | 权威来源 | 说明 |
|------|---------|------|
| 当前任务 | GitHub Project | 唯一进度权威 |
| 技术决策 | ADR（`docs/ADR/`） | 决策不可散落各处 |
| 代码状态 | Git | 代码事实只看仓库 |
| 架构原则 | `docs/architecture/overview.md` | 长期原则，不因短期实现而改变 |
| 版本计划 | GitHub Project Roadmap | Markdown 不维护日期级计划 |
| Bug | GitHub Issue | 聊天记录不是 Bug 跟踪 |

> **一个事实，一个来源。同一信息出现在两个地方 = 至少有一个是错的。**

---

## 🚫 .gitignore 规范

### 必须忽略的类别

```
# 1. 编辑器/IDE
.idea/
.vscode/
*.iml
.DS_Store
Thumbs.db

# 2. 构建产物
build/
out/
target/
*.class
*.jar

# 3. 依赖缓存
.gradle/
node_modules/
.kotlin/

# 4. 本地配置
local.properties
.env
*.local

# 5. Agent/工具运行时文件
.omo/run-continuation/
*.swp
*.swo
```

### 审查纪律

- `review-constitution.md` 的 gitignore 审查阶段必须逐条检查上述类别
- **优先使用目录级忽略**（如 `build/`），避免大量文件级规则
- 禁止源代码被误忽略，禁止构建产物进入 Git

### 本仓库当前覆盖

- `.omo/run-continuation/` — OpenCode 会话延续数据（运行时生成，不提交）
- `.localref/` — 本地开发参考材料（外部项目代码、测试素材、逆向分析等）
- `.output/` — 产物与编译输出目录
