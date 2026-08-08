# 版本检测与 SemVer 升级规则

## 1. 检测文件与优先级

按序检测，第一个命中即采用；多个文件同时命中 → 询问用户哪个是权威版本源。

| 优先级 | 文件 | 字段/格式 | 提取命令 |
|---|---|---|---|
| 1 | `package.json` | `"version": "x.y.z"` | `grep -m1 '"version"' package.json \| sed -E 's/.*"version"[: ]*"([^"]+)".*/\1/'` |
| 2 | `pyproject.toml` | `[project]` `version = "x.y.z"` | `grep -m1 '^version' pyproject.toml \| sed -E 's/.*= *"([^"]+)".*/\1/'` |
| 3 | `Cargo.toml` | `[package]` `version = "x.y.z"` | `grep -m1 '^version' Cargo.toml \| sed -E 's/.*= *"([^"]+)".*/\1/'` |
| 4 | `build.gradle` / `build.gradle.kts` | `version = 'x.y.z'` | `grep -E '^version\s*=' build.gradle* \| head -1 \| sed -E "s/.*['\"]([^'\"]+)['\"].*/\\1/"` |
| 5 | `pubspec.yaml` | `version: x.y.z` | `grep -m1 '^version:' pubspec.yaml \| sed -E 's/.*: *([^ ]+).*/\1/'` |
| 6 | `VERSION` (bare file) | `x.y.z` | `cat VERSION \| tr -d '\n'` |

## 2. 提取后验证

- 提取结果必须匹配 `^[0-9]+\.[0-9]+\.[0-9]+`（先剥离 `-pre` / `+build` 再验证）
- 空值或无效值（如 workspace 继承的 `version.workspace = true`、Android 风格 `versionName`）→ **询问用户当前版本号**，禁止猜测或继续使用垃圾值
- 多个版本文件同时命中 → 询问用户哪个是权威版本源（与 §1 一致）

## 3. 解析与规范化

- 参与算术前剥离预发布 / 构建元数据（`-beta.1`、`+build`）
- SemVer 2.0 下 `0.x.y` 阶段 minor 可视为破坏性

## 4. 升级规则（SemVer 2.0）

当前版本 `X.Y.Z`：

| 选项 | 含义 | 计算 | 0.0.0 示例 |
|---|---|---|---|
| major | 破坏性变更 | `(X+1).0.0` | `1.0.0` |
| minor | 向后兼容新功能 | `X.(Y+1).0` | `0.1.0` |
| patch | bug 修复 | `X.Y.(Z+1)` | `0.0.1` |
| skip | 不升级版本，仅更新 [Unreleased] | 保持 | `0.0.0` |

## 5. 写入策略（推荐）

- 同一提交内同时 bump 版本文件字段与 CHANGELOG，提交消息用 `feat: ...` 或 `chore(release): bump to X.Y.Z`
- 版本元数据是 Single Source of Truth：CHANGELOG 声称 `[1.1.0]` 而 `package.json` 仍是 `0.0.0` 就是谎言
- 用户拒绝写入版本文件 → 在报告中显式标注该不一致

## 6. 输出格式

```
当前版本: 0.0.0 → 目标版本: 0.1.0（minor）→ 是否写入？(y/n)
```
