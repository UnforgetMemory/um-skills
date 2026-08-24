# ADR-003: 伞形单技能（统一入口 um + 单一规则源）

## Status

Accepted（2026-08-14，取代 [ADR-002](ADR-002-self-contained-skill-bundles.md)）

## Context

ADR-002 的 vendor 模型虽满足 vercel-labs/skills 的安装约束
（安装单元 = 技能自身目录，见 ADR-002 事实核查），但被两项架构审查意见否决：

1. **违背单一事实源初衷**：共享层复制四份，v6「分层下探、不吞并、
   只改 core 一处」的设计意图被回退；token 与维护成本模型受损
2. **路由污染**：四个技能各自内嵌 `references/`/`adapters/` 路由副本，
   形成四个可能漂移的副本边界

symlink 共享方案（仓库 DRY、安装时 `dereference: true` 解引用成实体）
因 Windows git 检出与 tarball 解包双链路均不可靠而否决
（下载走 GitHub tarball + npm `tar`，Assumption：Windows 无特权环境符号链接落地不可依赖）。

## Decision

**伞形单技能**：canonical 即安装物，全仓唯一一份规则源。

```
skills/um/
├── SKILL.md              ← 入口：触发词 → 专业分册路由表 + 公共前置
├── professions/
│   ├── umpp.md           ← 原 umpp/SKILL.md 正文（去 frontmatter 的路由表）
│   ├── umcommit.md · umrelease.md · umreview.md
├── references/           ← L0+L2 全量唯一副本（原 core/references）
└── adapters/<env>/       ← L3 唯一副本（原 adapters/）
```

- 根级 `core/`、`adapters/` 目录取消；`scripts/sync-references.ps1` 删除——
  无副本则无漂移，无需生成器与 `-Check` 门禁
- 入口 `SKILL.md`（name: um）只做路由与公共前置，不做业务决策；
  四专业保留触发词与完整 Phase 路由表，作为分册按需懒加载

## Rationale

- 同时满足三个硬约束：单一事实源（零复制）、零路由污染（单一路径形状）、
  安装器正确安装（单目录自包含单元，整库/单装等价）
- token 成本更优：常驻 summary 由 4 条降为 1 条；分册与 references 仍分层懒加载；
  同会话跨专业衔接（umpp→umcommit）时 references 天然只读一次
- 否决 symlink：用户主环境为 Windows，解包/检出脆弱性不可接受

## Consequences

- 技能注册列表只出现一个条目 `um`；四专业不再单独列出——
  触发词经入口 description 与路由表保留，调用 UX 不变
- 维护规则 = 直接编辑 `skills/um/references|adapters|professions`，
  一处生效，无同步步骤
- 新增专业 = 新建 `professions/<name>.md` 分册 + 入口路由表加一行
