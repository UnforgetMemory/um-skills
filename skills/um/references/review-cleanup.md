# 过期测试 / 进程 / 产物清理

## 1. 过期测试（最谨慎：先列出，后删除）

**定义**：针对已删除、已废弃或已迁移 API 的测试。

**流程**：
1. **识别**：用 `git log --diff-filter=D --name-only` 找出已删除文件中对应的测试；grep 已不存在的符号引用
2. **证据**：运行测试套件；确认测试失败 **且** 目标代码已消失（失败 + 目标缺失 = 过期证据）
3. **列出** → 人工确认 → 删除
4. **回归**：删除后立即重跑套件；确认全部通过

**保护规则**：
- ❌ 未经确认绝不删除任何测试
- ❌ 绝不删除"暂时失败"的有效测试——修复代码，不要删测试
- ❌ 绝不批量删除测试而不逐个解释

## 2. 测试 / 遗留进程

- 查找遗留的测试/开发进程（watch 模式、dev server、test runner）
- 终止（`kill <pid>`）前确认归属——**不要杀掉用户的其他工作进程**
- 同时清理测试输出目录：`coverage/` `test-results/` `playwright-report/`

## 3. 构建产物与临时文件

- 构建产物（`dist/` `build/` `target/` `*.o` `*.class`）：若已被 gitignore 覆盖（由 gitignore 审计保证），无需处理
- 临时文件：`*.tmp` `*.log` 测试日志、core dump
- 清理按项目而定；删除前确认没有进程正在使用目标（见第 2 节）
- 已被 gitignore 覆盖的产物：清理可选（无论如何 git 状态都是干净的）

## 4. 输出 —— 每个操作附 `Fact` 证据

```
Deleted stale test: [path + reason (with failure evidence)]
Terminated process: [pid + command]
Cleaned artifact:   [path]
```

证据 = 删除前的测试输出、进程列表、前后状态。
