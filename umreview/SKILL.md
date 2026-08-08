---
name: umreview
description: >-
  Automates a pre-merge code review and hygiene pipeline: multi-axis code
  review, necessary concise English comments, security audit, comprehensive
  .gitignore coverage (directory-level preferred), required test coverage,
  and cleanup of outdated tests / leftover test processes / build artifacts.
  Use when the user says "umreview", "review and cleanup", "审查并清理",
  "pre-merge review", or asks for code review + security audit + gitignore
  coverage + test coverage + artifact cleanup in one pass. NEVER auto-commits
  or pushes — every change is left uncommitted for manual review.
domain: software-engineering
subdomain: code-review
tags:
  - review
  - security
  - hygiene
  - gitignore
  - testing
---

# umreview — 自动化审查与代码卫生编排

```
talk-with-chinese;
using-superpowers;
```

## 核心定位

一次调用，完成提交前全面体检。Review 信条：**寻找失败路径，而非确认成功路径**。

管线：codereview → 英文注释 → 安全审计 → gitignore 覆盖 → 测试覆盖 → 清洁。
全程 **不提交、不推送**，所有变更留给人工审查。

## 触发方式

- 显式：用户说 `umreview` / `review and cleanup` / `审查并清理` / `pre-merge review`
- 自动激活：用户提出以下任一组合意图：
  - 代码审查 / 质量检查
  - 安全审计 / 敏感信息扫描
  - gitignore 补全 / 忽略规则覆盖
  - 测试覆盖检查 / 补测试
  - 清理过期测试 / 测试进程 / 构建产物

## 硬性纪律（不可协商）

| # | 规则 | 原因 |
|---|------|------|
| 1 | **禁止自动 git commit / push / release** | 所有变更必须人工审查后落地 |
| 2 | 禁止删除未经确认的测试 | 过期测试先列清单，人工确认后才删 |
| 3 | 禁止修改无关模块 | 只处理审查发现的真实问题 |
| 4 | 每个结论标记 `Fact` / `Assumption` / `Decision` | 禁止猜测，数据驱动 |
| 5 | 注释必须为简洁英文 | 统一代码库语言，说明 WHY 不重复 WHAT |

## 执行管线（Phase 0–6）

### Phase 0 — 变更范围界定

1. `git status` + `git diff`（工作区 + 暂存区，**不执行任何 commit**）
2. 确定审查基准（最近 commit / 指定分支），列出 changed files 清单
3. 确认每个变更文件的意图（该变更要解决什么问题）

### Phase 1 — Code Review（调用 `code-review-and-quality`）

- 五轴审查：Correctness / Readability / Architecture / Security / Performance
- 所有发现带严重度标签：`Critical:`（阻断合并）/ 无前缀（必须改）/ `Nit:`（可选）/ `Optional:`（建议）/ `FYI`（信息）
- 先审测试，再审实现；每个变更文件输出发现清单
- 详细清单见 [references/code-review.md](references/code-review.md)

### Phase 2 — 简洁英文注释

- 只为**非显然**逻辑补充注释：解释 WHY（决策原因、边界条件、陷阱），不重复 WHAT
- 注释语言：**英文**；风格：一行或极短块
- 禁止：噪音注释、明显代码的注释、中文注释、被注释掉的死代码
- 规范见 [references/comments.md](references/comments.md)

### Phase 3 — 安全审计（调用 `security-and-hardening`）

- 敏感信息扫描（必做）：

  ```bash
  git diff | grep -iE "password|secret|api[_-]?key|token|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY"
  git grep -nE "(AKIA|sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{36}|AIza)" -- ':!*.md' ':!*.lock'
  ```

- 信任边界 / 输入校验 / 注入 / SSRF / 越权 / 依赖审计（`npm audit` 等）
- 清单见 [references/security-audit.md](references/security-audit.md)

### Phase 4 — gitignore 全面覆盖审计（调用 `gitignore-generator`）

- 扫描**非源代码产物**：构建输出、缓存、环境变量文件、IDE 目录、OS 文件、本地数据
- 规则优先级：**目录级别优先**（`build/` `dist/` `node_modules/` `.cache/`），文件级仅当无法目录化（如 `.env`）
- 验证：`git status --ignored` + `git check-ignore -v <path>`
- 清单见 [references/gitignore-audit.md](references/gitignore-audit.md)

### Phase 5 — 必要测试覆盖

- 对照 Phase 1 的变更清单，评估每个行为变更的测试覆盖
- 缺失关键用例 → 补测试（RED→GREEN 记录断言证据）
- 运行完整测试套件，确认全绿
- 规范见 [references/test-coverage.md](references/test-coverage.md)

### Phase 6 — 过期测试 / 测试进程 / 产物清洁

- 过期测试：针对已删除/废弃代码的测试 → **先列出清单** → 人工确认 → 删除
- 测试进程：遗留 watcher / dev server / 测试监听 → 确认归属后 kill
- 产物：构建产物、临时文件、测试缓存（与 Phase 4 的 gitignore 配合）
- 规范见 [references/cleanup.md](references/cleanup.md)

## 验证门禁（逐级通过）

1. 每个编辑后：修改文件 `lsp_diagnostics` clean
2. Phase 5 完成后：测试套件全绿（记录新增测试 RED→GREEN 输出）
3. Phase 4 完成后：`git check-ignore` 确认所有非源代码产物被忽略
4. 终态：`git status` 显示全部变更**未提交**，等待人工审查

## 输出报告（必交）

```
## umreview 报告
### 变更范围
### 审查发现（按严重度分组）
### 新增/修改内容（注释、测试、gitignore）
### 清洁项（删除的过期测试、终止的进程、清理的产物）
### 验证证据（测试输出、check-ignore 结果）
### ⚠️ 状态: NOT COMMITTED — 全部变更等待人工审查
```

## 参考文档

| 文档 | 内容 |
|------|------|
| [references/code-review.md](references/code-review.md) | 五轴审查清单与严重度规则 |
| [references/comments.md](references/comments.md) | 简洁英文注释规范 |
| [references/security-audit.md](references/security-audit.md) | 安全审计清单与扫描命令 |
| [references/gitignore-audit.md](references/gitignore-audit.md) | gitignore 覆盖审计与验证命令 |
| [references/test-coverage.md](references/test-coverage.md) | 测试覆盖评估与补测流程 |
| [references/cleanup.md](references/cleanup.md) | 过期测试/进程/产物清洁规范 |
