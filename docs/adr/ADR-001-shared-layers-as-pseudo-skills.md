# ADR-001: 共享层以伪技能目录形式通过 skills 安装器分发

## Status

Superseded by [ADR-002](ADR-002-self-contained-skill-bundles.md)（2026-08-14）
—— 桩方案对 vercel-labs/skills 的选择性安装与技能选择列表均不成立，见 ADR-002 事实核查。

---

> 以下为已被取代的原始决策记录（保留供溯源）。

## Context

`npx skills add` 类安装器以「目录含 SKILL.md」为单位发现并复制技能。
**Fact**：仅含 SKILL.md 的目录会被安装；`core/references/`（L0+L2）与
`adapters/`（L3）无 SKILL.md → 不被安装 → 四个技能路由表中 ~35 处
`../core/references/*.md`、`../adapters/<env>/*` 引用全部悬空，
reference 无法溯源。

候选方案：
- A 技能自包含（生成式 vendor，脚本把引用闭包复制进每个技能目录）
- B 共享层加非可调用 SKILL.md 桩，骗过安装器整目录复制
- C 仅文档指引 clone + deploy.ps1

## Decision

采用 **B**：在 `core/SKILL.md` 与 `adapters/SKILL.md` 放置安装桩
（`disable-model-invocation: true`、`user-invocable: false`，正文不承载任何规则），
使安装器将共享层与技能一同整目录复制到目标技能根，现有 `../` 引用约定保持有效。

## Rationale

- 零重复内容：core/adapters 仍是唯一编辑点，无需生成器与一致性校验
- 四个路由表零改动：KV Cache 前缀完全稳定，token 账本不变
- DSH/OpenCode/Codex 手工部署布局不变，deploy.ps1 无破坏性操作
- 否决 A：仓库出现 4 份生成副本，引入 sync 脚本与漂移风险，超出用户接受度
- 否决 C：不解决用户指定的 skills 安装场景

## Consequences

- **Assumption**：安装器对「含 SKILL.md 的目录」整目录复制（含子目录）；
  需在合并后实际执行一次 `skills add` 验证
- 不支持单技能安装（如 `--skill umpp`）：引用文件在兄弟目录，必须整库安装
- 技能列表可能出现两个不可调用的条目（core/adapters），
  以 `disable-model-invocation: true` + `user-invocable: false` 压制
- 纪律：桩文件永久保持「零规则内容」；规则只进 `core/references/` 与
  `adapters/<env>/`
