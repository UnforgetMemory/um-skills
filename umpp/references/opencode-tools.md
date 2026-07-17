# ⚡ OpenCode 工具高效利用

本 skill 运行在 OpenCode 环境中，必须充分利用以下原生工具链以提升效率。**优先使用工具而非手动操作**。

---

## 🔍 AFT（Advanced File Tools）

AFT 是 OpenCode 的核心代码感知工具集，**全面优先于** bash grep/find/cat 等原始命令行。

| 工具 | 用途 | 替代的原始操作 |
|------|------|---------------|
| `aft_search` | 概念搜索、标识符、正则、字面量、错误字符串 | `grep -rn` / `rg` |
| `aft_outline` | 文件结构概览、目录文件树 | `find .` / `ls -R` |
| `aft_zoom` | 读取特定符号（函数/类/类型） | `cat` / `sed` 截取 |
| `aft_inspect` | 代码健康检查（诊断/TODO/死代码/重复代码） | 手动翻阅逐文件检查 |
| `aft_callgraph` | 调用图分析（callers / impact / trace） | `grep` 拼凑调用链 |
| `aft_refactor` | 符号移动、函数提取、内联 | 手动重构+修引用 |
| `aft_delete` | 删除文件/目录（带备份可恢复） | `rm -rf` |
| `aft_move` | 移动/重命名文件 | `mv` |
| `aft_import` | 语言感知的 import 管理 | 手动增删导入语句 |
| `aft_safety` | 文件备份/撤销/检查点 | `git stash` 等 |

### 使用纪律

- **禁止** 使用 `grep`/`rg`/`find`/`cat`/`sed` 做代码搜索或阅读——一律使用 `aft_*` 工具
- `bash` 只用于：git 操作、构建运行、测试执行、文件系统元信息（`ls`、`stat`）
- 代码理解标准流程：`aft_search`（找到目标）→ `aft_outline`（了解结构）→ `aft_zoom`（深入符号）
- 复杂调用关系使用 `aft_callgraph` 而非手动 grep 拼凑
- 文件操作（移动/删除/重构）优先 `aft_move` / `aft_delete` / `aft_refactor`，它们自动处理备份和引用更新

---

## 🧠 Magic Context

Magic Context 提供跨会话的持久记忆、历史检索和上下文压缩能力，是长期项目的知识基石。

| 工具 | 用途 | 使用时机 |
|------|------|----------|
| `ctx_memory` | 持久项目知识（规则、约束、配置值、架构决策） | 发现团队/项目必须记住的事实立即写入 |
| `ctx_search` | 跨会话搜索（项目记忆、git 历史、历史对话） | 感觉某事之前讨论过或有记录时，**先搜再问人** |
| `ctx_note` | 工作笔记、后续跟进提醒 | 需要以后回来处理但非当前待办项时 |
| `ctx_reduce` | 标记已处理的大型工具输出为可丢弃 | 大型输出用完后立即标记释放上下文 |
| `ctx_expand` | 展开已压缩的历史对话获取原始内容 | 总结不够详细需要精确原文时 |

### 使用纪律

- **发现非显而易见的项目事实立即保存**：文件路径、构建命令、架构约束、配置值——`ctx_memory` 写入
- **不确定时先搜再问人**：`ctx_search` 优先于向用户提问，用户已给的答案不值得重复消耗
- **用完即弃**：大型工具输出（搜索结果、构建日志、测试输出）处理完有价值信息后立即 `ctx_reduce`
- **Phase 0 背景读取**：优先 `ctx_search` 查找相关历史决策和已知约束

### 本地参考资料 `.localref/`

项目根目录下的 `.localref/`（已 gitignore）用于存放**外部参考材料**，不提交到仓库：

```
.localref/
├── specs/             # 功能规格、PRD
├── references/        # 官方文档摘录、架构笔记
├── traces/            # 推理过程、决策记录
├── research/          # 技术调研、PoC 笔记
├── vendor/            # 他人项目源码参考/镜像
├── test-assets/       # 测试文件、样本数据
└── web-struct/        # 逆向网页结构、API 响应示例
```

典型用途：
- 参考其他开源项目的实现片段
- 保存逆向分析的网页 DOM 结构 / API 请求响应
- 存放测试素材（图片、视频、字幕文件等）
- 记录推理链路和架构决策草稿

**纪律**：
- 内容不入库，仅为当前开发环境提供上下文
- Phase 0 背景读取时优先检查 `.localref/` 中是否有相关材料
- 使用 `ctx_memory` 将 `.localref/` 中的重要发现持久化到项目记忆

---

## ✅ LSP 诊断

LSP 是代码正确性的第一道门禁。在 Phase 4→5 过渡和每次编辑后强制执行。

| 工具 | 用途 |
|------|------|
| `lsp_diagnostics` | 获取文件/目录的错误、警告、提示 |
| `aft_inspect(sections=["diagnostics"])` | 批量诊断快照（含 TODO/死代码等辅助信息） |

### 使用纪律

- **每次编辑后**：对修改过的文件运行 `lsp_diagnostics`，确认无新增错误
- **Phase 4→5 过渡**：对所有修改涉及的模块运行 `aft_inspect`
- **Phase 5 验证前置条件**：

```
lsp_diagnostics clean
    ↓
构建通过（exit 0）
    ↓
测试通过（所有场景 PASS）
    ↓
declare done
```

- **禁止** 在 LSP 报错未修复的情况下推进到下一阶段
- **禁止** 使用 `@ts-ignore` / `@ts-expect-error` / `as any` 压制类型错误
