# CI Dry-Run：Kotlin / Android (Gradle)

## 原则

**创建 tag 或发布之前，必须完整运行一次构建与测试，且不执行任何发布操作。** 门禁：exit 0 + 产物存在。

## 命令

```text
# build release artifacts
./gradlew assembleRelease

# verify artifacts
ls -la app/build/outputs/apk/release/*.apk

# test
./gradlew testReleaseUnitTest

# lint
./gradlew lintRelease

# vulnerability audit (OWASP plugin; when unconfigured, delegate to security-audit.md)
./gradlew dependencyCheckAnalyze    # if plugin not configured: skip and mark delegated
```

## 产物验证

| 产物 | 验证 |
|---|---|
| Android APK | `**/build/outputs/apk/release/*.apk` 实际存在 |

## 失败处理

- 任一门禁失败 → 修复后重试（最多 3 次）；任何失败路径必须显式阻断发布
- 3 次仍失败 → 终止，release **BLOCKED**

## 输出格式

```text
## CI Dry-Run 结果
构建: ✅ (exit 0)
测试: ✅ (全部通过)
lint: ✅ (exit 0)
安全审计: ✅ dependencyCheckAnalyze 0 漏洞（或委托 security-audit.md）
产物: ✅ app/build/outputs/apk/release/app-v1.2.3.apk (x.x MB)
状态: ✅ DRY-RUN PASSED — 可继续发布
```
