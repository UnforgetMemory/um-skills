# ADR-005: 移除 deploy.ps1（部署收敛为 ADR-003 既有方式）

## Status

Accepted（2026-09-05，用户裁定，修订 [ADR-003](ADR-003-umbrella-single-skill.md) 的部署面）

## Context

`deploy.ps1` 自 v0.1.x 引入，随版本演进追加了旧布局提示与 D3 交互确认门禁，
但其目标路径 `%USERPROFILE%\.dsh\skills` 已与实际技能加载路径漂移
（当前环境经 `.agents/skills` 加载，脚本目标 `~/.dsh/skills` 不存在）。

现状存在三种并存的部署说法：npx skills 安装器（ADR-003）、手工复制、deploy.ps1。
目标路径漂移 + 多方式并存 → 部署副本误判风险（把部署副本当源、把源当部署），
且脚本维护成本不再有收益。用户裁定：不再需要，移除。

## Decision

- 删除仓库根 `deploy.ps1`；不再维护脚本式部署
- 部署方式收敛为 ADR-003 既定两条：
  1. `npx skills add unforgetmemory/um-skills`（单技能即全量）
  2. 手工复制唯一技能目录 `skills/um` → 目标机技能目录
- v0.1.x 旧布局残留的清理提示由文档承担（ARCHITECTURE.md），不再由脚本提示

## Rationale

- canonical 即安装物（ADR-003）已成立，脚本式分发是历史遗留；
  删除零副本、零同步脚本符合「无副本则无漂移」
- 消除目标路径漂移造成的误判面：源仓库是唯一规则源，
  部署副本的同步改为从源仓库复制（规则见 prohibitions.md 门禁 E 决策流）

## Consequences

- ARCHITECTURE.md「部署」节移除方式三（脚本）并修订旧布局提示
- CHANGELOG 中 v0.1.x–v0.3.x 的历史条目保留（历史记录不可变）
- 删除前恢复点：R1 HEAD 哈希 + R3 文件备份（`.um.agents/tmp/`，已 gitignore）；
  误删可用 `git show HEAD:deploy.ps1` 或备份文件恢复
