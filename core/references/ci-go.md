# CI Dry-Run：Go

## 原则

**创建 tag 或发布之前，必须完整运行一次构建与测试，且不执行任何发布操作。** 门禁：exit 0 + 产物存在。

## 命令

```text
# build main packages only; skip artifact gate for library-only modules
mkdir -p dist
go build -o dist/ ./cmd/...        # or use the project's actual main package paths

# verify artifacts (main-package modules only)
ls -la dist/

# test
go test ./...

# vet
go vet ./...

# vulnerability audit
govulncheck ./...
```

## 产物验证

| 模块类型 | 产物 | 验证 |
|---|---|---|
| 含 main 包 | Go binary | `dist/` 实际存在且非空 |
| 纯库模块 | 无二进制 | 产物门禁跳过（以测试+审计为准） |

## 失败处理

- 任一门禁失败 → 修复后重试（最多 3 次）；任何失败路径必须显式阻断发布
- 3 次仍失败 → 终止，release **BLOCKED**

## 输出格式

```text
## CI Dry-Run 结果
构建: ✅ (exit 0)
测试: ✅ (全部通过)
vet: ✅ (exit 0)
安全审计: ✅ govulncheck 0 漏洞
产物: ✅ dist/<binary> (x.x MB)   # library-only modules: not applicable
状态: ✅ DRY-RUN PASSED — 可继续发布
```
