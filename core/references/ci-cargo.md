# CI Dry-Run：Rust

## 原则

**创建 tag 或发布之前，必须完整运行一次构建与测试，且不执行任何发布操作。** 门禁：exit 0 + 产物存在。

## 命令

```text
# build
cargo build --release
# verify artifacts
ls -la target/release/<binary>

# test
cargo test

# lint (optional but recommended)
cargo clippy -- -D warnings

# dependency audit (install first: cargo install cargo-audit)
cargo audit
```

## 产物验证

| 产物 | 验证 |
|---|---|
| Rust binary | `target/release/<name>` 实际存在（`file target/release/<name>`） |

## 失败处理

- 任一门禁失败 → 修复后重试（最多 3 次）；任何失败路径必须显式阻断发布
- 3 次仍失败 → 终止，release **BLOCKED**

## 输出格式

```text
## CI Dry-Run 结果
构建: ✅ (exit 0)
测试: ✅ (全部通过)
安全审计: ✅ (0 critical, 0 high)
产物: ✅ target/release/<binary> (x.x MB)
状态: ✅ DRY-RUN PASSED — 可继续发布
```
