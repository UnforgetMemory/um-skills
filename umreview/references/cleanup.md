# 过期测试 / 测试进程 / 产物清洁

## 1. 过期测试（最谨慎，先列后删）

**定义**：针对已删除、已废弃、已迁移 API 的测试。

**流程**：

1. **识别**：`git log --diff-filter=D --name-only` 找已删除文件对应的测试；grep 已不存在的符号引用
2. **证据**：运行测试套件，确认该测试失败且目标代码已删除（失败 + 目标消失 = 过期证据）
3. **列清单** → 人工确认 → 删除
4. **回归**：删除后立即重跑套件确认全绿

**保护规则**：

- ❌ 未经确认删除任何测试
- ❌ 删除"暂时失败"的有效测试（修复代码，不删测试）
- ❌ 批量删除多个测试而不逐项说明理由

## 2. 测试进程 / 遗留进程

```bash
# 查找遗留测试/开发进程（示例）
ps aux | grep -E "vitest|jest --watch|playwright|next dev|vite|npm run dev|pnpm dev" | grep -v grep
```

- 确认进程归属后 `kill <pid>`（**不 kill** 用户其他工作进程）
- 附带清理测试输出目录：`coverage/` `test-results/` `playwright-report/`

## 3. 构建产物与临时文件

- 构建产物：`dist/` `build/` `target/` `*.o` `*.class` — 若已被 gitignore 覆盖（Phase 4 保证）则无需处理
- 临时文件：`*.tmp` `*.log` 测试日志、core dump
- 清理命令（示例，按项目调整）：

```bash
rm -rf dist/ build/ coverage/ test-results/ playwright-report/ __pycache__/ .pytest_cache/
```

- 删除前确认无正在使用的进程（配合第 2 节）
- 被 gitignore 忽略的产物：清理属可选项（不污染 git 状态即可）

## 4. 输出

```
已删除过期测试: [路径 + 理由（含失败证据）]
已终止进程: [pid + 命令]
已清理产物: [路径]
```

全部动作带 `Fact` 证据（删除前测试输出、ps 输出、清理前后状态）。
