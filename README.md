# um-skills

Agent skills for OpenCode — engineering workflows, architecture patterns, project management.

## Skills

| Skill | Description |
|-------|-------------|
| [umpp](umpp/SKILL.md) | Team-mode ULW — Software Evolution Engineering for long-lived multiplatform projects (KMP, Compose Multiplatform, Provider ecosystem). Phase 0–5 task execution, Store/Scenario/Provider/Engine architecture, ADR, SSoT. |
| [umreview](umreview/SKILL.md) | Automated pre-merge review & hygiene pipeline: multi-axis code review, concise English comments, security audit, comprehensive .gitignore coverage (directory-level preferred), required test coverage, and cleanup of outdated tests / leftover processes / artifacts. Never auto-commits or pushes. |
| [umcommit](umcommit/SKILL.md) | Automated release pipeline: writes a security-audited CHANGELOG (Keep a Changelog), builds audited conventional commits, commits, and pushes only after explicit approval — with mandatory version detection and major/minor/patch upgrade confirmation. |

## Usage

Skills auto-activate when their trigger keywords appear in conversation. Alternatively, load explicitly:

```
/umpp
```

Each skill ships with reference docs under its `references/` directory.

## License

MIT
