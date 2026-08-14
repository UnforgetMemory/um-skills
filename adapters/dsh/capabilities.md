# DSH 特性能力档案

## 交互
- ask_user_question: GUI 弹窗按钮卡片, 支持一次多问; 推荐项放首位并标注 (Recommended)。
- 审批弹窗: 需批准的动作在 UI 等待用户; 本会话若禁用审批则自动拒绝, 不请求升级。

## 子 Agent
- subagent: 独立上下文, 默认后台运行; 完结时自动通知, 结果不自动流入本会话 (需 report)。
- subagent_fork: 继承已完成轮次上下文; 二者均可 send_message 续对话 / interrupt_agent 取消。
- workflow: JS 脚本大规模扇出, agent/pipeline/parallel 阶段化编排, 带 concurrency 上限。

## 记忆
- create_goal/get_goal/update_goal: 目标跨轮次持久, 支持 resume/pause/edit/complete/blocked。
- 会话压缩: 原生 compaction, 波间自动收缩旧上下文。
- storage 服务: 持久化存储 (需查询服务确认接口)。

## 插件
- Cordis 动态插件: host/client 双端, 事件 ctx.on, 副作用归 Fiber (ctx.effect)。
- 工具注册: 通过 `harness` Builtin (先查 Builtin.listBuiltins + Tool.listTools 确认 API), 不假设固定接口。
- 生命周期: define (不可变包) → run/update → stop/undefine; 每个包不可覆写, 改码 = 新包。

## 文件沙箱
- 常见为 workspace-write: 只可改会话工作区; 实际模式按会话/部署策略为准。
- 被拒操作: 策略拒绝标记, 禁止换法绕过; 审批启用时可一次升级重试, 审批禁用时止步。
- 命名管道: 受限模式下子进程管道捕获输出会 EPERM, 属文档化边界。
- 只读模式下 pwsh 处于 ConstrainedLanguage, .NET 静态调用受限。

## 上下文
- KV Cache 前缀稳定有利缓存; 动态内容 (时间戳等) 破坏缓存, 禁止写入指令。
- 上下文预算按波管理, 长任务依赖 compaction 与 goal 持久化。

## 模型路由
- 可在 agent preset 指定 provider/model; workflow 每 phase 亦可独立指定。

## 执行
- pwsh 独立进程, 无状态; 后台任务 job_* 全生命周期管理。
