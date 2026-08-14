# CI Dry-Run：Node.js / TypeScript

## 原则

**创建 tag 或发布之前，必须完整运行一次构建与测试，且不执行任何发布操作。** 门禁：exit 0 + 产物存在。

## 命令

```text
# build
npm run build              # or npm run dist
# verify artifacts
ls -la dist/               # ensure dist/ is not empty

# type-check
npx tsc --noEmit

# test
npm test

# security audit
npm audit --audit-level=high

# dry-run pack (optional; verify npm artifact contents)
npm pack --dry-run
```

## 产物验证

| 产物 | 验证 |
|---|---|
| npm package | `dist/`、`lib/`、`build/` 实际存在且非空；`npm pack --dry-run` 列出的 tarball 内容正确 |

## 失败处理

- 任一门禁失败 → 修复后重试（最多 3 次）；任何失败路径必须显式阻断发布
- 3 次仍失败 → 终止，release **BLOCKED**

## 输出格式

```text
## CI Dry-Run 结果
构建: ✅ (exit 0)
类型检查: ✅ (exit 0)
测试: ✅ (15/15 passed)
安全审计: ✅ (0 critical, 0 high)
产物: ✅ dist/ 非空 (app.bundle.js 2.3MB)；npm pack --dry-run 内容正确
状态: ✅ DRY-RUN PASSED — 可继续发布
```
