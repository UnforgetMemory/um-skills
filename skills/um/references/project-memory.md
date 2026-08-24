# 项目记忆（L0 — .um.agents 规范）

## 目录结构
```
<projectRoot>/.um.agents/
├── constraints/               ← 入库（团队共享）
│   ├── hardcode-index.md      ← 硬编码语义索引
│   ├── project-rules.md       ← 项目规范/约束
│   └── environment.md         ← 仅团队统一环境时才入库
├── memory/                    ← 本地，不 sync（gitignore）
│   ├── environment.local.md   ← 环境识别结果（歧义优先 local）
│   ├── artifact-decisions.local.md ← 产物迁移决策记忆（一行一决策，见 artifact-routing.md）
│   ├── decisions.local.md     ← 个人决策草稿
│   └── gotchas.local.md       ← 已知陷阱
└── .gitignore                 ← 自包含：memory/ + *.local.md
```

## 硬编码语义索引（hardcode-index.md）
```
| 语义 | 当前值 | 短路径（文件:行） | 同步说明 |
| 项目版本号 | 1.2.3 | Cargo.toml:5 · docker-compose.yml:12 | 升级同步 2 处 |
| 服务端口 | 8080 | src/main.rs:21 · nginx.conf:8 | 修改需同步 |
```
- 发现「无法变量化的值」→ 立即登记（语义 + 短路径）
- 升级流程：官方源升级后 → 按索引短路径逐处同步 → 回写索引
- **索引不是版本权威源**，只是硬编码同步清单

## 分级规则
- `.local.md` 后缀 = 本地专属，永不 sync（全局 gitignore：`*.local.md`）
- 歧义/个人内容 → 优先 local；团队共识 → 升级到 constraints/（去 .local 后缀）
- constraints 入库前经人工确认（禁未经确认的团队级写入）

## Agent 产物路由
- 未归档 agent 产物的识别/迁移/豁免规则见 [artifact-routing.md](artifact-routing.md)
- 决策记忆文件：`memory/artifact-decisions.local.md`（极轻量，一行一决策）
