# um-skills

多环境（DSH / OpenCode / Codex）可路由的工程技能链路库：规划 → 提交 → 发布，任意阶段可插入审查。

## 快速开始

```bash
# 部署到 DSH
cp -r core adapters umpp umcommit umrelease umreview ~/.dsh/skills/

# core/ 与 adapters/ 无 SKILL.md，不会被注册为 skill，仅被 skill 按需 read 引用
```

在任意支持环境中，对 agent 说 `umcommit` / `umrelease` / `umreview` / `umpp` 即可触发对应专业。

## 技能一览

| Skill | 专业 | 一句话 |
|-------|------|--------|
| [umpp](umpp/SKILL.md) | 规划 | 复杂多步工程任务：Problem Statement → Spec → TODO → 波次执行 → 验证 |
| [umcommit](umcommit/SKILL.md) | 提交 | CHANGELOG + 审计提交 + 推送（一次决策面板，版本智能适配） |
| [umrelease](umrelease/SKILL.md) | 发布 | CI dry-run 门禁 → Release Notes → SemVer/CalVer tag → gh 发布 |
| [umreview](umreview/SKILL.md) | 审查 | 核磁共振式五轴审查 + 安全/gitignore/测试/清洁，不提交不推送 |

## 架构简述

```
L0 基础约束  core/references/   （6 个：元约束/环境路由/档位/决策面板/Subagent/项目记忆）
L1 专业编排  4 个 SKILL.md = 路由表（Phase → reference 映射）
L2 流程规则  core/references/   （~25 个细分文件，每文件 = 一个可独立委派子任务）
L3 环境工具  adapters/{dsh,opencode,codex}/{tools,capabilities}.md
```

设计原则：**分层下探，按需取用**——任何一层都不吞并其他层的内容；subagent 只携带自己链路的 reference。

## 项目记忆

每个项目根目录可建 `.um.agents/`：

```
.um.agents/
├── constraints/          入库（团队共享）
│   ├── hardcode-index.md 硬编码语义索引（升级版本不漏硬编码）
│   └── project-rules.md  项目规范
└── memory/               不 sync（*.local.md：环境识别/决策草稿/陷阱）
```

## 详细设计

见 [ARCHITECTURE.md](ARCHITECTURE.md)：四层架构、环境路由、决策面板、波次迭代、Token 账本、维护指南。

## License

MIT
