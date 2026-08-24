# Release Notes 结构

## 结构（专业、英文、简洁）

```markdown
## Summary

One- or two-sentence overview of what this release delivers. Focus on user-visible value.

## Highlights

- Major feature A: brief description
- Performance improvement B: impact metric
- Bug fix C: what was fixed and why it matters

## Breaking Changes

List any breaking changes with migration notes. If none, state "None in this release."

## Known Issues

Any known issues in this release. If none, omit this section.

## Upgrade Guide

Any special steps required to upgrade. If standard deployment applies, state "Standard deployment process applies."
```

## 禁止内容（面向公众，禁止内部实现细节）

- 内部 API 端点路径（`/api/v1/internal/...`）
- 内部 IP / 主机名
- 密钥 / token / 密码
- 内部实现的类名、函数名、模块路径
- 内部代码仓库引用
- 内部 Issue / PR 编号（除非公开）
- 内部 JIRA 或 Task ID
- 内部人员邮箱
- 数据库表名、字段名
- 配置文件路径

## 安全检查

发布前按 [security-audit.md](security-audit.md) 执行扫描；存在阻断项 → 禁止发布到 GitHub。
