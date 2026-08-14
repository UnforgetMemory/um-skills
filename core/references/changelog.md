# CHANGELOG 规范（Keep a Changelog）

## 1. 数据收集

```text
git log --oneline -20
git diff HEAD --stat
```

按 Conventional 类型分组，单独标出含 `!` 或 `BREAKING CHANGE:` footer 的破坏性条目。

## 2. 分类映射表

| 提交类型 | CHANGELOG 小节 |
|---|---|
| `feat` | `### Added` |
| `fix` | `### Fixed` |
| `refactor` / `perf` | `### Changed` |
| `docs` / `style` | `### Changed` 或省略（除非面向用户） |
| `test` | 省略（除非影响用户可见行为） |
| `chore` / `build` / `ci` | 省略 |
| BREAKING CHANGE（`!` 或 footer） | `### Breaking Changes` |

## 3. 条目写作规则

- 祈使句、简洁（`add ...` / `fix ...`）
- 不写内部 JIRA / Task ID（除非该编号公开）、邮箱、IP、主机名
- 不写密钥 / 敏感信息（按 [security-audit.md](security-audit.md) 扫描）
- 只写用户可见或契约级变化；内部重构合并为一行 `### Changed` 概括

## 4. 版本化发布流程

- **用户选择升级版本**：`## [Unreleased]` 下内容整体移动到 `## [目标版本] - YYYY-MM-DD`，再新建空的 `## [Unreleased]` 小节
- **用户不升级版本**：新条目追加到现有 `## [Unreleased]`，不新建版本标题
- **同步版本文件**：创建 `## [X.Y.Z]` 小节时，必须同步 bump 权威版本文件（如 `package.json` 的 `version` 字段），并先经用户确认（版本规则见 [version-detection.md](version-detection.md)）
- 版本号与版本文件保持一致；冲突时以版本检测规则为准

## 5. 输出模板

```markdown
## [Unreleased]

### Added
- <新功能条目>

### Fixed
- <修复条目>

### Changed
- <重构 / 性能条目>

## [1.1.0] - 2026-08-08

### Added
- <已发布的新功能条目>

### Breaking Changes
- <破坏性变更说明>
```

## 6. 安全检查

写入前按 [security-audit.md](security-audit.md) 执行敏感信息扫描。
