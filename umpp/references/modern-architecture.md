# 🏗️ 现代架构分层规范 & KMP 多模态架构指标

## 分层总览

本规范定义现代 KMP / Kotlin 生态多平台应用的七层架构。每一层回答一个确定的问题，依赖单向向下，禁止反向依赖。

```
┌──────────────────────────────────────────────┐
│  app       应用组合层                         │
│  ──────────────────────────────────────────── │
│  路由 · UI 布局组合 · 顶层 DI · 平台生命周期   │
├──────────────────────────────────────────────┤
│  feature   UI 能力层                          │
│  ──────────────────────────────────────────── │
│  Compose UI · 页面组件 · UI 交互入口           │
├──────────────────────────────────────────────┤
│  store     状态持有层                         │
│  ──────────────────────────────────────────── │
│  UI State Holder · 状态变更 · 响应式状态        │
├──────────────────────────────────────────────┤
│  scenario  业务流程层                         │
│  ──────────────────────────────────────────── │
│  用户行为流程 · 多步骤编排 · 跨 provider 协调    │
├──────────────────────────────────────────────┤
│  provider  外部适配层                         │
│  ──────────────────────────────────────────── │
│  Bilibili/Netease/GitHub · API · DTO · 协议转换 │
├──────────────────────────────────────────────┤
│  engine    底层引擎层                         │
│  ──────────────────────────────────────────── │
│  Network · Database · Storage · Crypto · 平台能力 │
├──────────────────────────────────────────────┤
│  libraries 纯 Kotlin 内部实现库                │
│  ──────────────────────────────────────────── │
│  通用算法 · 工具能力 · 与业务无关的复用代码      │
└──────────────────────────────────────────────┘
```

| 层 | 回答的问题 | 核心职责 | 依赖方向 |
|----|-----------|---------|---------|
| **app** | 应用如何组装？ | 路由、UI 布局组合、顶层 DI、平台 App 生命周期入口 | 依赖 feature |
| **feature** | 用户能完成什么？ | Compose UI、页面组件、UI 交互入口 | 依赖 store、scenario |
| **store** | 现在是什么状态？ | UI State Holder、状态变更、UI 所需响应式状态 | 依赖 scenario(只读结果)、provider(只读) |
| **scenario** | 流程怎么完成？ | 用户行为流程、多步骤业务编排、跨 provider 协调 | 依赖 provider、engine |
| **provider** | 外部世界怎么访问？ | Bilibili/Netease/GitHub 等外部服务适配、API、DTO、外部协议转换 | 依赖 engine、library |
| **engine** | 平台能力怎么实现？ | Network、Database、Storage、Crypto、Platform capability | 依赖 library |
| **libraries** | 哪些纯能力可复用？ | 通用算法、工具能力、与业务无关的复用代码 | 无依赖 |

---

## 各层详细职责

### app — 应用组合层

**定义**：应用的顶层组装点，负责将各模块组合为完整应用。

**职责**：
- 路由注册与导航图组合（Navigation Compose / Decompose / Voyager）
- UI 布局组合（App 壳、主题、Root 组件）
- 顶层 DI 容器配置（Koin / Kodein / KMP DI 方案）
- 平台 App 生命周期入口（Android Application、Desktop main、iOS AppDelegate）

**约束**：
- 只做组合，不包含业务逻辑
- 不直接依赖 Provider / Engine / Library
- 对 feature 的依赖仅限于「已知哪些 Feature 存在」，而非「包含 Feature 实现细节」

**示例**：
```
App (Android)
  ├── Koin.installModules(modules)
  ├── NavHost(startDestination)
  └── MaterialTheme { ... }

App (Desktop)
  ├── Koin.installModules(modules)
  ├── Window { NavHost() }
  └── MaterialTheme { ... }
```

---

### feature — UI 能力层

**定义**：用户可感知的功能单元。每个 Feature 是一个完整的用户能力。

**职责**：
- Compose UI 页面组件
- UI 交互入口与事件处理
- 页面级别的状态绑定（通过 Store）
- 功能入口注册

