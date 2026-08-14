# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
