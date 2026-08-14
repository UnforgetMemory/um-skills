# UM Skills 架构（v6 — 多环境链路）

> 人类阅读文档。面向 Agent 的规则见各 `SKILL.md` 与 `core/references/`。

## 设计目标

1. **多环境路由**：同一套 skill 在 dsh / opencode / codex 下自动选择正确的工具与能力
2. **Token 最小化**：分层下探（L0→L3），任何一层都不吞并其他层的内容
3. **项目记忆**：`.um.agents/` 硬编码语义索引，解决「升级版本漏改硬编码」
4. **决策合并**：一次决策面板替代多轮提问，GUI 弹窗优先
5. **上下文自适应**：L/M/H 档位 + 波次迭代收缩，步骤完整性优先
6. **缓存稳定**：指令文本零动态值，KV Cache 前缀稳定

## 四层架构

```
L0 基础约束层  core/references/{base-constraints, environment-routing,
                context-adaptation, decision-panel, subagent-orchestration,
                project-memory}.md
                ← 所有 skill 引用，单一事实来源

L1 专业编排层  4 个 SKILL.md = 路由表（Phase → reference 映射）
                umpp（规划）· umcommit（提交）· umrelease（发布）· umreview（审查）
                ← 每行 Phase 标注：做什么 / read 什么 / 用什么工具 / 决策点

L2 流程规则层  core/references/ 其余 ~25 个细分文件
                ← 每个 = 一个可独立委派的子任务边界（subagent 只读自己的）

L3 环境工具层  adapters/{dsh,opencode,codex}/{tools,capabilities}.md
                ← 平台工具映射与能力档案，会话内读一次
```

## 链路（Skill Chain）

```
umpp（规划）→ umcommit（提交）→ umrelease（发布）
       ↑ 任意阶段可插入 umreview（审查）
```

## 关键机制

### 环境路由（三阶，成本递增）
1. **system prompt 特征**（零成本）：含 dsh/DeepSeek Harness → dsh；aft_*/ctx_* → opencode；codex → codex
2. **工具签名**：pwsh/cordis_* / AFT+Magic Context / codex 特征
3. **询问 + 记忆**：ask 用户选择 → 写入 `.um.agents/memory/environment.local.md`（不 sync）

### 决策面板（一次多问）
- 交互工具一次传多个问题 + 结构化选项（GUI 按钮卡片）
- 版本选项智能适配：SemVer 项目只给 [major/minor/patch/自定义/skip]；CalVer 项目只给日期选项
- CalVer 链：`YYYY.MM.DD` → 同日追加 `.HHMM` → 同日同刻追加 `.NN`（随机二位数）
- 版本源官方优先：package.json → ... → git tag；`.um.agents` 索引仅为硬编码同步清单

### 波次迭代（步骤完整性优先）
- 流程切波，每波独立可验证；波内只读当前波 reference
- 波间收缩：保留「波摘要 + 证据位置」，细节走环境压缩或疏散 subagent
- 容量不足唯一降级 = 波切更细，绝不删步骤

### Subagent 编排
- 决策树：可并行？环境支持？边界清晰？→ 都不满足则主 agent 串行
- 下探分派：subagent 只带自己链路的 reference，不吞并无关内容
- 生命周期：DoD 明确 → 超时/幻觉中断 → 完成后逐项验证 + 证据回报

### 项目记忆（.um.agents/）
```
constraints/   入库（团队共享）：hardcode-index.md · project-rules.md
memory/        不 sync：*.local.md（环境/决策草稿/陷阱）
```
- 硬编码索引：`语义 | 值 | 短路径(文件:行) | 同步说明`，升级按索引逐处同步
- `.um.agents/.gitignore` 自包含（memory/ + *.local.md）

## Token 账本（按实测字符数估算）

> 实测基准：中文内容 ≈ 1 字符 ≈ 1 token（下界）。实际 token 数取决于分词器，此处为数量级参考。

| 项 | 实测字符数 | 估算 tokens |
|----|-----------|------------|
| 常驻（各 skill summary） | ~400 字符 | ~400 |
| 单个 SKILL.md（L1 路由表） | 2,065–2,599 | ~2,000–2,600 |
| L0 基础约束（按需 read，6 文件合计） | 4,733 | ~2,400–4,700 |
| 单个 L2 reference | 626–3,388（平均 1,413） | ~600–3,400 |
| L3 adapter（会话一次） | 532–1,504 | ~500–1,500 |
| 典型 umcommit 全流程 | — | ~3,000–4,000（旧版 ~5,000） |
| subagent 单任务分派 | — | ~500–800（任务 + 1 reference + adapter） |

> 说明：全流程成本低于「所有 reference 之和」，因为按需加载——每个 Phase 只读自己需要的文件，简单任务（如仅提交无版本升级）只加载 SKILL.md + 1-2 个 L2。

## 路径约定（部署后）

```
~/.dsh/skills/
  core/references/          ← L0+L2 引用文件（无 SKILL.md，不注册为 skill）
  adapters/<env>/           ← L3 环境适配器
  umpp/SKILL.md             ← L1 技能路由表
  umcommit/SKILL.md
  umrelease/SKILL.md
  umreview/SKILL.md
```

**SKILL.md 中的路径必须使用 `../` 前缀引用 `core/` 和 `adapters/`**，因为技能基目录解析为 `~/.dsh/skills/<skill>/`，而 `core/` 和 `adapters/` 是其兄弟目录（同级）。例如：
- `read ../core/references/base-constraints.md` ✅
- `read core/references/base-constraints.md` ❌ — 解析为 `~/.dsh/skills/<skill>/core/references/...`，文件不存在

## 维护指南

| 变更 | 位置 |
|------|------|
| 工具升级（某环境） | 只改 `adapters/<env>/tools.md` |
| 安全审计规则 | 只改 `core/references/security-audit.md` |
| 版本规则 | `version-detection.md` + `version-tag.md` |
| 新增流程规则 | 平台无关 → core；平台相关 → 对应 adapter |
| 新增专业 skill | 新建目录 + L1 路由表 + 引用 L0/L2 |
| 人类文档 | README.md / ARCHITECTURE.md（禁止 agent 指令混入） |

## 部署

```bash
# 快速部署（Windows PowerShell 或 Bash）
cp -r core ~/.dsh/skills/core
cp -r adapters ~/.dsh/skills/adapters
cp -r umpp umcommit umrelease umreview ~/.dsh/skills/

# 或使用部署脚本（推荐）
./deploy.ps1
```

> `core/` 与 `adapters/` 无 SKILL.md，不会被注册为 skill，仅被 `read` 工具引用。
> 部署后需确保路径约定正确：SKILL.md 中所有引用使用 `../` 前缀。
> 首次部署后需重载技能（重启 DSH 进程或重新加载技能目录）使变更生效。
