# 项目管理纪律

## 前提：Markdown 是知识，不是项目管理工具

`vision.md` / `architecture.md` / `roadmap.md` 是最廉价的起步选项。随着项目增长，手工维护的 Markdown 路线图会腐化：

- **计划与现实漂移**：Markdown 永远无法反映真实进度
- **任务状态含糊**：Todo/Doing/Done 无法表达 Review、Blocked、验证中
- **协作性差**：没有 Owner、Deadline 或依赖跟踪

### 正确的工具分工

| 内容 | 工具 | Markdown 的角色 |
|---------|------|-----------------|
| 当前任务 | GitHub Project / Linear | 存放**当初为何这样规划**，而非任务清单 |
| 技术决策 | ADR（`docs/ADR/`） | ADR 就是 Markdown——合法，决策必须持久化 |
| 代码事实 | Git | Markdown 不跟踪代码状态 |
| 架构原则 | `docs/architecture/overview.md` | 回答**为何这样设计**，而非当前模块长什么样 |

> **GitHub Project 管理变更，ADR 管理决策，代码管理事实，文档管理理解。**

项目跟踪器是**软件生命周期管理系统**，不是 Todo 列表。

## 层级

```
Vision → Roadmap → Epic → Issue → Task → Verification
```

## Issue 规范

反模式（禁止）：
```
Implement player    ← too vague to execute
```

必需形式：
```
EPIC: Player System

Tasks:
- PlayerEngine abstraction
- Android platform implementation
- Desktop platform implementation
- State management
- Error recovery
- Subtitle integration
```

## 状态流转

禁止：`Todo → Doing → Done`（过于简单；掩盖真实进度）。

必需：
```
Backlog → Ready → Implementing → Review → Verified → Done
```

## 完成的定义（DoD）

代码写完 ≠ 完成。以下所有项必须真正执行，不得跳过：

```
Code → Test → Review → Documentation → Verification
```

## 愿景定位

`vision.md` 回答**"我们为什么存在？"**，而非"我们今天做什么？"

- 每年维护几次，如同公司战略——禁止：每日更新
- 示例：目标（跨平台个人媒体生态）+ 核心能力（本地媒体管理、在线 provider、AI 增强、字幕处理、多设备同步）

## 单一事实来源（SSoT）

不一致是项目腐化的早期信号。强制执行：

| 内容 | 权威来源 | 说明 |
|---------|----------------------|------|
| 当前任务 | GitHub Project | 唯一进度权威 |
| 技术决策 | ADR（`docs/ADR/`） | 决策不得散落 |
| 代码状态 | Git | 代码事实只在仓库中 |
| 架构原则 | `docs/architecture/overview.md` | 长期有效；不为短期实现而弯曲 |
| 版本计划 | GitHub Project Roadmap | Markdown 不维护日期级计划 |
| Bug | GitHub Issue | 聊天记录不是 Bug 跟踪 |

> **一个事实，一个来源。同一信息出现在两个地方 = 至少有一处是错的。**

## .gitignore 分类（必须覆盖）

```
1. Editor/IDE:        .idea/  .vscode/  *.iml  .DS_Store  Thumbs.db
2. Build output:      build/  out/  target/  *.class  *.jar
3. Dependency cache:  .gradle/  node_modules/  .kotlin/
4. Local config:      local.properties  .env  *.local
5. Agent/tool runtime: .omo/run-continuation/  *.swp  *.swo
```

评审纪律：
- gitignore 评审环节必须逐条检查以上每个类别
- **优先目录级忽略**，而非大量文件级规则
- 禁止：源代码被意外忽略；构建产物被提交进 Git
