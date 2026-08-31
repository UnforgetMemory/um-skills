
# umpp — 规划专业（Software Evolution Engineering）

## 链路位置
- 前置：无（链路起点）
- 后继：umcommit（规划完成需提交时）→ umrelease（发布时）
- 并行：umreview（执行中各波次间可插入审查）

## 前置路由（最小集，先读）
1. read `references/base-constraints.md`（元约束，必须）
2. read `references/prohibitions.md`（禁令清单 + 安全门禁 A-D，必须）
3. read `references/environment-routing.md` → 识别环境 → `adapters/<env>/tools.md`（会话内一次）
4. 其余 L0 延迟加载：`references/context-adaptation.md` 到 Phase 0 档位自检；`references/project-memory.md`/`references/artifact-routing.md` 到 P0 记忆与产物扫描；`references/subagent-orchestration.md` 到首次分派；`references/destructive-ops-gates.md` · `references/recovery-points.md` 到首次修改/删除前

## 核心定位
长期维护软件生命体，而非一次性修改。抽象来自真实变化（Evolution First）。

## 硬性纪律
1. 修改/删除前过安全门禁（root 唯一识别 + 版本管理强制 + git 仓库/remote/身份，缺失或识别不出则询问用户）并按 `references/destructive-ops-gates.md` D0-D3 分级执行（D2/D3 前建恢复点，见 `references/recovery-points.md`）；工作区外操作走 OOB 确认流（理由 + 可恢复性提示）
2. 禁止大规模重构替代局部修复；禁止创建空抽象层
3. ADR 驱动变更：改架构假设先记 ADR 再改代码
4. 禁止自动 commit/push/release

## 执行管线（路由表）

| Phase | 做什么 | read（按需） | 工具 | 决策点 |
|-------|--------|-------------|------|--------|
| P0 | 背景读取：architecture.md/ADR/roadmap/issue + .um.agents 记忆 + **产物扫描**（识别未归档 agent 产物 → 迁移决策 → 记入记忆） | references/project-management.md · references/artifact-routing.md | read/grep | 记忆缺失→询问；产物→迁移决策 |
| P1 | 问题定义：Problem Statement（What/Why/Scope/Non-goal） | — | — | 范围确认 |
| P2 | 工程规格：Architecture/Module Impact/Risk/Dependencies/Test Strategy | references/architecture-principles.md · references/component-roles.md · references/modern-architecture.md · references/research-and-adr.md | read | 架构评审 |
| P3 | 原子化 TODO：每项独立可验证、标依赖 | — | todo_write | 拆分确认 |
| P4 | 波次执行：可并行→subagent 决策树；禁止同文件并发 | references/subagent-orchestration.md | subagent/workflow | 冲突检测 |
| P5 | 验证：构建+测试全绿；文档同步 | references/testing-strategy.md | 环境工具 | 门禁逐级过 |

## 波次编排
按 P0→P5 依赖切波；P4 内独立任务按 `references/subagent-orchestration.md` 决策树分派；
每波产出结构化证据（文件:行），波间收缩保留摘要。

## 验证门禁
1. 语言工具链检查通过 → 2. 构建 exit 0 → 3. 测试全绿 → 4. 文档同步 → 5. 证据齐全

## 输出报告
```
## umpp 报告
### 问题定义 / 工程规格
### 变更文件（带证据）
### 验证结果（构建/测试输出）
### 风险与剩余工作
### ⚠️ 状态: COMPLETED / BLOCKED
```
