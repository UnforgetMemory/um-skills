# 现代分层架构 —— 7 层

适用于多平台应用的七层架构。每一层回答一个明确的问题。依赖**单向向下**；禁止反向依赖。

## 层总览

```
┌──────────────────────────────────────────────┐
│  app          application composition layer   │
│               routing · UI layout composition │
│               · top-level DI · platform       │
│               lifecycle                       │
├──────────────────────────────────────────────┤
│  feature      UI capability layer             │
│               UI · page components ·          │
│               interaction entry points        │
├──────────────────────────────────────────────┤
│  store        state holder layer              │
│               UI state holder · state changes │
│               · reactive state for UI         │
├──────────────────────────────────────────────┤
│  scenario     business flow layer             │
│               user behavior flows ·           │
│               multi-step orchestration ·      │
│               cross-provider coordination     │
├──────────────────────────────────────────────┤
│  provider     external adapter layer          │
│               external services · API · DTO · │
│               protocol conversion             │
├──────────────────────────────────────────────┤
│  engine       underlying engine layer         │
│               network · database · storage ·  │
│               crypto · platform capability    │
├──────────────────────────────────────────────┤
│  libraries    pure internal implementation    │
│               general algorithms · utilities  │
│               · business-agnostic code        │
└──────────────────────────────────────────────┘
```

## 层依赖表

| 层 | 回答的问题 | 核心职责 | 依赖方向 |
|-------|--------------------|--------------------|----------------------|
| **app** | 应用如何组装？ | 路由、UI 布局组合、顶层 DI、平台生命周期入口 | 依赖 feature |
| **feature** | 用户能完成什么？ | UI、页面组件、UI 交互入口 | 依赖 store、scenario |
| **store** | 当前状态是什么？ | UI 状态持有、状态变更、供 UI 使用的响应式状态 | 依赖 scenario（只读结果）、provider（只读） |
| **scenario** | 流程如何完成？ | 用户行为流程、多步骤业务编排、跨 provider 协调 | 依赖 provider、engine |
| **provider** | 外部世界如何访问？ | 外部服务适配器、API、DTO、外部协议转换 | 依赖 engine、library |
| **engine** | 平台能力如何实现？ | 网络、数据库、存储、crypto、平台能力 | 依赖 library |
| **libraries** | 哪些纯能力可复用？ | 通用算法、工具函数、与业务无关的代码 | 无依赖 |

## 依赖规则

### 核心原则：依赖单向向下，信息向上流动

```
app → feature → store → scenario → provider → engine → library

dependency direction   ────→
information flow       ←────
```

### 允许与禁止的关系

| 关系 | 允许 | 禁止 |
|----------|---------|-----------|
| feature → store | 消费状态变更结果 | store 直接操纵 UI |
| feature → scenario | 触发 scenario 执行 | 直接操作 Provider |
| store → scenario | 单向调用，接收返回结果 | 编排流程（应只接收结果，不驱动流程） |
| scenario → provider | 调用外部 API | 直接操作 UI/Store |
| scenario → engine | 使用平台能力 | 包含业务逻辑 |
| provider → engine | 使用 Network/Storage | 直接调用 UI |
| provider → library | 使用工具函数 | 包含业务逻辑 |
| engine → library | 使用通用工具 | 引用业务模块 |

### 常见违规（绝不允许）

- ❌ feature → 直接调用 Provider —— UI 获知外部 API 细节；破坏关注点分离
- ❌ store → 直接 HTTP —— 状态管理与网络混在一起；不可测试
- ❌ scenario → 直接 UI —— 业务逻辑与 UI 耦合；业务流程不可测试
- ❌ scenario → 直接写 Store —— 破坏单向数据流；应返回结果，让 Store 更新状态
- ❌ provider → 引用另一个 Provider 的 DTO —— 外部协议耦合；一个平台变更影响另一个
- ❌ libraries → 引用业务模块 —— 公共层被腐蚀；不可复用

## 单向数据流（UDF）

```
User Action → Store (Intent/Action) → Scenario (business logic)
           → Provider/Engine (side effects) → Store (state mutation) → UI
```

- 副作用（网络、数据库、文件）只在 scenario / provider / engine 中执行
- Store 暴露不可变的响应式状态；UI 只读消费
