# 安全审计（通用）

适用：CHANGELOG、Release Notes、Commit、任何对外输出 —— 写入/提交/发布前执行。

## 1. 敏感信息扫描（任意输出文本 <target>）

```text
grep -iE "password|secret|api[_-]?key|token|client[_-]?secret|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY" <target>
grep -E "AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{36}|AIza[0-9A-Za-z_-]{35}" <target>
grep -E "[0-9]{1,3}(\.[0-9]{1,3}){3}" <target>                              # internal IP
grep -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" <target>           # personal email
grep -iE "https?://(localhost|127\.0\.0\.1|10\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[01])\.)" <target>
grep -iE "/api/v[0-9]+/(internal|private|admin|dev|staging|debug)" <target> # internal API endpoint
grep -iE "(localhost|127\.0\.0\.1|\.local|\.internal|\.dev|staging|sandbox)" <target>  # internal hostname
grep -iE "(src/|lib/|app/|internal/|core/|services/|repositories/|utils/|helpers/|components/|hooks/|stores/|plugins/|connectors/|providers/|engines/|scenarios/|pipelines/|operations/)" <target>  # internal implementation refs
grep -iE "(table|database|schema|dao|repository|datasource|datastore|entity|model|migration)['\"]?:" <target>  # table/field names
grep -E "#[0-9]{3,}" <target>              # internal PR/issue numbers
grep -iE "[A-Z]{2,6}-[0-9]{3,}" <target>   # internal JIRA/task IDs
grep -iE "(\.env|config\.|application\.yml|application\.properties|settings\.json)" <target>  # config paths
```

## 2. Commit 审计（提交前，Hard Block）

```text
git diff --cached | grep -iE "password|secret|api[_-]?key|token|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY"
git grep -nE "(AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{36}|AIza[0-9A-Za-z_-]{35})" -- ':!*.lock' ':!*.sum' ':!*.md'
git ls-files --cached | grep -E "\.env($|\.)"          # staged env files
git diff --cached --stat | grep -iE "\.(pem|key|p12|pfx|jks)$"
```

## 3. 严重度与处置

| 严重度 | 定义 | 处置 |
|---|---|---|
| Critical | 暴露密钥、密码、token | **Hard Block** — 移除并重扫 |
| High | 内部 API 端点、内部 IP、内部主机、内部路径 | **Hard Block** — 改写为面向用户描述 |
| Medium | 内部 Issue/PR 编号、JIRA ID | 替换为通用描述 |
| Low | 内部文件名、类名 | 改写为面向用户描述 |

- 任一 Critical / High 命中 → **Hard Block：禁止提交/发布**，标记 `Fact` 并给出 `<文件>:<行>`
- Critical / High 必须解决或由人工明确豁免，禁止静默跳过
- 从暂存区移除相关文件；**密钥一旦进过远程必须轮换，删除历史不够**

## 4. 信任边界与输入（代码评审）

- [ ] 所有外部输入在边界校验（API 路由、表单处理）
- [ ] SQL/NoSQL 参数化，禁止字符串拼接
- [ ] 输出编码防 XSS（不 bypass 框架自动转义）
- [ ] SSRF：服务端 fetch 用户可控 URL → 协议+主机白名单、禁私有/回环 IP、禁重定向
- [ ] 文件上传：类型/大小限制，不信任扩展名
- [ ] 密码 bcrypt/scrypt/argon2（salt ≥ 12）
- [ ] Session cookie: `httpOnly` + `secure` + `sameSite`；登录端点限流
- [ ] 每个受保护端点检查权限；越权检查：用户只能访问自己的资源
- [ ] 依赖审计（npm audit 或等价）无 critical/high 可达漏洞；不可达/仅 dev → 标注降级处理
- [ ] 锁文件已提交（可复现安装）；新依赖审查：维护状态、postinstall 脚本、typosquat 风险
- [ ] LLM 输出视为不可信（不进 eval/SQL/innerHTML/shell）；密钥与跨租户数据不进 prompt；工具权限最小化；消费有上限

## 5. 输出格式

```text
[严重度] <文件>:<行> — <问题> — <建议修复>
全部通过 → ✅ 审计通过，可提交/发布
存在阻断项 → ⛔ 审计未通过，禁止提交/发布
```
