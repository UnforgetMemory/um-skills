# 🤖 Agent 协作规则 & 🚦 任务启动流程详情

## Agent 角色分工

| 角色 | 职责 |
|------|------|
| **Architect** | 架构设计、ADR 记录、技术选型 |
| **Researcher** | 官方资料收集、技术验证、PoC |
| **Developer** | 实现编码 |
| **Reviewer** | Code Review、设计检查 |
| **Tester** | 测试策略制定、回归验证 |

### 协作纪律

**禁止** 多个 Agent **同时修改同一文件**。

所有分布式工作必须通过以下方式协调：
- `task` 分配明确任务边界
- 任务输出可独立回收
- 冲突时回滚并重排

---

## 🚦 任务启动流程（Phase 详情）

### Phase 0 — 背景读取

读取以下文档（按优先级）：

1. `architecture.md` — 项目架构概览
2. `docs/ADR/` — 历史架构决策
3. `docs/roadmap.md` — 路线图
4. 相关的 existing issue

### Phase 1 — 问题定义

生成 `Problem Statement`，明确：

- **What**: 要解决什么问题
- **Why**: 为什么要现在解决
- **Scope**: 范围边界
- **Non-goal**: 明确不做什么

### Phase 2 — 工程规格

生成 `Engineering Spec`，包含：

- **Architecture Impact**: 对现有架构的影响
- **Module Impact**: 哪些模块需要修改
- **Risk**: 风险分析与缓解措施
- **Dependencies**: 内部/外部依赖关系
- **Testing Strategy**: 测试策略

### Phase 3 — 原子化 TODO

TODO 必须满足：
- 每个条目可独立验证
- 标注依赖关系
- 标注风险点

示例：
```
[x] Create User model (Entity + JSON serialization)
[ ] Add login API client (Retrofit service)
[ ] Add login Scenario (QR → Wait → Cookie → User)
[ ] Add LoginStore (Idle → Scanning → LoggedIn → Error)
[ ] Add Scenario test (Mock API → assert state transition)
[ ] Update docs/architecture/login-flow.md
```

### Phase 4 — 执行

执行纪律：
- 可并行则并行（多 agent 同时工作）
- **禁止** 多个 agent 操作同一文件
- 必须监控 agent 状态（alive / stuck detection）
- 失败必须回滚并重新规划

### Phase 5 — 验证

输出以下内容：

```
Changed Files:
  - src/common/main/kotlin/...  (新增)
  - src/common/test/kotlin/...  (新增)

Test Result:
  - Provider Contract Test: ✅ 5/5
  - Scenario Test: ✅ 3/3
  - UI Test: ✅ 2/2

Risk:
  - 无已知风险

Remaining Work:
  - 无
```
