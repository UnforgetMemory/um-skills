# 🏛️ 架构设计规范 & 🧩 核心组件职责约束

## 推荐项目结构

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
