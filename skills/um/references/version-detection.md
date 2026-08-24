# 版本检测

## 1. 版本源优先级（按序检测，第一个命中即采用）

| 优先级 | 文件 | 字段/格式 | 提取 |
|---|---|---|---|
| 1 | `package.json` | `"version": "x.y.z"` | `grep -m1 '"version"' package.json \| sed -E 's/.*"version"[: ]*"([^"]+)".*/\1/'` |
| 2 | `pyproject.toml` | `[project]` `version = "x.y.z"` | `grep -m1 '^version' pyproject.toml \| sed -E 's/.*= *"([^"]+)".*/\1/'` |
| 3 | `Cargo.toml` | `[package]` `version = "x.y.z"` | `grep -m1 '^version' Cargo.toml \| sed -E 's/.*= *"([^"]+)".*/\1/'` |
| 4 | `build.gradle` / `build.gradle.kts` | `version = 'x.y.z'` | `grep -E '^version\s*=' build.gradle* \| head -1 \| sed -E "s/.*['\"]([^'\"]+)['\"].*/\\1/"` |
| 5 | `pubspec.yaml` | `version: x.y.z` | `grep -m1 '^version:' pubspec.yaml \| sed -E 's/.*: *([^ ]+).*/\1/'` |
| 6 | `VERSION`（裸文件） | `x.y.z` | `cat VERSION \| tr -d '\n'` |

- 多个版本文件同时命中 → **询问用户哪个是权威版本源**，禁止自行挑选

## 2. 提取后验证

- 提取结果必须匹配 `^[0-9]+\.[0-9]+\.[0-9]+`（先剥离 `-pre` / `+build` 再验证）
- 空值或无效值（如 workspace 继承的 `version.workspace = true`、Android 风格 `versionName`）→ **询问用户当前版本号**，禁止猜测或继续使用垃圾值

## 3. 风格解析

| 风格 | 判定 | 语义 |
|---|---|---|
| SemVer | `^\d+\.\d+\.\d+` | X.Y.Z；0.x.y 阶段 minor 可视为破坏性 |
| CalVer | `^\d{4}\.\d{2}\.\d{2}` | 日期推进版本 |
| 自定义 | 其他格式 | **询问用户规则**，禁止臆断 |

- 参与算术前剥离预发布 / 构建元数据（`-beta.1`、`+build`）

## 4. 无版本源时的智能判断

- 库 / 可发布项目（有对外 API、包结构）→ **询问用户是否建立版本化**，建议从 `0.1.0` 起步
- 纯脚本 / 内部工具 → 默认不版本化，仅维护 `[Unreleased]`

## 5. 输出格式

```text
当前版本: 0.0.0 → 目标版本: 0.1.0（minor）→ 是否写入？(y/n)
```
