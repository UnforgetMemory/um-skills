# OpenCode 特性能力档案

## AFT 代码感知套件
- 全套代码理解与重构工具: aft_search (概念/正则) / aft_outline (结构) / aft_zoom (符号) / aft_inspect (索引健康检查) / aft_callgraph (调用图) / aft_refactor (重构) / aft_move / aft_delete / aft_import / aft_safety (重构安全)。
- 基于代码索引, 语义搜索优于纯文本 grep; 精确文本仍用 grep。

## Magic Context
- ctx_memory: 跨会话持久记忆 (长期事实/偏好)。
- ctx_search: 跨历史会话检索上下文。
- ctx_note: 临时笔记, 供后续轮次引用。
- ctx_reduce / ctx_expand: 上下文压缩与恢复, 手动控制上下文预算。

## LSP
- lsp_diagnostics 内置: 直接获取诊断, 无需自建编译检查。

## 交互
- TUI 文本界面: 无 GUI 按钮卡片; 需要用户决策时列出编号选项 (如 1. 继续 2. 取消), 用户以文本回复编号。

## 多 Agent
- task: 编排子 agent 任务, 可将任务交给指定 agent。
- add_subagent: 动态添加子 agent 协作。
- 子任务独立上下文, 结果以文本返回。

## 执行
- bash (部分环境 cmd) shell 执行; 按平台探测可用命令。
- 工具集随版本/配置变化: 不确定时先探测, 再以实际可用为准。
