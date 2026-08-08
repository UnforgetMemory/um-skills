# 安全审计清单

调用 skill：`security-and-hardening`（完整规范以该 skill 为准，本文档为执行清单）

## 1. 敏感信息扫描（必做）

```bash
# 变更中泄露的密钥（staged + unstaged）
git diff | grep -iE "password|secret|api[_-]?key|token|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY"

# 常见密钥前缀（按项目技术栈调整）
git grep -nE "(AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{36}|AIza[0-9A-Za-z_-]{35})" -- ':!*.md' ':!*.lock'

# 被跟踪的 .env 类文件
git ls-files | grep -E "\.env($|\.)"
```

处理：以 `Fact` 标记位置 → 从工作区移除 → **提示人工更换密钥**（一旦进过远程必须轮换，删除历史不够）。

## 2. 信任边界与输入

- [ ] 所有外部输入在边界校验（API 路由、表单处理）
- [ ] SQL/NoSQL 参数化，禁止字符串拼接
- [ ] 输出编码防 XSS（不 bypass 框架自动转义）
- [ ] SSRF：服务端 fetch 用户可控 URL → 协议+主机白名单、禁私有/回环 IP、禁重定向
- [ ] 文件上传：类型/大小限制，不信任扩展名

## 3. 认证与授权

- [ ] 密码 bcrypt/scrypt/argon2（salt ≥ 12）
- [ ] Session cookie: `httpOnly` + `secure` + `sameSite`
- [ ] 登录端点限流
- [ ] 每个受保护端点检查权限（不止认证）
- [ ] 越权检查：用户只能访问自己的资源

## 4. 依赖与供应链

- [ ] `npm audit`（或等价工具）无 critical/high 可达漏洞；不可达/仅 dev 依赖 → 标注降级处理
- [ ] 锁文件已提交（CI 用 `npm ci` / 等价可复现安装）
- [ ] 新依赖审查：维护状态、下载量、postinstall 脚本、typosquat 风险

## 5. LLM/AI 表面（如适用）

- [ ] 模型输出视为不可信（不进 eval / SQL / innerHTML / shell）
- [ ] 密钥与跨租户数据不进 prompt
- [ ] 工具权限最小化，破坏性操作需确认
- [ ] 消费有上限（token / 频率 / 循环深度）

## 输出格式

```
[严重度] <文件>:<行> — <问题> — <建议修复>
```
严重度分 Critical / High / Medium / Low。Critical 与 High 必须修复或人工确认豁免，禁止静默跳过。
