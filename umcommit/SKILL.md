---
name: umcommit
description: >-
  Automates the release pipeline: auto-invokes changelog-automation,
  conventional-commits, and security-and-hardening to update the CHANGELOG
  (Keep a Changelog) with a security audit, build security-audited
  conventional commit messages, commit, and push — always with explicit
  human confirmation. Asks before every push (yes/no) and before any
  version bump (major/minor/patch with a computed target version) when a
  version file is detected. Use when the user says "umcommit",
  "自动调用相关SKILL 编写 CHANGELOG 提交推送", or "ok 现在进行自动调用相关SKILL,
  编写相关 CHANGELOG（经过安全审计）/ commit（经过安全审计） 提交和推送",
  or asks to write a CHANGELOG and commit & push. NEVER pushes without an
  explicit yes; commit content is always shown for manual review first.
domain: software-engineering
subdomain: version-control
tags:
  - changelog
  - conventional-commits
  - security
  - release
  - git
  - push
version: 1.0.0
author: UnforgetMemory
---

# umcommit — 自动化 CHANGELOG · 审计提交 · 安全推送

```
talk-with-chinese;
using-superpowers;
```

## 核心定位
一次调用完成发布：自动加载 changelog-automation / conventional-commits / security-and-hardening → 编写 CHANGELOG（安全审计）→ 生成提交消息（安全审计）→ commit → 询问后 push。**Commit 内容先展示确认；Push 必须显式允许。**

## 触发方式
- 显式：`umcommit` / 上述中文长句
- 自动激活：同时出现「写 CHANGELOG + 提交 + 推送」意图，或出现以下任一组合：
  - changelog 更新 / 版本号升级
  - 提交 / commit / 推送 / push
  - 发布 / release

## 硬性纪律（不可协商）
| # | 规则 | 原因 |
|---|------|------|
| 1 | **禁止未经确认的 git push** | 用户配置文件明确禁止自动推送 |
| 2 | **Commit 前必须展示内容并确认** | 禁止未经人工审查的自动提交 |
| 3 | 禁止修改无关模块 | 只提交本次变更范围 |
| 4 | 每个结论标记 Fact / Assumption / Decision | 禁止猜测 |
| 5 | 安全审计未通过（Critical/High）禁止提交 | 防泄露 |

## 执行管线（Phase 0–8）
- **Phase 0 — 变更范围与风格采集**: `git status` + `git diff` + `git diff --cached --stat`；`git log --oneline -30` 识别提交风格/语言；列出 changed files 清单并标记 staged/unstaged
- **Phase 1 — 提交规划（调用 git-master）**: 按模块/关注点拆分原子提交组（≥3 文件 → ≥2 commit）；输出 COMMIT PLAN 表格：组 / 文件 / 消息 / 依赖顺序
- **Phase 2 — 版本检测与升级询问（交互问题 Q2）**: 检测版本文件（[version-management.md](references/version-management.md) 优先级表）；无版本文件 → 跳过 Q2，CHANGELOG 走 [Unreleased]；有 → 读取当前版本 → 提问 Q2 → 计算 target → 展示 → 确认
- **Phase 3 — CHANGELOG 编写（调用 changelog-automation）**: 基于 git log 分类映射生成条目（[changelog.md](references/changelog.md)）；确认升级 → 版本化发布流程；否则 append [Unreleased]
- **Phase 4 — CHANGELOG 安全审计（调用 security-and-hardening）**: 对生成的 CHANGELOG 文本跑扫描（[security-audit.md](references/security-audit.md)）；命中 → 移除/改写 → 重扫 → 仍命中 Critical/High → 停
- **Phase 5 — 提交消息生成（调用 conventional-commits）**: 每个原子组生成 conventional 消息（含 --signoff、AI 归属 footer）；展示完整 commit 计划（文件 + 消息）→ 交互确认 Q-Confirm
- **Phase 6 — 暂存与提交审计**: 逐个原子组执行 `git add <files>` → `git diff --cached` 扫描 + `git grep --cached` 扫描 + 消息文本扫描（[security-audit.md](references/security-audit.md)）；Critical/High = Hard Block（人工明确豁免除外）；通过后进入 Phase 7。**审计必须在 add 之后、commit 之前，否则暂存区为空导致扫描空洞**
- **Phase 7 — 执行提交**: `git commit --signoff -F <commit-msg-file>`；每组后 `git log -1 --oneline` 验证
- **Phase 8 — 推送决策（交互问题 Q1）**: Q1=否 → 停在 commit，输出报告标注 NOT PUSHED；Q1=是 → 展示待推送 commits → 最终确认 → `git push`（或 `-u origin <branch>`）→ 验证 `git status`

## 交互问题（顺序固定）
1. **Q2（Phase 2，版本升级）**: 检测到版本文件后提问 —
   `当前版本 0.0.0。本次升级类型？A) major (1.0.0, 破坏性) B) minor (0.1.0, 向后兼容新功能) C) patch (0.0.1, 修复) D) skip（不升级，仅 [Unreleased]）`
   用户选择后展示 `目标版本: 0.1.0 → 确认写入版本文件与 CHANGELOG？(y/n)`
2. **Q-Confirm（Phase 5，提交确认）**: 展示 COMMIT PLAN + 完整消息 →
   `确认提交以上 N 个 commit？(y/n / 修改意见)`
3. **Q1（Phase 8，推送确认）**: commit 成功且工作区干净后 →
   `是否允许推送？(y=push / n=仅本地提交)`；若 y → 展示 commits 后再次 `确认推送 N 个 commit？(y/n)`

## 验证门禁（逐级通过）
1. Phase 4：CHANGELOG 扫描零 Critical/High
2. Phase 6：暂存区 + 消息扫描零 Critical/High
3. Phase 7 每组后：`git log -1 --oneline` 确认
4. Phase 8 后：`git status` 干净；`git log -5 --oneline` 显示新提交
5. 终态：无未确认的 push 发生

## 输出报告（必交）
```
## umcommit 报告
### 变更范围
### 提交计划（原子组 + 消息）
### CHANGELOG 更新（[X.Y.Z] / [Unreleased]）
### 安全审计证据（扫描输出，Critical/High = 0）
### 已提交 commits（hash + message）
### ⚠️ 状态: COMMITTED (NOT PUSHED) / PUSHED
```

## 参考文档
| 文档 | 内容 |
|------|------|
| [references/changelog.md](references/changelog.md) | Keep a Changelog 分类映射与版本化发布流程 |
| [references/commit.md](references/commit.md) | Conventional Commits 与原子拆分规范 |
| [references/version-management.md](references/version-management.md) | 版本文件检测、SemVer 升级规则 |
| [references/security-audit.md](references/security-audit.md) | CHANGELOG 与 Commit 安全审计扫描与阻断规则 |
