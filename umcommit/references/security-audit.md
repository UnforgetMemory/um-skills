# CHANGELOG 与 Commit 安全审计

调用 skill：`security-and-hardening`（完整规范以该 skill 为准，本文档为执行清单）

## 1. CHANGELOG 审计（写入前）

对生成的 CHANGELOG 文本执行扫描：

```bash
grep -iE "password|secret|api[_-]?key|token|client[_-]?secret|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY" CHANGELOG.md
grep -E "AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{36}|AIza[0-9A-Za-z_-]{35}" CHANGELOG.md
grep -E "[0-9]{1,3}(\.[0-9]{1,3}){3}" CHANGELOG.md                          # internal IPs
grep -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" CHANGELOG.md        # personal emails
grep -E "https?://(localhost|127\.0\.0\.1|10\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[01])\.)" CHANGELOG.md
```

## 2. Commit 审计（提交前，Hard Block）

```bash
git diff --cached | grep -iE "password|secret|api[_-]?key|token|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY"
git grep -nE "(AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{36}|AIza[0-9A-Za-z_-]{35})" -- ':!*.lock' ':!*.sum' ':!*.md'
git ls-files --cached | grep -E "\.env($|\.)"          # staged env files
git diff --cached --stat | grep -iE "\.(pem|key|p12|pfx|jks)$"
```

## 3. 处置规则

- 任一 Critical / High 命中 → **Hard Block：禁止提交**，标记 `Fact` 并给出 `<文件>:<行>`
- 从暂存区移除相关文件；警告：密钥一旦进过远程必须轮换，删除历史不够
- 严重度标签：`Critical:` / `High` / `Medium` / `Low`
- Critical / High 必须解决或由人工明确豁免，禁止静默跳过

## 4. 输出格式

```
[严重度] <文件>:<行> — <问题> — <建议修复>
```

全部通过 → `✅ 审计通过，可提交`；存在阻断项 → `⛔ 审计未通过，禁止提交`
