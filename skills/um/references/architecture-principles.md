# 架构设计规范

> 本文档回答「架构如何分层、如何组织、如何维护一致性」。
> 组件级详细职责约束见 [component-roles.md](component-roles.md)（本文档不重复细节）。

## 1. 分层速查：每一层只回答一个问题

> 权威七层模型（详见 [modern-architecture.md](modern-architecture.md)）。
> 不确定某个类属于哪一层时，问自己：**「这个类主要回答哪个问题？」**
> 注：Pipeline 是组件模式（多阶段数据处理，位于 scenario 层内），**不是独立层**，见 [component-roles.md](component-roles.md)。

| 层 | 永远回答的问题 | 负责 | 禁止 |
|----|--------------|------|------|
| **app** | 应用如何组装？ | 路由, UI 布局组合, 顶层 DI, 平台生命周期 | 业务逻辑 |
| **feature** | 用户要完成什么？ | Compose UI, Store, State, Intent | HTTP, JSON, Cookie, SQL |
| **store** | 现在是什么状态？ | StateFlow, 状态转换, UI 通知 | HTTP, 数据库, Provider 逻辑 |
| **scenario** | 这件事怎么完成？ | 多步骤编排, 异常恢复, 补偿 | UI, 直接网络请求 |
| **provider** | 怎么和外部平台通信？ | HTTP, Cookie, Token, 签名, 解析 | UI, 页面状态, 业务流程 |
| **engine** | 平台能力怎么实现？ | 平台 API 统一封装 | 业务逻辑 |
| **libraries** | 哪些能力可跨模块复用？ | 纯工具函数, 基础数据结构 | 业务逻辑, 任何 Provider 知识 |

## 2. 推荐项目结构

```
root
├── apps                      # 应用组合层（每平台一个）
│   ├── androidApp
│   ├── desktopApp
│   └── androidTvApp
├── features                  # UI 能力层
│   ├── player
│   ├── login
│   ├── library
│   └── download
├── providers                 # 外部适配层（每平台一个目录）
│   ├── bilibili
│   ├── youtube
│   ├── webdav
│   └── cloudflare
├── libraries                 # 通用基础能力层
│   ├── player-engine
│   ├── subtitle-engine
│   ├── networking
│   └── storage
└── docs                      # 知识层
    ├── architecture
    ├── ADR
    ├── roadmap
    └── decisions
```

> 依赖方向：apps → features → store/scenario → provider → engine → libraries，单向向下，禁止反向。

## 3. 端到端链路示例（分层协作如何运转）

### 播放链路

```
Compose UI (Feature/PlayerScreen)
    ↓ 用户点击播放
PlayerStore (Store)
    ↓ State = Loading
BiliPlaybackScenario (Scenario)
    ↓ 检查登录 → 获取 Cookie
BiliPlayApi (Provider)
    ↓ HTTP 请求 → Bilibili 服务器
PlayerEngine (Engine)
    ↓ ExoPlayer / MPV
PlayerStore (Store)
    ↓ State = Playing
Compose UI
    ↓ 显示播放画面
```

### 登录链路

```
LoginScreen (Feature)
    ↓ 用户点击登录
LoginStore (Store)
    ↓ State = CreatingQR
BiliLoginScenario (Scenario)
    ↓ 创建二维码 → 等待扫码 → Cookie 保存 → 加载用户信息
BiliAuthApi (Provider)
    ↓ HTTP 请求 → Bilibili OAuth
Storage (Library)
    ↓ 持久化 Cookie
LoginStore (Store)
    ↓ State = LoggedIn
Compose UI
    ↓ 显示用户头像
```

> 链路要点：UI 只触发与渲染；状态只在 Store；流程只在 Scenario；外部通信只在 Provider；平台能力只在 Engine；通用能力只在 Library。任何一步跨层 = 违规。

## 4. 单一事实来源（SSoT）

系统每个维度的信息**有且只有一个权威来源**。

| 内容 | 权威来源 | 禁止的替代来源 |
|------|---------|--------------|
| 当前任务状态 | GitHub Project | Markdown 手动维护的 TODO |
| 技术决策 | ADR（`docs/ADR/`） | 口头约定、未记录的 Slack 讨论 |
| 代码事实 | Git（当前分支） | 过时的 `architecture.md` |
| 架构长期原则 | `docs/architecture/overview.md` | 代码注释中的架构描述 |
| 版本计划 | GitHub Project Roadmap | `roadmap.md` 中的日期列表 |
| Bug 跟踪 | GitHub Issue | 聊天记录、邮件 |

## 5. 核心纪律

> 更新代码时若改变架构假设或模块边界：**先更新 ADR，再改代码。**
> **ADR 驱动变更，而非变更后补 ADR。**
