# 🧠 核心组件职责约束（详细版）

## Store

**定义**: UI 状态容器。

```
User Action
    ↓
State Mutation
    ↓
UI Rendering
```

**禁止**:
- HTTP 请求
- 数据库操作
- Provider 业务逻辑

**典型状态机**:
```
PlayerStore
  Idle
  Loading
  Ready
  Playing
  Error
```

---

## Scenario

**定义**: 用户级业务流程编排器。

负责：
- 多步骤编排
- 异常恢复与补偿
- 状态转换协调
- 业务规则执行

**示例**: `LoginScenario` 包含 QR 创建、等待扫码、Cookie 保存、用户加载。

---

## Pipeline

**定义**: 多阶段数据处理流水线。

适用于：
- AI 推理链路
- 字幕提取/识别/翻译/渲染
- 下载/转码工作流
- 数据同步

**特点**：
- 每个阶段独立可测
- 支持插拔式阶段替换
- 错误阶段可重试/跳过

---

## Provider

**定义**: 外部世界适配层。

负责：
- HTTP/gRPC 通信
- API 认证与签名
- 协议解析
- 数据格式转换

**禁止**：
- UI 逻辑
- 页面状态管理
- 业务流程编排
- 领域实体定义

---

## Engine

**定义**: 平台原生能力封装。

负责将平台特定 API 统一为跨平台接口。

**示例**:
```
PlayerEngine (interface)
  AndroidPlayerEngine → ExoPlayer
  DesktopPlayerEngine → MPV
```

**设计原则**:
- Engine 接口定义在共享模块
- 实现按平台分别提供
- 禁止 Engine 层包含业务逻辑
