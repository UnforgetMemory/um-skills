<div align="center">
  <img src="LOGO.png" alt="UM Skills Logo" width="320" height="320">

  # UM Skills — 工程技能链路库

  <p align="center">
    <strong>多环境（DSH / OpenCode / Codex）可路由的工程技能链路库</strong><br>
    规划 → 提交 → 发布，任意阶段可插入审查
  </p>

  <p align="center">
    <a href="README.en.md">English</a> · <b>简体中文</b>
  </p>

  <p align="center">
    <a href="LICENSE">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square" alt="MIT License">
    </a>
    <a href="https://github.com/unforgetmemory/um-skills">
      <img src="https://img.shields.io/badge/repo-um--skills-1a1a2e?style=flat-square&logo=github" alt="GitHub Repo">
    </a>
    <a href="https://ko-fi.com/unforgetmemory">
      <img src="https://img.shields.io/badge/☕%20ko--fi-支持项目-FF5E5B?style=flat-square" alt="Ko-fi">
    </a>
    <img src="https://img.shields.io/badge/status-stable-4ecdc4?style=flat-square" alt="Status: Stable">
    <img src="https://img.shields.io/badge/env-dsh%20%7C%20opencode%20%7C%20codex-45b7d1?style=flat-square" alt="Environments">
  </p>
</div>

---

## 📋 目录

