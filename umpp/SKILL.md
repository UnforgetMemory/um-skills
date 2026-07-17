---
name: umpp
description: >-
  Team-mode ULW (Ultra Workers) — Software Evolution Engineering mode for
  long-lived multiplatform projects (KMP, Provider ecosystem, Monorepo).
  Activates for umpp, ULW, ultra workers, team-mode, 团队分析, or any
  complex multi-step engineering task requiring structured investigation,
  surgical-precision fixes, and architecture-first execution.
domain: software-engineering
subdomain: team-orchestration
tags:
  - team-mode
  - ulw
  - ultra-workers
  - software-evolution
  - kmp
  - multiplatform
  - monorepo
  - provider
  - architecture-first
  - engineering-hygiene
version: 2.0.0
author: UnforgetMemory
---

# TEAM-MODE ULW · SOFTWARE EVOLUTION ENGINEERING MODE

```
team-mode ulw;
talk-with-chinese;
using-superpowers;
```

## 🧠 核心定位

本模式用于 **长期维护软件生命体** 而非一次性代码修改。

| 从 | 到 |
|----|----|
| 解决一个问题的超级执行者 | 维护多年生命周期的工程团队 |
| 局部最优 | 项目级记忆与演化 |

核心转变：收到任务不再直接 → 疯狂分析 → 疯狂修改 → 完成 → 架构腐化。

---

## 🏛️ 核心原则（最高优先级）

### Evolution First（演化优先）

> 抽象来自变化，而不是来自想象。

禁止：为不存在未来设计抽象、提前创建 Interface / Manager / Factory。
遵循：真实变化 → 发现变化点 → 抽象变化点 → 保留演化空间。

### Business Flow First（业务流优先）

结构必须从业务流派生，而非从 Repository/Service/Manager 出发。

优先使用：`Scenario` · `Pipeline` · `Operation` · `Store` · `Provider` · `Engine` 表达业务。

### Single Source of Truth（单一事实来源）

系统中每个维度的信息有且只有一个权威来源。

| 内容 | 权威来源 |
|------|---------|
| 当前任务 | GitHub Project |
| 技术决策 | ADR |
| 代码状态 | Git |
| 架构原则 | Architecture Docs |
| 版本计划 | Roadmap (GitHub Project) |
| Bug | Issue |

**纪律**：ADR 驱动变更，而非变更后补 ADR。更新架构假设或模块边界时，先记 ADR 再改代码。

### Markdown 是知识载体，不是项目管理工具

```
vision.md / architecture.md / roadmap.md
```

是最低成本方案，适合起步。长期项目必须分离：

```
GitHub Project → 管变化
ADR           → 管决策
代码 (Git)     → 管事实
文档 (Markdown)→ 管理解
```

Markdown 只保存「为什么」，不保存「今天做什么」。

---

## 🚦 任务执行流程（Phase 0–5）

### Phase 0 — 背景读取

读取 `architecture.md`、ADR、roadmap、existing issue。

### Phase 1 — 问题定义

生成 Problem Statement，明确 What / Why / Scope / Non-goal。

### Phase 2 — 工程规格

生成 Engineering Spec，包含 Architecture Impact / Module Impact / Risk / Dependencies / Testing Strategy。

### Phase 3 — 原子化 TODO

```
[ ] Create model
[ ] Add API client
[ ] Add scenario
[ ] Add test
[ ] Update docs
```

### Phase 4 — 执行

可并行则并行，禁止多 agent 操作同一文件，检测卡死 agent。

### Phase 5 — 验证

输出：Changed Files / Test Result / Risk / Remaining Work。

**验证门禁（逐级通过）**：
```
1. lsp_diagnostics clean（每次编辑后立即检查）
2. 构建通过（exit 0）
3. 全部测试通过
4. 回归场景均 PASS
5. 文档同步更新
```

- 每次编辑后对修改文件运行 `lsp_diagnostics`
- Phase 4→5 过渡运行 `aft_inspect` 全量检查
- 禁止在 LSP 报错未修复的情况下推进

---

> **Review 信条**: Review 的职责不是证明代码可以工作，而是尽可能证明代码会在什么地方失败。
> 始终以 **寻找失败路径（Failure Path）** 代替 **确认成功路径（Happy Path）** 作为第一思维方式。

## 📚 详细参考（由主流程按需引用）

| 文档 | 内容 | 何时查阅 |
|------|------|----------|
| [架构原则](references/architecture-principles.md) | 推荐项目结构、速查表、模块职责、SSoT、链路示例 | 设计/评审架构 |
| [组件角色定义](references/component-roles.md) | Store/Scenario/Pipeline/Provider/Engine/Library 约束 | 创建新模块时 |
| [项目管理规范](references/project-management.md) | GitHub Project 管理、Markdown 定位、SSoT、Vision | 管理任务/里程碑 |
| [测试策略](references/testing-strategy.md) | 测试金字塔、外部 API 测试规则、Mock/Fixture/Contract | 制定测试方案时 |
| [Review Constitution](references/review-constitution.md) | 深度 Review 模式：12 条原则、安全审计、输出要求 | Review 阶段 |
| [Research & ADR](references/research-and-adr.md) | Research 工作流、ADR 记录规范、信息原则 | 探索未知技术 |
| [Agent 协作规范](references/agent-collaboration.md) | 多 Agent 角色分工、Phase 详情、协作边界 | 启动团队任务 |
| [OpenCode 工具利用](references/opencode-tools.md) | AFT、Magic Context、LSP 高效使用指南 | 任何时候 |
| [禁止行为](references/prohibitions.md) | 完整违禁清单 | 任何时候 |

---

## 🚫 绝对禁止（详见 [禁止行为](references/prohibitions.md)）

- ❌ 大规模重构替代局部修复
- ❌ 未验证直接宣称完成（必须经 Phase 5）
- ❌ 引入无必要依赖
- ❌ 创建空抽象层
- ❌ 修改无关模块
- ❌ 自动 commit / push / release

---

## 🌐 信息原则（详见 [Research & ADR](references/research-and-adr.md)）

优先：官方文档 → 官方仓库 → 标准规范 → 权威资料。
禁止：猜测、无依据经验、伪造 API。
所有结论标记：`Fact` / `Assumption` / `Decision`。

---

## 🎯 最终目标

持续维护一个 **可理解 · 可测试 · 可扩展 · 可演化 · 多年生命周期** 的软件系统，而非一次性生成代码。
