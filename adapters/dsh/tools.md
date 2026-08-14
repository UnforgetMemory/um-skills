# DSH (DeepSeek Harness) 工具映射

| 操作 | 工具/命令 | 说明 |
| --- | --- | --- |
| 读文件 | read | offset/limit 行读取, 结果带行号 |
| 写/改文件 | write / edit | write 整体替换; edit 精确字符串替换 (old_string 须唯一, 可 replace_all) |
| 搜索 | grep / glob | grep: ripgrep 正则, 结果带行号; glob: 路径模式匹配, 只返回文件 |
| 执行命令 | pwsh | PowerShell 独立进程, 状态不跨调用; 用 workdir 指定目录; 长任务 run_in_background: true |
| 交互确认 | ask_user_question | 一次可多问 + 结构化 options, GUI 按钮卡片; 推荐项标注 (Recommended) 放首位 |
| 子 Agent | subagent / subagent_fork | subagent: 独立上下文, 默认后台; subagent_fork: 继承本会话上下文 |
| 子 Agent 通信 | send_message / interrupt_agent | send_message 续对话 (仅 depth-1); interrupt_agent 取消当前轮 |
| 大规模编排 | workflow | JS 脚本编排: agent / pipeline / parallel / phase / log, 返回 JSON |
| 任务清单 | todo_write | 整单替换式任务清单, 每步一个状态 |
| 长期目标 | create_goal / get_goal / update_goal | 跨轮次持久目标, 续轮前先 get_goal 取 id/revision |
| 后台任务 | job_list / job_output / job_kill | 后台 job 全生命周期; 完结时系统自动通知, 勿轮询 |
| 网络 | web_search | 返回摘要 + 来源 URL, 引用时用 Markdown 链接 |
| 插件 | cordis_define / cordis_run / cordis_stop / cordis_undefine / cordis_inspect_* | 动态 Cordis 插件全生命周期 (先 Inspect 再 define) |
| 上下文压缩 | 原生 compaction | 波间自动收缩, 无需手动工具 |
| 插件代码约束 | — | 插件 Client 代码不假设 process/window/fetch/Buffer 等全局存在, 需先查询 Builtins/Services 确认 |

## 使用要点

- 文件类操作: 修改前先 read (fs-observation-policy 要求); glob 而非 shell find, read 而非 cat。
- 命令类: pwsh 每次全新进程, 路径用 Windows 原生形式, 环境变量经 $env:NAME。
- 沙箱: 常见为 workspace-write, 按会话策略为准; 被拒 = 策略拒绝, 非 bug, 不得换法重试同一命令 (审批启用时可一次升级重试)。
- 非零退出码是失败信号, 先调查再继续; Windows 强杀表现为裸 exit 1。
