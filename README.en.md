<div align="center">
  <img src="LOGO.png" alt="UM Skills Logo" width="320" height="320">

  # UM Skills — Engineering Skill Chain Library

  <p align="center">
    <strong>Multi-environment (DSH / OpenCode / Codex) routable engineering skill chain library</strong><br>
    Plan → Commit → Release, with Review insertable at any stage
  </p>

  <p align="center">
    <b>English</b> · <a href="README.md">简体中文</a>
  </p>

  <p align="center">
    <a href="LICENSE">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square" alt="MIT License">
    </a>
    <a href="https://github.com/unforgetmemory/um-skills">
      <img src="https://img.shields.io/badge/repo-um--skills-1a1a2e?style=flat-square&logo=github" alt="GitHub Repo">
    </a>
    <a href="https://ko-fi.com/unforgetmemory">
      <img src="https://img.shields.io/badge/☕%20ko--fi-Support%20Project-FF5E5B?style=flat-square" alt="Ko-fi">
    </a>
    <img src="https://img.shields.io/badge/status-stable-4ecdc4?style=flat-square" alt="Status: Stable">
    <img src="https://img.shields.io/badge/env-dsh%20%7C%20opencode%20%7C%20codex-45b7d1?style=flat-square" alt="Environments">
  </p>
</div>

---

## 📋 Table of Contents

