# OpenCode 工具映射

| 操作 | 工具/命令 | 说明 |
| --- | --- | --- |
| 读文件 | read | offset/limit 行读取, 结果带行号 |
| 写/改文件 | write / edit | write 整体替换; edit 精确替换 (须先 read) |
| 搜索 | grep / glob | ripgrep 正则 / 路径模式匹配 |
| AFT 概念搜索 | aft_search | 概念/正则搜索, 理解意图找相关代码 |
| AFT 结构 | aft_outline | 文件/目录结构概览 |
| AFT 符号 | aft_zoom | 定位到符号定义 (函数/类等) |
| AFT 健康检查 | aft_inspect | 索引健康状态检查 |
| AFT 调用图 | aft_callgraph | 调用关系图 (调用者/被调用者) |
| AFT 重构 | aft_refactor | 符号重命名/移动等跨文件重构 |
| AFT 移动 | aft_move | 移动文件/符号 |
| AFT 删除 | aft_delete | 删除符号/文件 (带安全检查) |
| AFT 导入 | aft_import | 自动补导入/整理导入 |
| AFT 安全 | aft_safety | 重构安全风险评估 |
| 执行命令 | bash | shell 命令执行 (以实际环境探测为准) |
| 持久记忆 | ctx_memory | 跨会话记忆读写 |
| 跨会话搜索 | ctx_search | 在历史会话中搜索 |
| 笔记 | ctx_note | 记录上下文笔记 |
| 上下文压缩 | ctx_reduce | 压缩当前上下文 |
| 上下文扩展 | ctx_expand | 展开/恢复被压缩的上下文 |
| LSP 诊断 | lsp_diagnostics | 获取编辑器/语言服务器诊断 |
| 多 Agent 编排 | task | 创建/管理 agent 任务 (编排子任务) |
| 子 Agent | add_subagent | 添加子 agent 协作 |
| 交互确认 | 文本 TUI 输入 | 无 GUI 弹窗; 需明确列出选项编号供选择 |
| 任务清单 | 无内置 | 计划写对话中自行维护 |
| 网络 | 无内置 | 无 web 搜索/抓取工具 |

## 使用要点

- 工具实际可用集随版本/配置变化: 先探测 (如 `opencode --help` 或能力清单) 再使用。
- AFT 与 grep 互补: AFT 语义理解, grep 精确文本。
