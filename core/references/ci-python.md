# CI Dry-Run：Python

## 原则

**创建 tag 或发布之前，必须完整运行一次构建与测试，且不执行任何发布操作。** 门禁：exit 0 + 产物存在。

## 命令

```text
# build
python -m build
# verify artifacts
ls -la dist/*.tar.gz dist/*.whl

# test
pytest

# type-check
basedpyright .

# dependency audit
pip-audit          # install via pip install pip-audit; alternative: safety check
```

## 产物验证

| 产物 | 验证 |
|---|---|
| Python wheel | `dist/*.whl`（及 `dist/*.tar.gz`）实际存在 |

## 失败处理

- 任一门禁失败 → 修复后重试（最多 3 次）；任何失败路径必须显式阻断发布
- 3 次仍失败 → 终止，release **BLOCKED**

## 输出格式

```text
## CI Dry-Run 结果
构建: ✅ (exit 0)
测试: ✅ (全部通过)
类型检查: ✅ (exit 0)
安全审计: ✅ pip-audit 0 漏洞
产物: ✅ dist/app-1.2.3-py3-none-any.whl
状态: ✅ DRY-RUN PASSED — 可继续发布
```
