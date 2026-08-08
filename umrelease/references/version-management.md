# 版本检测与 Release Tag 生成

## 1. 版本源检测

按序检测，第一个命中即采用；多个文件同时命中 → 询问用户哪个是权威版本源。

| 优先级 | 文件 | 字段/格式 | 提取命令 |
|--------|------|-----------|----------|
| 1 | `package.json` | `"version": "x.y.z"` | `grep -m1 '"version"' package.json \| sed -E 's/.*"version"[: ]*"([^"]+)".*/\1/'` |
| 2 | `pyproject.toml` | `[project]` `version = "x.y.z"` | `grep -m1 '^version' pyproject.toml \| sed -E 's/.*= *"([^"]+)".*/\1/'` |
| 3 | `Cargo.toml` | `[package]` `version = "x.y.z"` | `grep -m1 '^version' Cargo.toml \| sed -E 's/.*= *"([^"]+)".*/\1/'` |
| 4 | `build.gradle.kts` / `build.gradle` | `version = "x.y.z"` | `grep -E '^version\s*=' build.gradle* \| head -1 \| sed -E "s/.*['\"]([^'\"]+)['\"].*/\\1/"` |
| 5 | `pubspec.yaml` | `version: x.y.z` | `grep -m1 '^version:' pubspec.yaml \| sed -E 's/.*: *([^ ]+).*/\1/'` |
| 6 | `VERSION` (bare file) | `x.y.z` | `cat VERSION \| tr -d '\n'` |
| 7 | 最近 git tag | `vX.Y.Z` | `git describe --tags --abbrev=0 2>/dev/null \| sed 's/^v//'` |

## 2. 提取后验证

- 提取结果必须匹配 `^[0-9]+\.[0-9]+\.[0-9]+`（先剥离预发布/构建元数据）
- 空值或无效值 → **询问用户当前版本号**，禁止猜测
- 版本文件同时存在多个 → 询问用户哪个是权威源

## 3. Tag 生成规则

| 升级类型 | 规则 | 示例 |
|----------|------|------|
| major | `(X+1).0.0` | `1.0.0` → `2.0.0` |
| minor | `X.(Y+1).0` | `1.0.0` → `1.1.0` |
| patch | `X.Y.(Z+1)` | `1.0.0` → `1.0.1` |
| 沿用 | 不变 | 保持 `X.Y.Z` |

Tag 格式：`v${VERSION}`（如 `v1.2.3`）

## 4. 预发布 / 构建元数据

```bash
# 剥离预发布后缀
VERSION=$(echo "${VERSION}" | sed 's/-.*//')

# 添加预发布标记到 tag
TAG="v${VERSION}-beta.1"
```

## 5. 输出格式

```
当前版本: 1.0.0
目标版本: 1.1.0 (minor)
Tag: v1.1.0
```