**约束**：
- 不包含 HTTP 请求、数据库操作
- 不包含 Provider 业务逻辑
- UI 事件通过 Intent/Action 传递给 Store/Scenario，不直接操作 Provider

**典型结构**：
```
features/
  player/
    PlayerScreen.kt        ← Compose UI
    PlayerIntent.kt        ← 用户意图定义
    PlayerNavigation.kt    ← 路由注册
```

---

### store — 状态持有层

**定义**：UI 的单一事实来源。负责状态管理、状态变更通知。

**职责**：
- UI State Holder（StateFlow / MutableStateFlow）
- 状态变更逻辑（Action → State 转换）
- UI 所需的响应式状态暴露

**约束**：
- 不包含 HTTP 请求、数据库操作
- 不包含 Provider 业务逻辑
- 纯状态机，不包含 UI 代码

**典型状态机模式**：
```
sealed interface PlayerState {
  data object Idle : PlayerState
  data object Loading : PlayerState
  data class Ready(val media: MediaInfo) : PlayerState
  data class Playing(val media: MediaInfo, val position: Long) : PlayerState
  data class Error(val message: String) : PlayerState
}
```

---

### scenario — 业务流程层

**定义**：用户级业务流程编排器。负责将多步骤业务逻辑组织为可理解、可测试的流程。

**职责**：
- 用户行为流程编排（如「登录 → 获取 Token → 加载用户信息」）
- 多步骤业务逻辑
- 跨 provider 协调
- 异常恢复与补偿

**约束**：
- 不包含 UI 代码
- 不直接处理平台 API（通过 Provider 转发）
- 每个 Scenario 对应一个完整的用户业务目标

**示例**：
```
LoginScenario
  1. 创建二维码 (Provider)
  2. 轮询扫码状态 (Provider)
  3. 保存 Cookie 到本地 (Engine)
  4. 加载用户信息 (Provider)
  5. 返回结果，由 Store 更新状态通知 UI
```

---

### provider — 外部适配层

**定义**：外部世界适配层。将不同外部服务（Bilibili、Netease、GitHub 等）统一为内部接口。

**职责**：
- 外部服务 API 封装
- HTTP/gRPC 通信
- API 认证与签名
- DTO 定义与协议转换
- 数据格式解析

**约束**：
- 不包含 UI 逻辑
- 不包含页面状态管理
- 不包含业务流程编排
- 不包含领域实体定义

**示例**：
```
providers/
  bilibili/
    BiliAuthApi.kt        ← 认证 API
    BiliPlayApi.kt        ← 播放 API
    BiliUserApi.kt        ← 用户 API
    dto/                  ← 数据转换对象
      LoginQRDto.kt
      VideoInfoDto.kt
```

---

### engine — 底层引擎层

**定义**：平台原生能力封装。将平台特定 API 统一为跨平台接口。

**职责**：
- Network（Ktor 客户端 / OkHttp 封装）
- Database（Room / SQLDelight）
- Storage（DataStore / 文件系统）
- Crypto（加密 / 解密）
- Platform capability（平台特定能力暴露）

**设计原则**：
- Engine 接口定义在共享模块（commonMain）
- 实现按平台分别提供（androidMain、iosMain、desktopMain）
- 使用 `expect`/`actual` 声明平台差异
- 禁止 Engine 层包含业务逻辑

**KMP 典型模式**：
```kotlin
// commonMain
expect class PlatformContext

expect fun createHttpClient(context: PlatformContext): HttpClient

// androidMain
actual class PlatformContext(
  val appContext: android.content.Context
)

actual fun createHttpClient(context: PlatformContext): HttpClient =
  HttpClient(OkHttp) {
    engine {
      config {
        // Android-specific config
      }
    }
  }

// iosMain
actual class PlatformContext

actual fun createHttpClient(context: PlatformContext): HttpClient =
  HttpClient(Darwin) {
    // iOS-specific config
  }
```

---

### libraries — 纯 Kotlin 内部实现库

**定义**：通用基础能力层，不依赖任何业务模块。

