---
name: umrelease
description: >-
  Automates a professional GitHub Release for the current project version:
  auto-invokes changelog-automation, conventional-commits, ci-cd-and-automation,
  shipping-and-launch, and security-and-hardening to first run the release CI
  build + test WITHOUT publishing (dry-run gate) until it succeeds, then create
  the git tag and publish the release via the `gh` CLI. Release notes are
  professional, concise English and never expose internal interfaces or
  implementation details. Use when the user says "umrelease",
  "ok 现在进行自动调用相关SKILL,使用gh 进行专业的Release发布当前项目版本", or
  asks to release/publish the current project version with gh. NEVER publishes
  until the CI dry-run gate passes; release notes are always shown for manual
  review before publishing.
domain: software-engineering
subdomain: release
tags:
  - release
  - gh
  - github
  - ci
  - versioning
  - changelog
version: 1.0.0
author: UnforgetMemory
---

# umrelease — 专业 Release 发布 · CI 门禁验证 · gh CLI

```
talk-with-chinese;
using-superpowers;
```

## 核心定位
一次调用完成发布：自动加载 `changelog-automation` / `conventional-commits` / `ci-cd-and-automation` / `shipping-and-launch` / `security-and-hardening` → **先跑 Release CI 编译+测试（dry-run，不发布）直到成功** → 生成专业简洁的英文 Release Notes（不暴露内部接口/实现细节）→ 创建 git tag → 用 `gh` 发布。**CI dry-run 未通过禁止发布；Release Notes 发布前必须展示人工审查。**

## 触发方式
- 显式：`umrelease` / 上述中文长句 / "release" / "发布当前项目版本"
- 自动激活：同时出现「发布 / release + gh / 当前版本」意图

## 硬性纪律（不可协商）
| # | 规则 | 原因 |
|---|------|------|
| 1 | **CI dry-run 门禁未通过 → 禁止创建 tag / 发布** | 未验证的产物不能发布 |
| 2 | **Release Notes 发布前必须展示并确认** | 禁止未经人工审查的自动发布 |
| 3 | **禁止在 Release Notes 中暴露内部接口 / 实现细节** | 面向公众，只写用户可见变化 |
| 4 | 每个结论标记 `Fact` / `Assumption` / `Decision` | 禁止猜测 |
| 5 | Release Notes 必须专业、简洁、英文 | 面向公众的发布文案规范 |
| 6 | 禁止修改无关模块 / 代码 | umrelease 只做发布编排，不改业务代码 |

## 执行管线（Phase 0–8）

- **Phase 0 — 版本与变更范围采集**: 检测版本源（[version-management.md](references/version-management.md)）→ 读取当前版本 → 列出待发布变动（`git log --oneline $(git describe --tags --abbrev=0 2>/dev/null)..HEAD` + CHANGELOG）→ 验证 `gh` CLI 可用（`gh --version`）
- **Phase 1 — CI dry-run 门禁（调用 ci-cd-and-automation）**: 运行 Release 构建与测试，**不发布**（[ci-dry-run.md](references/ci-dry-run.md)）。命令：`npm run build` / `npm test` / `cargo build --release && cargo test` / `./gradlew assembleRelease` 等（按项目栈）。**任一失败 → 修复后重跑直到全绿**。产物必须实际生成（`dist/`、`build/`、binary 等）并验证
- **Phase 2 — Release Notes 生成（调用 changelog-automation + conventional-commits）**: 基于 git log 分类映射 + CHANGELOG `[X.Y.Z]`/`[Unreleased]` 生成专业、简洁、英文的 Release Notes（专业发布结构：Summary / Highlights / Breaking Changes / 等）
- **Phase 3 — Release Notes 安全审计（调用 security-and-hardening）**: 对 Notes 文本运行内部信息泄露扫描（[security-audit.md](references/security-audit.md)）——内部接口、路由、实现细节、密钥、内部主机/IP、邮箱、API 端点路径。**命中 → 改写/移除 → 重扫 → 仍命中 Critical/High → 停止**
- **Phase 4 — 版本升级确认（交互问题 Q1）**: 展示当前版本 + 检测到的待发布变动 → 确认发布版本（major/minor/patch，或沿用现有版本号）
- **Phase 5 — 创建 git tag**: 按 SemVer 创建对应 tag（`vX.Y.Z`），指向目标 commit / HEAD
- **Phase 6 — Notes 展示与发布确认（交互问题 Q2）**: 展示完整 Release Notes + tag + 目标 commit → `确认发布该 Release？(y/n)`；n → 停在已打 tag 未发布状态
- **Phase 7 — 发布（调用 gh CLI）**: `gh release create <tag> --title "<Title>" --notes-file <notes> [--target <branch>] [--prerelease] [--draft] <assets...>` → 若项目有产物需上传则一并附上
- **Phase 8 — 验证发布**: `gh release view <tag>` / `gh release list` 确认 Release 可见、tag 存在、资产已上传

## 交互问题（顺序固定）
1. **Q1（Phase 4，版本确认）**: `当前版本 X.Y.Z。确认发布为 vX.Y.Z？(major / minor / patch / 沿用现有)` → 展示目标 tag → 确认
2. **Q2（Phase 6，发布确认）**: 展示 Release Notes + tag + 目标 commit →
   `确认创建并发布该 Release？(y=发布 / n=仅打 tag 不发布 / 修改 Notes)`

## 验证门禁（逐级通过）
1. Phase 1：CI dry-run 全绿（构建 exit 0 + 测试通过 + 产物实际存在）
2. Phase 3：Notes 扫描零 Critical/High（无内部接口/实现细节泄露）
3. Phase 5：tag 创建成功（`git tag` 可见，`git tag --points-at HEAD` 正确）
4. Phase 7：`gh release create` exit 0
5. Phase 8：`gh release view <tag>` 确认 Release + 资产存在

## 输出报告（必交）
```
## umrelease 报告
### 版本与变更范围
### CI dry-run 证据（构建/测试输出，产物清单）
### Release Notes（全文）
### 安全审计证据（扫描输出，Critical/High = 0）
### 创建的 tag（hash + tag）
### 发布状态（gh release view 输出）
### ⚠️ 状态: RELEASED / TAG_ONLY (NOT PUBLISHED) / BLOCKED
```

## 参考文档
| 文档 | 内容 |
|------|------|
| [references/release.md](references/release.md) | gh release create 工作流（tag、notes、asset、draft→publish） |
| [references/ci-dry-run.md](references/ci-dry-run.md) | Release CI 编译/测试门禁（不发布）与产物验证 |
| [references/security-audit.md](references/security-audit.md) | Release Notes 内部信息泄露审计与阻断规则 |
| [references/version-management.md](references/version-management.md) | 版本源检测与 SemVer tag 生成 |