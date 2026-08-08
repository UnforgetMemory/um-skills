# Release CI 门禁（Dry-Run）

调用 skill：`ci-cd-and-automation`（完整规范以该 skill 为准，本文档为 dry-run 执行清单）

## 1. 核心原则

**在创建 tag 或发布之前，必须完整运行一次 Release 构建与测试，且不执行任何发布操作。**

| 步骤 | 门禁 |
|------|------|
| 构建 | exit 0 + 产物存在 |
| 类型检查 | exit 0（如 `tsc --noEmit`） |
| 测试 | exit 0（全部测试通过） |
| 安全审计 | exit 0（`npm audit` 等） |
| 产物验证 | 产物文件实际存在于预期路径 |

## 2. 按项目栈的 dry-run 命令

### Node.js / TypeScript

```bash
# 构建
npm run build              # 或 npm run dist
# 验证产物
ls -la dist/               # 确保 dist/ 非空

# 类型检查
npx tsc --noEmit

# 测试
npm test

# 安全审计
npm audit --audit-level=high
```

### Rust

```bash
# 构建
cargo build --release
# 验证产物
ls -la target/release/<binary>

# 测试
cargo test

# 安全审计
cargo audit
```

### Python

```bash
# 构建
python -m build
# 验证产物
ls -la dist/*.tar.gz dist/*.whl

# 测试
pytest

# 类型检查
basedpyright .
```

### Kotlin / Android (Gradle)

```bash
# 构建 Release 产物
./gradlew assembleRelease

# 验证产物
ls -la app/build/outputs/apk/release/*.apk

# 测试
./gradlew testReleaseUnitTest

# lint
./gradlew lintRelease
```

### Go

```bash
# 构建
go build -o dist/ ./...

# 验证产物
ls -la dist/

# 测试
go test ./...

# vet
go vet ./...
```

## 3. 产物验证

不同语言的产物必须实际存在：

| 项目类型 | 典型产物路径 | 验证命令 |
|----------|-------------|----------|
| npm package | `dist/`、`lib/`、`build/` | `ls -la dist/` |
| Rust binary | `target/release/<name>` | `file target/release/<name>` |
| Python wheel | `dist/*.whl` | `ls -la dist/*.whl` |
| Android APK | `**/build/outputs/apk/release/*.apk` | `ls -la **/*.apk` |
| Go binary | `dist/` | `ls -la dist/` |

## 4. 失败重试

```bash
# 循环：构建失败 → 修复 → 重试（最多 3 次）；任何失败路径必须显式阻断
MAX_RETRIES=3
BUILD_OK=0
for i in $(seq 1 $MAX_RETRIES); do
  if npm run build; then
    BUILD_OK=1
    break
  fi
  echo "Build attempt $i failed. Fixing..."
  # 自动修复模式由主流程决定
  sleep 2
done
if [ "$BUILD_OK" -ne 1 ]; then
  echo "Build failed after $MAX_RETRIES attempts. Aborting — release is BLOCKED."
  exit 1
fi
```

## 5. 输出格式

```
## CI Dry-Run 结果
构建: ✅ (exit 0)
类型检查: ✅ (exit 0)
测试: ✅ (15/15 passed)
安全审计: ✅ (0 critical, 0 high)
产物: ✅ dist/app-v1.2.3.tar.gz (2.3MB)
状态: ✅ DRY-RUN PASSED — 可继续发布
```