**职责**：
- 通用算法与数据结构
- 工具函数（Date/Time、String、Collection 扩展）
- 与业务无关的复用代码

**约束**：
- 不引用任何 Feature、Provider 或 Scenario 的类
- 不包含 Bilibili / YouTube / WebDAV 等特定平台逻辑
- 不包含业务状态管理
- 同一 Library 应能在所有 App 间复用

**KMP 生态库用途示例**：
| 能力 | 推荐库 | 说明 |
|------|--------|------|
| 序列化 | kotlinx-serialization | 官方多平台 JSON/Protobuf/CBOR |
| 协程 | kotlinx-coroutines | 官方多平台协程 |
| 网络 | Ktor Client | JetBrains 官方多平台 HTTP |
| 本地存储 | DataStore / SQLDelight / Room KMP | 多平台持久化 |
| 时间 | kotlinx-datetime | 官方多平台日期时间 |
| 导航 | Navigation Compose / Decompose / Voyager | 多平台路由 |
| 图片 | Coil 3 | 多平台图片加载 |
| 日志 | Kermit / Napier | 多平台日志 |

---

## 依赖规则

### 核心原则：依赖单向向下，信息流从下向上

```
app → feature → store → scenario → provider → engine → library
```

```
依赖方向    ────→
信息流动    ←────
```

### 详细规则

| 关系 | 允许 | 禁止 |
|------|------|------|
| feature → store | store 状态变更结果 | store 直接操作 UI |
| feature → scenario | 触发 scenario 执行 | 直接操作 Provider |
| store → scenario | 单向调用 scenario 并接收其返回结果 | 编排业务流程 / 直接写 Store |
| scenario → provider | 调用外部 API | 直接操作 UI/Store |
| scenario → engine | 使用平台能力 | 包含业务逻辑 |
| provider → engine | 使用 Network/Storage | 直接调用 UI |
| provider → library | 使用工具函数 | 包含业务逻辑 |
| engine → library | 使用通用工具 | 引用业务模块 |

### 常见违反模式

```
❌ feature → 直接调用 Provider
   → 导致 UI 层了解外部 API 细节，违反关注点分离

❌ store → 直接发 HTTP 请求
   → 状态管理混入网络逻辑，无法测试

❌ scenario → 直接操作 UI
   → 业务逻辑与 UI 耦合，无法测试业务流

❌ scenario → 直接写 Store
   → 业务逻辑直接修改状态，违反单向数据流
   → 应返回结果，由 Store 统一更新状态

❌ provider → 引用其他 Provider 的 DTO
   → 外部协议耦合，变更一个平台影响另一个

❌ libraries → 引用业务模块
   → 通用层腐蚀，无法复用
```

---

## KMP 多模态架构要点

### 模块编译目标分布

| 层 | commonMain | androidMain | iosMain | desktopMain |
|----|:----------:|:-----------:|:-------:|:-----------:|
| app | ✓ | ✓ | ✓ | ✓ |
| feature | ✓ | ✓ | ✓ | ✓ |
| store | ✓ | ✓ | ✓ | ✓ |
| scenario | ✓ | ✓ | ✓ | ✓ |
| provider | ✓ | ✓ | ✓ | ✓ |
| engine | 接口 | 实现 | 实现 | 实现 |
| library | ✓ | ✓ | ✓ | ✓ |

- 所有业务逻辑层（feature~provider）应尽可能在 `commonMain` 中完成
- `expect`/`actual` 仅用于平台能力差异点（文件系统、UI 框架、编解码器）
- 避免在 `androidMain`/`iosMain` 中放业务逻辑

### 跨平台依赖实践

```
commonMain
  ├── kotlinx-serialization     ← 实体序列化
  ├── kotlinx-coroutines         ← 协程
  ├── kotlinx-datetime           ← 日期时间
  ├── Ktor Client                ← HTTP 通信
  ├── Koin                       ← DI（多平台支持）
  └── Kotlin/Compose             ← UI（Compose Multiplatform）

androidMain
  └── Android-specific engine impls

iosMain
  └── iOS-specific engine impls
```

### 状态管理策略

