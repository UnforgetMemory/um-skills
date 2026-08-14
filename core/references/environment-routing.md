# 环境路由（L0 — 所有 skill 前置）

## 识别顺序（三阶，成本递增，命中即停）

### L1 system prompt 特征（零成本，优先）
- 系统提示含 "DeepSeek Harness" / "dsh" / `DSH_*` 变量 → **dsh**
- 系统提示含 "OpenCode" / `aft_*` / `ctx_*` → **opencode**
- 系统提示含 "Codex" / "codex" → **codex**
- 命中即确定：read `adapters/<env>/tools.md`（会话内一次），不再探测

### L2 工具签名（L1 无明确标识时）
- 工具含 pwsh / cordis_* / job_* → **dsh**
- 工具含 aft_search / ctx_memory / lsp_diagnostics → **opencode**
- 工具含 codex 特征（如 shell 交互工具集） → **codex**

### L3 询问 + 记忆（L2 也失败时）
1. `ask_user_question`：「无法自动识别环境，请选择」→ [dsh, opencode, codex, 其他]
2. 同轮追加：「是否写入项目记忆？下次自动识别」→ 是 → 写入 `.um.agents/memory/environment.local.md`

## 能力探测（非一刀切）
- 识别环境后读 `adapters/<env>/capabilities.md`
- 当前环境/model 有更强专用工具/MCP/thinking → 用内部的
- 没有 → 用 adapter 通用方案
- 禁止：能力未知时强行调用不存在的工具

## 记忆文件格式（environment.local.md）
| 项目 | 值 |
|------|-----|
| agent 平台 | <env> |
| 工具签名 | <tools> |
| 交互方式 | <ask 工具名> |
| 备注 | <模型容量/特殊能力> |
