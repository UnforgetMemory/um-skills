# Codex (OpenAI Codex CLI) 工具映射

| 操作 | 工具/命令 | 说明 |
| --- | --- | --- |
| 读文件 | read | offset/limit 行读取 (实际名称以探测为准) |
| 写/改文件 | write / edit | write 整体写入; edit 字符串替换 (须先 read) |
| 搜索 | grep / glob | ripgrep 正则 / 路径模式匹配 |
| 执行命令 | shell (bash/sh) | shell 命令执行; 支持 background 运行 |
| 网络 | web_search / web_fetch | 搜索与抓取网页 |
| 子任务 | task | sandboxed 子任务, 独立环境, 可指定 agent |
| 交互确认 | 文本 (TUI) | 无 GUI 按钮卡片; 需明确列出选项编号供选择 |

## 使用要点

- 工具名以当前 CLI 实际暴露为准: 若此表与实际不符, 优先使用实际可用工具 (能力探测)。
- 能力探测: 工具清单/帮助确认可用集, 不确定时询问用户。
- shell 在沙箱中执行: 文件系统操作受限制; 需权限时按 CLI 交互提示确认。
- 后台命令: 支持 background, 完成后轮询/通知结果。
- 交互: 纯文本确认, 决策需编号选项 (如 "1. 是 2. 否 3. 跳过")。

## 操作分类对照

| 分类 | 覆盖 |
| --- | --- |
| 读文件/写文件/搜索/命令 | read, write, edit, grep, glob, shell |
| 网络/子Agent/编排 | web_search, web_fetch, task |
| 清单/上下文 | 无独立清单工具; 上下文管理依赖 CLI 内置机制, 按实际版本确认 |