```
User Action
    ↓
Store (Intent/Action)
    ↓
Scenario (Business Logic)
    ↓
Provider/Engine (Side Effects)
    ↓
Store (State Mutation)
    ↓
UI (Compose → collectAsState)
```

- **单向数据流（UDF）**：UI → Intent → Store → Scenario → Side Effect → Store → UI
- **副作用隔离**：所有副作用（网络、数据库、文件）仅在 scenario/provider/engine 中执行
- **状态不可变**：Store 对外暴露 `StateFlow<UiState>`，UI 通过 `collectAsState()` 消费

---

## 架构指标与优化

### 层级健康度指标

| 指标 | 衡量方式 | 健康值 |
|------|---------|--------|
| **依赖深度** | 最长依赖链长度 | ≤ 6 跳（app→library 全链） |
| **反向依赖数** | 下层引用上层的次数 | 0 |
| **模块内聚度** | 每个模块是否只回答一个问题 | 高内聚 |
| **跨层调用的比例** | 跳过中间层的直接调用数 | < 5% 的总调用 |
| **expect/actual 密度** | 每 100 行 expect/actual 声明数 | < 3（业务层趋近 0） |
| **commonMain 代码占比** | commonMain / 总代码行数 | > 70% |

### 架构腐化信号

| 信号 | 级别 | 表现 | 推荐操作 |
|------|------|------|---------|
| 跨层直接调用 | 🔴 | feature 直接 new Provider | 引入 Scenario 中介 |
| Store 含网络请求 | 🔴 | Store 中出现 HTTP 调用 | 将网络逻辑移至 Provider |
| Engine 含业务逻辑 | 🟡 | Engine 中有 if-else 判断业务 | 提取至 Scenario |
| Library 引用业务模块 | 🔴 | library 引用了 feature 的类 | 消除依赖，提取抽象 |
| Provider 互相引用 | 🟡 | bilibili provider 引用 webdav | 通过 Scenario 协调 |
| 模块职责模糊 | 🟡 | 分不清某个类属于哪一层 | 重新定义单一职责 |
| expect/actual 暴增 | 🟡 | 新平台的 expect 声明超过 10 个 | 检查是否适合 proxy 模式 |

### 架构优化清单

**启动阶段**：
- [ ] 确定分层边界，明确每层职责
- [ ] 建立模块间依赖关系图
- [ ] 配置编译检查（禁止反向依赖）

**迭代阶段**：
- [ ] 每次新增功能，判断所属层级
- [ ] 发现跨层调用，引入中介层（Scenario）
- [ ] 监控 commonMain 代码占比，避免平台逻辑泄漏

**重构阶段**：
- [ ] 检测并修复腐化信号
- [ ] 减少 expect/actual 声明，收敛平台差异
- [ ] 提取重复逻辑到 libraries

---

## 与现有模块职责的映射

本规范的分层与 umpp 现有组件角色定义完全兼容：

| 本规范 | 映射到现有角色 | 扩展说明 |
|--------|--------------|---------|
| app | 新增 | 原架构未显式定义应用组合层，本规范补全 |
| feature | Feature | 同现有定义 |
| store | Store | 同现有定义 |
| scenario | Scenario / Pipeline | 业务流程用 Scenario，数据处理用 Pipeline |
| provider | Provider | 同现有定义 |
| engine | Engine | 同现有定义 |
| libraries | Library | 同现有定义 |

**关键新增**：`app` 层补全了完整架构图谱，使路由、DI、平台生命周期有了明确的归属层，避免在 Feature 中处理全局组合逻辑。

---

## 引用

- [Kotlin Multiplatform 官方文档](https://kotlinlang.org/docs/multiplatform.html)
- [Compose Multiplatform 架构指南](https://www.jetbrains.com/lp/compose-multiplatform/)
- [Android 官方架构指南](https://developer.android.com/topic/architecture)
- [UDF (Unidirectional Data Flow) 模式](https://developer.android.com/jetpack/compose/architecture)
- 本规范与 [组件角色定义](component-roles.md) 互补，请结合使用