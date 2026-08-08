# Release Notes 安全审计（内部信息泄露阻断）

调用 skill：`security-and-hardening`（完整规范以该 skill 为准，本文档为 Release Notes 专用审计清单）

## 1. 审计范围

Release Notes 面向公众，**禁止出现任何内部实现细节**。以下扫描在 Release Notes 生成后、发布前执行。

## 2. 扫描命令

```bash
# 内部 API 端点路径（带 /api/ 或 /internal/ 的路径）
grep -iE "/api/v[0-9]+/(internal|private|admin|dev|staging|debug)" release-notes.md

# 内部 IP 地址
grep -E "[0-9]{1,3}(\.[0-9]{1,3}){3}" release-notes.md

# 密钥 / token / 密码
grep -iE "password|secret|api[_-]?key|token|client[_-]?secret|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY" release-notes.md
grep -E "AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{36}|AIza[0-9A-Za-z_-]{35}" release-notes.md

# 内部主机名
grep -iE "(localhost|127\.0\.0\.1|\.local|\.internal|\.dev|staging|sandbox)" release-notes.md

# 个人邮箱
grep -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" release-notes.md

# 内部实现引用（类名 / 函数名 / 模块路径 / 文件路径）
grep -iE "(src/|lib/|app/|internal/|core/|services/|repositories/|utils/|helpers/|components/|hooks/|stores/|plugins/|connectors/|providers/|engines/|scenarios/|pipelines/|operations/)" release-notes.md

# 数据库表名 / 字段引用
grep -iE "(table|database|schema|dao|repository|datasource|datastore|entity|model|migration)['\"]?:" release-notes.md

# 内部 PR / Issue 编号（私有仓库）
grep -E "#[0-9]{3,}" release-notes.md

# 内部 JIRA / Task ID
grep -iE "[A-Z]{2,6}-[0-9]{3,}" release-notes.md

# 配置文件路径
grep -iE "(\.env|config\.|application\.yml|application\.properties|settings\.json)" release-notes.md
```

## 3. 处置规则

| 严重度 | 定义 | 处置 |
|--------|------|------|
| Critical | 暴露密钥、密码、token | **Hard Block** — 移除并重扫 |
| High | 暴露内部 API 端点、内部 IP、内部主机、内部路径 | **Hard Block** — 改写为面向用户描述 |
| Medium | 暴露内部 Issue/PR 编号、JIRA ID | 替换为通用描述 |
| Low | 暴露内部文件名、类名 | 改写为面向用户描述 |

## 4. 输出格式

```
[严重度] <扫描项> — <原文> — <建议修复>
全部通过 → ✅ Release Notes 审计通过，可发布
存在阻断项 → ⛔ 审计未通过，禁止发布到 GitHub
```