- [✨ Introduction](#-introduction)
- [🚀 Quick Start](#-quick-start)
- [🧩 Skills Overview](#-skills-overview)
- [🏗️ Architecture](#️-architecture)
- [📁 Project Memory](#-project-memory)
- [📚 Detailed Design](#-detailed-design)
- [🤝 Support the Project](#-support-the-project)
- [📄 License](#-license)

---

## ✨ Introduction

**UM Skills** is an engineering skill chain library for AI Agents, covering the full software development lifecycle:

| Stage | Skill | Responsibility |
|-------|-------|----------------|
| Plan → | **umpp** | Structured investigation and architecture-first execution for complex multi-step tasks |
| Commit → | **umcommit** | CHANGELOG audit + Conventional Commit + atomic commit + push |
| Release → | **umrelease** | CI dry-run gate + professional Release Notes + SemVer/CalVer versioning |
| Review ↔ | **umreview** | MRI-style five-axis code review + security audit + test coverage + cleanup |

Together, they form a complete engineering pipeline, supporting **DSH** (DeepSeek Harness), **OpenCode**, and **Codex** AI Agent environments with automatic tool and capability routing.

> 💡 **Design Philosophy**: Software is a living organism, not a one-time modification. Abstraction emerges from real change (Evolution First). No layer absorbs the content of another; each subagent carries only its own chain's references.

---

## 🚀 Quick Start

### Deploy to DSH

```bash
# Deploy skills to DSH
cp -r core adapters umpp umcommit umrelease umreview ~/.dsh/skills/

# core/ and adapters/ have no SKILL.md, so they won't be registered as skills;
# they are only referenced via read by SKILLs that need them
```

### Deploy to OpenCode

```bash
# Deploy skills to OpenCode
cp -r core adapters umpp umcommit umrelease umreview ~/.opencode/skills/
```

### Usage

In any supported environment, speak the trigger words to your AI Agent to invoke the corresponding skill:

| Trigger | Effect |
|---------|--------|
| `umpp` | Start Planning: Problem Statement → Spec → TODO → Wave Execution → Verification |
| `umcommit` | Start Commit: CHANGELOG + audited commit + push (single decision panel) |
| `umrelease` | Start Release: CI dry-run gate → Release Notes → version tag → gh release |
| `umreview` | Start Review: MRI-style five-axis code review, no commit or push |

---

## 🧩 Skills Overview

| Skill | Domain | One-liner | Documentation |
|-------|--------|-----------|---------------|
| [**umpp**](umpp/SKILL.md) | 📐 Planning | Structured investigation and architecture-first execution for complex multi-step tasks | [Router](umpp/SKILL.md) |
| [**umcommit**](umcommit/SKILL.md) | ✅ Commit | CHANGELOG + audited commit + push (single decision panel, version-aware) | [Router](umcommit/SKILL.md) |
| [**umrelease**](umrelease/SKILL.md) | 🚀 Release | CI dry-run gate → Release Notes → SemVer/CalVer tag → gh release | [Router](umrelease/SKILL.md) |
| [**umreview**](umreview/SKILL.md) | 🔍 Review | MRI-style five-axis review + security/gitignore/test/cleanup, no commit or push | [Router](umreview/SKILL.md) |

### Skill Chain

```
umpp (Planning) ──→ umcommit (Commit) ──→ umrelease (Release)
       ↑ Review (umreview) insertable at any stage
```

---

## 🏗️ Architecture

The project uses a **four-layer architecture** for progressive disclosure and on-demand loading:

```
┌───────────────────────────────────────────────────────────────┐
│  L0  Base Constraints Layer                                   │
│  core/references/ (6 files)                                   │
│  Meta-constraints · Environment Routing · Context Adaptation  │
│  Decision Panel · Subagent Orchestration · Project Memory     │
├───────────────────────────────────────────────────────────────┤
│  L1  Skill Orchestration Layer                                │
│  4 SKILL.md = router tables (Phase → reference mapping)       │
│  umpp · umcommit · umrelease · umreview                      │
├───────────────────────────────────────────────────────────────┤
│  L2  Process Rules Layer                                      │
│  core/references/ (~25 granular files)                        │
│  Each file = one independently delegatable task boundary      │
├───────────────────────────────────────────────────────────────┤
│  L3  Environment Tool Layer                                   │
│  adapters/{dsh,opencode,codex}/{tools,capabilities}.md        │
│  Platform tool mappings and capability profiles               │
└───────────────────────────────────────────────────────────────┘
```

### Key Mechanisms

- **Environment Routing** — Three-tier cost-increasing: system prompt features → tool signatures → ask + persist
- **Decision Panel** — Multi-question GUI dialog in one pass, version options auto-adapt (SemVer/CalVer)
- **Wave Iteration** — Step completeness first; the only degradation when capacity is low is finer waves, never skipping steps
- **Subagent Orchestration** — Decision tree dispatch, each subagent carries only its own chain's references
- **Cache Stability** — Zero dynamic values in instruction text, stable KV Cache prefix

> 📖 See [ARCHITECTURE.md](ARCHITECTURE.md) for the complete architecture design.

---

## 📁 Project Memory

Each project root can have a `.um.agents/` directory for persisting engineering context:

```
.um.agents/
├── constraints/          Checked in (team shared)
│   ├── hardcode-index.md Hardcoded semantic index (never miss a version bump)
│   └── project-rules.md  Project-specific rules
└── memory/               Not synced (*.local.md: env detection, decision drafts, traps)
```

- `constraints/` — Team shared, committed with the project
- `memory/` — Local only, not synced (self-contained `.gitignore`)

---

## 📚 Detailed Design

| Document | Content |
|----------|---------|
| [ARCHITECTURE.md](ARCHITECTURE.md) | Four-layer architecture, environment routing, decision panel, wave iteration, token budget, maintenance guide |
| [CHANGELOG.md](CHANGELOG.md) | Version history |
| [umpp/SKILL.md](umpp/SKILL.md) | Planning skill router |
| [umcommit/SKILL.md](umcommit/SKILL.md) | Commit skill router |
| [umrelease/SKILL.md](umrelease/SKILL.md) | Release skill router |
| [umreview/SKILL.md](umreview/SKILL.md) | Review skill router |

---

## 🤝 Support the Project

If you find this project helpful, consider supporting it:

<p align="center">
  <a href="https://ko-fi.com/unforgetmemory">
    <img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="☕ Buy me a coffee" width="240">
  </a>
</p>

<p align="center">
  <a href="https://ko-fi.com/unforgetmemory">
    <img src="https://img.shields.io/badge/donate-ko--fi-FF5E5B?style=for-the-badge&logo=ko-fi&logoColor=white" alt="Donate via Ko-fi">
  </a>
</p>

---

## 📄 License

This project is open source under the [MIT](LICENSE) License.

---

<div align="center">
  <sub>Built with ❤️ by <a href="https://github.com/unforgetmemory">unforgetmemory</a></sub>
</div>