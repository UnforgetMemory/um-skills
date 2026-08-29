# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.1] - 2026-08-29

### Added

- **时间锚点语义**：`base-constraints.md` 新增「时间与最新语义」——「最新/当前」指实时时间（实时互联网授时 → 本地时钟 → 询问用户），禁止当作模型知识截止时间；锚点只进会话记忆，新会话重新确认
- **.um.agents 时间戳规范**：`project-memory.md` 要求 constraints/ 与 memory/ 全部 .md 文件头带秒级 `createdAt`/`updatedAt`（实时锚点取值）；修改同步 `updatedAt`；读取时 > 90 天视为可能过期须确认
- **缓存稳定扩展**：动态频繁的值在指令与 reference 只存权威获取源（URL/工具），不存值本身，防 KV Cache 失效
- **umreview 重审闭环**：审查中任何修改 → 修改点重新完整审查，直至一轮零修改或人工确认
- **umreview 全深度双向溯源**：改动点向上追至调用入口/数据源、向下追至调用叶子/最终输出，无论层级深浅禁止截断；新发现受影响文件递归纳入；`review-constitution.md` 接入 P1 路由

### Changed

- `prohibitions.md`: 新增 #6（截断溯源）与 #10（审查中修改不重审），编号整体顺移为 11–19
- `.um.agents/` 现有文档补齐秒级时间戳 meta（回溯登记）
- `.gitignore` / `project-rules.md`: 根级 `.umc-*` 等临时文件模式合并为 `.um.agents/tmp/` 目录级忽略

## [0.2.0] - 2026-08-24

### Fixed

- **skills 安装丢失共享层** — vercel-labs/skills 只复制技能自身目录（缺 `name`/`description` frontmatter 的目录被跳过），根级共享层从不参与安装，导致技能路由表 `../` 引用悬空、reference 无法溯源：
  - 采用**伞形单技能**方案：唯一技能目录 `skills/um/` 内含入口路由（触发词 → 专业分册）、四专业分册 `professions/*.md`、以及 `references/` 与 `adapters/` 的**全仓唯一副本**——canonical 即安装物，整库或单技能安装均完整可溯源
  - 零复制零漂移：无生成器、无同步门禁；编辑直接发生在 `skills/um/` 内，一处生效
  - 决策演进：安装桩（ADR-001）→ 每技能 vendor（ADR-002）→ 伞形收敛（[ADR-003](docs/adr/ADR-003-umbrella-single-skill.md)）；ADR-001/002 已标记 Superseded

### Changed

- **仓库布局收敛**：根级 `core/`、`adapters/` 与四个独立技能目录取消，统一迁入 `skills/um/`；常驻 skill summary 由 4 条降为 1 条，references 分层懒加载不变
- `ARCHITECTURE.md`: 新增「仓库布局与伞形单技能」，重写路径约定 / 维护指南 / 部署
- `README.md` / `README.en.md`: 快速开始以 skills 安装器为推荐方式，专业文档指向 `professions/` 分册
- `deploy.ps1`: 部署唯一目录 `skills/um`；检测目标机 v0.1.x 旧布局残留仅提示不删除
- `.um.agents/constraints/project-rules.md`: 架构约束与维护纪律改为 um 单一事实源模型

## [0.1.2] - 2026-08-14

### Fixed

- **4 个 SKILL.md 引用路径修复** — DSH 部署后 `core/references/` 与 `adapters/` 为技能目录的兄弟目录，路径必须加 `../` 前缀（`../core/references/xxx.md` / `../adapters/<env>/tools.md`），否则按技能基目录解析会指向不存在的文件：
  - umpp/SKILL.md、umcommit/SKILL.md、umrelease/SKILL.md、umreview/SKILL.md
- 统一文本内裸名引用为完整路径（`decision-panel.md`、`subagent-orchestration.md` → `../core/references/...`）

### Added

- `deploy.ps1` 一键部署脚本（复制 core/adapters/4 技能到 `~/.dsh/skills/`）
- Professional README with logo, badges, Ko-fi donation button, and table of contents
- English README (README.en.md) with language switch
- VERSION file for formal version source (0.1.1)

### Changed

- `ARCHITECTURE.md`: 新增「路径约定」章节（部署后目录结构 + `../` 前缀要求），更新部署命令
- `.um.agents/constraints/hardcode-index.md`: sync version pointer to VERSION

## [0.1.0] - 2026-08-14

### Added