- [✨ 简介](#-简介)
- [🚀 快速开始](#-快速开始)
- [🧩 技能一览](#-技能一览)
- [🏗️ 架构简述](#️-架构简述)
- [📁 项目记忆](#-项目记忆)
- [📚 详细设计](#-详细设计)
- [🤝 支持项目](#-支持项目)
- [📄 许可证](#-许可证)

---

## ✨ 简介

**UM Skills** 是一套面向 AI Agent 的工程技能链路库，覆盖软件工程全生命周期：

| 阶段 | 技能 | 职责 |
|------|------|------|
| 规划 → | **umpp** | 复杂多步工程任务的结构化调查与架构优先执行 |
| 提交 → | **umcommit** | CHANGELOG 审计 + Conventional Commit + 原子提交 + 推送 |
| 发布 → | **umrelease** | CI dry-run 门禁 + 专业 Release Notes + SemVer/CalVer 版本管理 |
| 审查 ↔ | **umreview** | 核磁共振式五轴审查 + 安全审计 + 测试覆盖 + 清洁 |

四者组成完整工程链路，支持 **DSH**（DeepSeek Harness）、**OpenCode**、**Codex** 三大 AI Agent 环境，自动路由工具与能力。

> 💡 **设计理念**：软件是生命体，而非一次性修改。抽象来自真实变化（Evolution First）。每一层都不吞并其他层的内容，subagent 只携带自己链路的 reference。

---

## 🚀 快速开始

### 使用 skills 安装器（vercel-labs，推荐）

```bash
npx skills add unforgetmemory/um-skills
```

> 伞形单技能：唯一技能目录 `skills/um/` 内含入口路由、四个专业分册与
> references / adapters 唯一副本——单一事实源、零复制零漂移，安装即所得
> （[ADR-003](docs/adr/ADR-003-umbrella-single-skill.md)）。

### 部署到 DSH

```bash
cp -r skills/um ~/.dsh/skills/
```

### 部署到 OpenCode

```bash
cp -r skills/um ~/.opencode/skills/
```

### 使用方式

在任意支持环境中，对 AI Agent 说出以下触发词即可调用对应专业：

| 触发词 | 效果 |
|--------|------|
| `umpp` | 启动规划专业：Problem Statement → Spec → TODO → 波次执行 → 验证 |
| `umcommit` | 启动提交专业：CHANGELOG + 审计提交 + 推送（一次决策面板） |
| `umrelease` | 启动发布专业：CI dry-run 门禁 → Release Notes → 版本 tag → gh 发布 |
| `umreview` | 启动审查专业：核磁共振式五轴审查，不提交不推送 |

---

## 🧩 技能一览

> 四个专业收敛于统一入口技能 **um**（[ADR-003](docs/adr/ADR-003-umbrella-single-skill.md)）：
> 安装后由触发词路由到对应分册，下表按专业列出。

| Skill | 专业 | 一句话 | 详细文档 |
|-------|------|--------|----------|
| [**umpp**](skills/um/professions/umpp.md) |📐 规划 | 复杂多步工程任务的结构化调查与架构优先执行 | [路由表](skills/um/professions/umpp.md)|
| [**umcommit**](skills/um/professions/umcommit.md) | ✅ 提交 | CHANGELOG + 审计提交 + 推送（一次决策面板，版本智能适配） | [路由表](skills/um/professions/umcommit.md) |
| [**umrelease**](skills/um/professions/umrelease.md) | 🚀 发布 | CI dry-run 门禁 → Release Notes → SemVer/CalVer tag → gh 发布 | [路由表](skills/um/professions/umrelease.md) |
| [**umreview**](skills/um/professions/umreview.md) | 🔍 审查 | 核磁共振式五轴审查 + 安全/gitignore/测试/清洁，不提交不推送 | [路由表](skills/um/professions/umreview.md) |

### 技能链路

```
umpp（规划）──→ umcommit（提交）──→ umrelease（发布）
       ↑ 任意阶段可插入 umreview（审查）
```

---

## 🏗️ 架构简述

项目采用 **四层架构**，实现分层下探、按需取用：

```
┌─────────────────────────────────────────────────────────────┐
│  L0  基础约束层                                              │
│  um/references/ (6 个文件)                                   │
│  元约束 · 环境路由 · 上下文自适应 · 决策面板 · Subagent 编排 · 项目记忆 │
├─────────────────────────────────────────────────────────────┤
│  L1  专业编排层                                              │
│  入口 SKILL.md + professions/ 四分册路由表                    │
│  umpp · umcommit · umrelease · umreview                     │
├─────────────────────────────────────────────────────────────┤
│  L2  流程规则层                                              │
│  um/references/ (~25 个细分文件)                              │
│  每文件 = 一个可独立委派子任务边界                              │
├─────────────────────────────────────────────────────────────┤
│  L3  环境工具层                                              │
│  um/adapters/{dsh,opencode,codex}/{tools,capabilities}.md   │
│  平台工具映射与能力档案，会话内读一次                            │
└─────────────────────────────────────────────────────────────┘
```

### 关键机制

- **环境路由** — 三阶成本递增：system prompt 特征 → 工具签名 → 询问 + 记忆
- **决策面板** — 一次多问 GUI 弹窗，版本选项智能适配（SemVer/CalVer）
- **波次迭代** — 步骤完整性优先，容量不足唯一降级 = 波切更细，绝不删步骤
- **Subagent 编排** — 决策树分派，只带自己链路的 reference
- **伞形单技能** — 统一顶层容器内唯一技能 `um`：canonical 即安装物，单一事实源零复制（[ADR-003](docs/adr/ADR-003-umbrella-single-skill.md)）
- **缓存稳定** — 指令文本零动态值，KV Cache 前缀稳定

> 📖 详见 [ARCHITECTURE.md](ARCHITECTURE.md) 了解完整架构设计。

---

## 📁 项目记忆

每个项目根目录可建 `.um.agents/`，用于持久化工程上下文：

```
.um.agents/
├── constraints/          入库（团队共享）
│   ├── hardcode-index.md 硬编码语义索引（升级版本不漏硬编码）
│   └── project-rules.md  项目规范
└── memory/               不 sync（*.local.md：环境识别/决策草稿/陷阱）
```

- `constraints/` — 团队共享，随版本入库
- `memory/` — 本地专属，不 sync（`.gitignore` 自包含）

---

## 📚 详细设计

| 文档 | 内容 |
|------|------|
| [ARCHITECTURE.md](ARCHITECTURE.md) | 四层架构、环境路由、决策面板、波次迭代、Token 账本、维护指南 |
| [CHANGELOG.md](CHANGELOG.md) | 版本变更记录 |
| [umpp/SKILL.md](skills/um/professions/umpp.md) |规划专业路由表 |
| [umcommit/SKILL.md](skills/um/professions/umcommit.md) | 提交专业路由表 |
| [umrelease/SKILL.md](skills/um/professions/umrelease.md) | 发布专业路由表 |
| [umreview/SKILL.md](skills/um/professions/umreview.md) | 审查专业路由表 |

---

## 🤝 支持项目

如果您觉得本项目对您有帮助，欢迎通过以下方式支持：

<p align="center">
  <a href="https://ko-fi.com/unforgetmemory">
    <img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="☕ 请我喝杯咖啡" width="240">
  </a>
</p>

<p align="center">
  <a href="https://ko-fi.com/unforgetmemory">
    <img src="https://img.shields.io/badge/donate-ko--fi-FF5E5B?style=for-the-badge&logo=ko-fi&logoColor=white" alt="Donate via Ko-fi">
  </a>
</p>

---

## 📄 许可证

本项目基于 [MIT](LICENSE) 许可证开源。

---

<div align="center">
  <sub>Built with ❤️ by <a href="https://github.com/unforgetmemory">unforgetmemory</a></sub>
</div>