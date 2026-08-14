---
name: umreview
description: >-
  UM 工程链路 · 审查专业。核磁共振式全面审查：五轴 Code Review（逐文件
  证据矩阵）→ 英文注释 → 安全审计 → gitignore 覆盖 → 测试覆盖 → 清洁。
  波次编排执行，全程不提交不推送。触发词：umreview/审查/清理/安全审计/
  pre-merge review。
whenToUse: >-
  User says umreview, review and cleanup, 审查并清理, pre-merge review,
  or asks for code review + security audit + gitignore + test coverage +
  artifact cleanup in one pass. Never auto-commits or pushes.
disable-model-invocation: false
user-invocable: true
---

# umreview — 审查专业（核磁共振式全面审查）

## 链路位置
- 前置：任意（umcommit/umrelease 前插入）
- 后继：umcommit（审查通过后提交）
- 并行：umpp（执行中波次间审查）

## 前置路由（最小集，先读）
1. read `../core/references/base-constraints.md`（元约束，必须）
2. read `../core/references/environment-routing.md` → 环境 → `../adapters/<env>/tools.md`（会话内一次）
3. 其余 L0 延迟加载：`../core/references/context-adaptation.md` 到 Phase 0 档位自检；`../core/references/subagent-orchestration.md` 到波次分派；`../core/references/project-memory.md` 到 P7 私货对照

## 核心定位
一次调用完成提交前全面体检。信条：**寻找失败路径，而非确认成功路径。**
审查 = 全身扫描（核磁共振），不是翻翻看看：逐文件 × 逐轴输出证据矩阵。

## 硬性纪律
1. 禁止自动 commit/push/release；所有变更留人工审查
2. 禁止删除未经确认的测试（先列清单→确认→删）
3. 禁止修改无关模块
4. 注释必须简洁英文（WHY 不重复 WHAT）
5. 每个文件必须显式回报「已检查/发现 X/无异常」——不得跳文件

## 执行管线（路由表）

| Phase | 做什么 | read（按需） | 工具 | 决策点 |
|-------|--------|-------------|------|--------|
| P0 | 范围界定：git status/diff，changed files 清单 | — | 环境命令 | 审查基准 |
| P1 | 五轴审查：逐文件证据矩阵（Correctness/Readability/Architecture/Security/Performance） | ../core/references/review-axes.md | read/grep | 严重度标注 |
| P2 | 注释规范检查：WHY-only 英文注释 | ../core/references/review-comments.md | 文件工具 | 噪音注释删除 |
| P3 | 安全审计：敏感信息扫描 + 信任边界 | ../core/references/security-audit.md | grep/命令 | Critical→阻断 |
| P4 | gitignore 覆盖审计：目录级优先 | ../core/references/review-gitignore.md | 命令 | check-ignore 验证 |
| P5 | 测试覆盖评估：行为变更 → 覆盖缺口 → RED→GREEN | ../core/references/review-test-coverage.md | 测试命令 | 补测决策 |
| P6 | 清洁：过期测试（确认后删）/遗留进程/产物 + **轻量产物扫描**（未跟踪 agent 产物 → 记忆命中直接应用，仅新产物提示迁移决策） | ../core/references/review-cleanup.md · ../core/references/artifact-routing.md | 命令 | 确认后执行；迁移决策 |
| P7 | 私货扫描：对照 .um.agents/constraints/ 查未申报修改/硬编码后门 | ../core/references/project-memory.md | grep/read | 违规标记 |

## 核磁共振审查（P1/P7 核心）
- 证据矩阵：每个变更文件 × 五轴 → 输出 `<文件>:<行> — [严重度] 问题 — 修复`
- 私货检查：未申报修改、隐藏逻辑、悄悄放宽校验、硬编码后门
- 与项目约束对照：违反 `.um.agents/constraints/` 的改动显式标记
- 文件多 → 波次分派 subagent（每 subagent 一文件组，独立证据矩阵，主 agent 汇总）

## 验证门禁
1. 逐文件检查后：语言工具链 clean
2. P5：测试套件全绿（RED→GREEN 证据）
3. P4：check-ignore 确认全部非源码产物被忽略
4. 终态：git status 全部变更未提交

## 输出报告
```
## umreview 报告
### 变更范围
### 审查发现（证据矩阵，按严重度分组）
### 新增/修改内容（注释/测试/gitignore）
### 清洁项（过期测试/进程/产物）
### 私货检查结果
### 验证证据
### ⚠️ 状态: NOT COMMITTED — 全部变更等待人工审查
```
