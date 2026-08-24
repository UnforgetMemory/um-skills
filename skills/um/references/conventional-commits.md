# Conventional Commits 与原子提交

## 1. 类型速查表

| 类型 | 用途 | 版本影响 |
|---|---|---|
| `feat` | 新功能 | MINOR |
| `fix` | 修复 bug | PATCH |
| `docs` | 仅文档 | PATCH |
| `refactor` | 重构，行为不变 | PATCH |
| `perf` | 性能优化 | PATCH |
| `test` | 测试增改 | PATCH |
| `build` | 构建系统 / 依赖 | PATCH |
| `ci` | CI/CD 配置 | PATCH |
| `chore` | 维护，无用户可见变化 | PATCH |
| `revert` | 回滚提交 | PATCH |

## 2. 格式

```text
<type>(<scope>): <description>

<body — 解释 WHY，按 72 字符换行>

<footer — BREAKING CHANGE: / Closes: #123 / Assisted-by: ...>
```

## 3. 原子拆分

- 变更 ≥ 3 个文件 → 拆成 ≥ 2 个提交，按模块 / 关注点拆分
- `min_commits = ceil(files/3)`
- 测试与实现成对提交
- 每个提交只含一个逻辑变更

## 4. 消息语言

- 先用 `git log -30` 检测仓库提交消息的语言分布
- 默认英文；仓库以中文提交为主 → 使用中文
- 祈使句、小写开头、句末无句号

## 5. 必带

- `git commit --signoff`
- AI 生成提交加 footer：`Assisted-by: <Model> via OpenCode`

## 6. 示例

```text
feat(auth): add OAuth2 login support

Implements Google OAuth2 sign-in flow with credential refresh.

Closes: #123
Assisted-by: GPT-5 via OpenCode
```

```text
git add <files>
git commit --signoff -F <commit-msg-file>
```

## 7. 安全检查

提交前按 [security-audit.md](security-audit.md) 执行 Commit 审计（Hard Block）。
