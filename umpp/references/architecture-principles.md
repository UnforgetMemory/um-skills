# 🏛️ 架构设计规范 & 🧩 核心组件职责约束

## 📐 速查：每一层只回答一个问题

> 如果不知道一个类属于哪一层，问自己：**「这个类主要回答的是哪一个问题？」**

| 层 | 永远回答的问题 | 负责 | 禁止 |
|----|--------------|------|------|
| **Feature** | **用户要完成什么？** | Compose UI, Store, State, Intent | HTTP, JSON, Cookie, SQL |
| **Store** | **现在是什么状态？** | StateFlow, 状态转换, UI 通知 | HTTP, 数据库, Provider 逻辑 |
| **Scenario** | **这件事怎么完成？** | 多步骤编排, 异常恢复, 补偿 | UI, 直接网络请求 |
| **Provider** | **怎么和外部平台通信？** | HTTP, Cookie, Token, 签名, 解析 | UI, 页面状态, 业务流程 |
| **Engine** | **平台能力怎么实现？** | 平台 API 统一封装 | 业务逻辑 |
| **Library** | **哪些能力可以被多个模块复用？** | 纯工具函数, 基础数据结构 | 业务逻辑, 任何 Provider 知识 |

---

## 📁 推荐项目结构

```
root
├── apps
│   ├── androidApp
│   ├── desktopApp
│   └── androidTvApp
├── features
│   ├── player
│   ├── login
│   ├── library
│   └── download
├── providers
│   ├── bilibili
│   ├── youtube
│   ├── webdav
│   └── cloudflare
├── libraries
│   ├── player-engine
│   ├── subtitle-engine
│   ├── networking
│   └── storage
└── docs
    ├── architecture
    ├── ADR
    ├── roadmap
    └── decisions
```

## 模块职责约束

### Store — UI 状态容器

负责：`User Action → State Mutation → UI Rendering`

禁止：HTTP 请求、数据库操作、Provider 逻辑。

示例：
```
PlayerStore
  Idle → Loading → Ready → Playing → Error
```

### Scenario — 用户级业务流程

负责：多步骤编排、异常恢复、状态转换、业务规则。

示例：
```
LoginScenario
  QR Create → Wait Scan → Cookie Save → Load User
```

### Pipeline — 多阶段数据处理

适用于：AI、字幕、下载、转码、同步。

示例：
```
SubtitlePipeline
  Extract → Recognize → Translate → Render
```

### Provider — 外部世界适配层

负责：HTTP、API、Authentication、Protocol、Parsing。

禁止包含：UI、页面状态、业务流程。

### Engine — 平台能力封装

示例：
```
PlayerEngine
  Android: ExoPlayer
  Desktop: MPV
```

### Library — 通用基础能力

适用于任何 Feature 都可能用到的**纯工具层**。

示例：
```
network        — HTTP 客户端封装
storage        — 本地持久化
database       — 数据库访问
crypto         — 加密/解密
logging        — 日志
player-engine  — 播放器抽象
subtitle-engine— 字幕渲染
```

约束：
- 不依赖任何 Feature 或 Provider
- 不知道 Bilibili / YouTube / WebDAV 等外部平台的存在
- 可以依赖第三方 SDK（如 Ktor、ExoPlayer、libass）
- 同一 Library 应能在所有 App 间复用

---

## 🔗 端到端链路示例

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
    ↓ 创建二维码 → 等待扫码 → Cookie保存 → 加载用户信息
BiliAuthApi (Provider)
    ↓ HTTP 请求 → Bilibili OAuth
Storage (Library)
    ↓ 持久化 Cookie
LoginStore (Store)
    ↓ State = LoggedIn
Compose UI
    ↓ 显示用户头像
```

---

## 🎯 单一事实来源（Single Source of Truth）

系统中每个维度的信息**有且只有一个权威来源**。

| 内容 | 权威来源 | 禁止的替代来源 |
|------|---------|--------------|
| 当前任务状态 | GitHub Project | Markdown 手动维护的 TODO |
| 技术决策 | ADR（`docs/ADR/`） | 口头约定、未记录的 Slack 讨论 |
| 代码事实 | Git（当前分支） | 过时的 `architecture.md` |
| 架构长期原则 | `docs/architecture/overview.md` | 代码注释中的架构描述 |
| 版本计划 | GitHub Project Roadmap | `roadmap.md` 中的日期列表 |
| Bug 跟踪 | GitHub Issue | 聊天记录、邮件 |

**核心纪律**：更新代码时，如果改变了架构假设或模块边界，必须先更新 ADR 再改代码。**ADR 驱动变更，而非变更后补 ADR。**