- **v6 架构重构** — 多环境（DSH / OpenCode / Codex）可路由的工程技能链路库：
  - **四层架构**：L0 基础约束（6 文件）→ L1 专业编排（4 个 SKILL.md 路由表）→ L2 流程规则（25 个细分文件）→ L3 环境工具（3 环境 × 2 文件）
  - **环境路由**：system prompt 特征 → 工具签名 → 询问 + 记忆（`.um.agents/memory/environment.local.md`）
  - **决策面板**：一次多问（ask_user_question GUI 弹窗），版本选项智能适配（SemVer/CalVer/自定义），CalVer 链 `YYYY.MM.DD[.HHMM[.NN]]`
  - **上下文自适应**：L/M/H 档位 + 波次迭代收缩模式（步骤完整性优先）
  - **Subagent 编排**：决策树（可并行/环境支持/边界清晰）+ 生命周期管控 + 下探分派（只带自己的 reference）
  - **项目记忆**：`.um.agents/` 硬编码语义索引（`语义 | 值 | 短路径 | 同步说明`），解决升级版本漏硬编码；local 不 sync（`*.local.md`）
  - **缓存稳定**：指令文本零动态值，KV Cache 前缀稳定
  - **面向 Agent**：SKILL.md/references 浓缩指令化；**面向人类**：README/ARCHITECTURE 解释文档分离

### Changed

- **umpp** — 从 207 行全量指令 → 65 行路由表（链路位置/前置路由/档位/Phase 表）
- **umcommit** — 从 98 行 → 78 行路由表；三轮提问 → 一次决策面板；版本源官方优先 + 硬编码索引联动
- **umrelease** — 从 94 行 → 77 行路由表；CalVer 时间版本链；CI 门禁按项目栈选 1 个 ci-*.md
- **umreview** — 从 139 行 → 76 行路由表；核磁共振式审查（逐文件证据矩阵 + 私货扫描）

### Removed

- 旧 references 目录（umpp/umcommit/umrelease/umreview/references）— 内容迁移至 core/references/
- OpenCode 专属工具引用（aft_*/ctx_*/lsp_diagnostics）— 由 adapters/ 按环境路由替代

## [Unreleased]（历史条目）

### Added

- **umpp skill v2.2.0** — modern KMP/Kotlin multi-modal architecture reference:
  - Seven-layer architecture: app / feature / store / scenario / provider / engine / libraries
  - Unidirectional dependency rules with common violation patterns
  - KMP multi-platform specifics: `expect`/`actual` strategy, compile target distribution, library ecosystem
  - Architecture health metrics, degradation signals, and optimization checklist
  - Cross-reference mapping to existing umpp component roles
- **umpp skill v2.1.0** — pre-flight safety gate constraint for unconfigured directories:
  - Mandatory A/B/C safety gates before ANY modification/deletion: git repository existence (`git rev-parse --is-inside-work-tree`) → remote configured (`git remote`) → commit identity set (`user.name` / `user.email`)
  - Any modification/deletion is blocked when a gate is unmet, with a Chinese-language prompt and explicit user permission required before continuing
  - Updated `references/prohibitions.md` with the new Safety Gates category (A/B/C gate table + ordering rules)
- **umrelease skill** — automated GitHub Release publishing pipeline:
  - CI dry-run gate: runs release build + test WITHOUT publishing, iterates until success before any tag/release
  - Professional, concise English Release Notes generation via changelog-automation and conventional-commits
  - Release Notes security audit: blocks internal API endpoints, implementation details, secrets, internal IPs, and private references from public release notes
  - Version detection (package.json / pyproject.toml / Cargo.toml / build.gradle / pubspec.yaml / VERSION / git tag) with SemVer tag generation
  - `gh release create` publishing with support for assets, prerelease, draft, and target branch
  - Manual confirmation gates: version confirmation before tagging, Release Notes review before publishing
  - Hard rules: CI dry-run must pass before any tag; release notes shown for manual review before publishing; zero internal details exposed
- **README**: skills table entry for the umrelease skill
- **umreview skill** — automated pre-merge code review and hygiene pipeline:
  - Multi-axis code review (correctness / readability / architecture / security / performance) with severity-labeled findings (`Critical:` / `Nit:` / `Optional:` / `FYI`)
  - Necessary concise English comments (WHY-only, no noise, no commented-out code)
  - Security audit with secrets scanning (`git diff` / `git grep` key-prefix patterns), trust boundaries, SSRF, and dependency audit
  - Comprehensive `.gitignore` coverage audit for non-source artifacts — directory-level rules preferred, verified via `git status --ignored` and `git check-ignore -v`
  - Required test coverage assessment with RED → GREEN → SURFACE discipline
  - Cleanup of outdated tests (list first, human-confirmed deletion only), leftover test processes, and build artifacts
  - Hard rule: never auto-commit or push — every change is left uncommitted for manual review
- **README**: skills table entry for the umreview skill
- **umcommit skill** — automated CHANGELOG / commit / push pipeline:
  - Security-audited CHANGELOG generation via `changelog-automation` (Keep a Changelog classification mapping + versioned release flow)
  - Security-audited conventional commit messages via `conventional-commits` (atomic commit groups, `--signoff`, AI-attribution footer)
  - Dual security audit via `security-and-hardening`: CHANGELOG text scan + staged diff/message scan with Critical/High Hard Block
  - Version detection (package.json / pyproject.toml / Cargo.toml / build.gradle / pubspec.yaml / VERSION) with mandatory major/minor/patch upgrade question and computed target version
  - Hard rules: commit content always shown for confirmation first; push only after explicit user approval
- **README**: skills table entry for the umcommit skill
