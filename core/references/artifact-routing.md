# Agent 产物路由（L0 — 识别 · 迁移 · 豁免 · 记忆）

> 目标：agent/AI 工具生成的非项目源代码集中管理，防止散落仓库；
> 记忆极轻量（一行一决策），避免重复询问与错误迁移。

## 1. 产物三分类

| 类别 | 定义 | 处理 |
|------|------|------|
| **需迁移** | agent 生成的约束/规范/索引类产物 | 迁移到 `.um.agents/`（constraints 或 memory） |
| **豁免** | AI 工具/IDE 专属目录，有自身规范 | 不迁移，仅确认已 gitignore |
| **待确认** | 无法自动分类 | 决策面板询问，决策记入记忆 |

## 2. 豁免清单（AI 工具特定产物，无需迁移）

```
.omo/           OpenCode 运行时（会话延续/工具输出）
.sisyphus/      agent 运行时工作目录
.dsh/           项目级 DSH 配置
.codex/ .cursor/ .vscode/ .idea/
                IDE/工具配置（工具自身管理）
.localref/      本地参考材料
node_modules/ dist/ build/ 等构建产物（gitignore 即可）
```

> 规则：工具目录归工具管——迁移会破坏工具集成，一律豁免。

## 3. 扫描触发点

### umpp Phase 0（全量调查）
```
1. 扫描根目录未跟踪/新增的 agent 产物（对照豁免清单）
2. 命中豁免 → 跳过；命中迁移决策记忆 → 按记忆处理
3. 发现未归档产物（新/未知）→ 决策面板询问：
   「发现未归档产物 <name>，如何处置？」
   options: [迁移全部, 迁移部分(选择), 豁免并记录, 仅本次忽略]
4. 决策写入记忆（一行）
```

### umreview P6（轻量流转）
```
只做：git status 未跟踪 + 已知产物模式扫描（不展开分析）
命中记忆 → 直接应用，零询问；仅新产物才提示
```

## 4. 迁移决策记忆（极轻量）

路径：`.um.agents/memory/artifact-decisions.local.md`（gitignored）

```markdown
# 产物迁移决策记忆（本地）
<!-- pattern|action|date | note -->
.omo/|skip|2026-08-14 | tool-owned
.vscode/|skip|2026-08-14 | IDE config
.env|warn|2026-08-14 | contains secrets
```

- 格式：`pattern|action|date`（action: migrate / skip / warn）
- 每行 <60 字符，整个文件 <500 字符
- 命中记忆 → 直接执行，**零询问零 token 浪费**
- 记忆 append-only，**新行覆盖旧行（后写优先）**——决策错误时追加新决策修正，不删旧行
- 迁移到 `constraints/` 的条目需人工确认（见 [project-memory.md](project-memory.md) 分级规则）

## 5. 纪律
- 禁止未经确认的批量迁移（防误迁工具目录）
- 豁免决策写入 gitignore + 记忆，双保险
- 迁移目标：约束类 → `constraints/`（入库）；个人/本地 → `memory/*.local.md`（不 sync）
