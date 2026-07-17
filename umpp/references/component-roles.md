# 🧠 核心组件职责约束（详细版）

## 📐 速查摘要

| 层 | 一句话 | 核心职责 | 红线 |
|----|--------|---------|------|
| **Feature** | 用户能完成什么 | UI + Store + Intent | 不包含 HTTP/DB |
| **Store** | 当前状态 | StateFlow 驱动 UI | 不包含 Provider 逻辑 |
| **Scenario** | 怎么完成 | 业务流程编排 | 不包含 UI 代码 |
| **Provider** | 怎么访问外部 | HTTP + 签名 + 解析 | 不包含 UI/Store |
| **Engine** | 平台怎么实现 | 平台 API 封装 | 不包含业务逻辑 |
| **Library** | 哪些能力复用 | 纯工具基础设施 | 不包含业务/Provider 知识 |

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

---

## Library

**定义**: 通用基础能力层，不依赖任何业务模块。

**可以包含**:
- 网络客户端封装（Ktor/OkHttp）
- 本地存储抽象
- 数据库访问层
- 加解密工具
- 日志基础设施
- 播放器抽象接口
- 字幕引擎封装

**禁止**:
- 引用任何 Feature 或 Provider 的类
- 包含 Bilibili/YouTube/WebDAV 等特定平台的逻辑
- 包含业务状态管理

**关键约束**: Library 不知道上层任何模块的存在，它只是工具集合。

---

## 📋 完整速查表

```
Feature  = 用户能力（What user does）
Store    = 当前状态（Current State）
Scenario = 业务流程（Business Flow）
Provider = 外部平台（External World）
Engine   = 平台能力（Platform Capability）
Library  = 通用基础能力（Reusable Capability）
```

> 每写一个新类，只问自己一句：**「这个类主要回答的是哪一个问题？」**
> 如果回答不出来，说明职责已混杂，应重新拆分。
