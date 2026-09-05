# ADR-004: 新增 uma 只读分析专业（umanalyze）

## Status

Accepted（2026-09-04）

## Context

用户需要一种只读的分析讲解能力：以事实（Fact）回答关于项目结构、代码链路、
引用点、重构利弊的问题，给出改进方向但不落地，并支持跨语言惯用法启发。
要求沿用伞形单技能的主路由 + 按需 reference 加载（降低初始上下文占用），
并要求分析结论记忆「变更感知的按需刷新（准实时）、不乱动」：代码没变的区域
结论持续有效、不频繁重写，多个 subagent 不得并发改写同一区域的记忆。
审查结论：记忆页本质是历史快照，不能作为「现在时」的参考点——
答案证据必须来自当次 read，记忆只作先验（导航/省 token/漂移检测）。

## Decision

1. 新增专业分册 `skills/um/professions/uma.md`（触发词 `uma` / `umanalyze`），
   复用公共 L0（base-constraints/environment-routing/context-adaptation 等）、
   L3 adapters 与部分 L2（review-axes.md、architecture-principles.md 等只读透镜）。
2. 新增两个平台无关 L2 规则文件：
   - `references/uma-methods.md` — 分析方法（结构地图/区域深潜/链路/引用点/重构/跨语言启发）
   - `references/uma-memory.md` — 区域 wiki 记忆协议（有效期标记、git 变更判定、区域锁）
3. 记忆存储：`<projectRoot>/.um.agents/memory/uma/`（`.local.md`，不 sync）：
   每区域一页 + `index.local.md` 索引 + `locks/` 写锁目录。
4. 失效判定用 git 变更而非仅时间戳：页面记录 `gitRef`（区域最近一次 commit），
   读取时与 `git log -1 --format=%H -- <regionPaths>` 实时比对；
   FRESH → 零写入、结论降级为先验（导航/假设生成）；STALE → 仅重析该区域并回写；
   MISSING → 新建。
5. 信任模型：结论分三级——`Live`（当次 read 验证，唯一可作回答证据）、
   `Snapshot`（记忆页历史结论，未复验，仅导航/假设）、`Advice`（建议类，时间戳驱动失效）。
6. 并发控制：区域写锁文件（独占创建，写完即删）+ subagent 分派区域两两不相交。

## Rationale

- 只读专业不进入 umpp→umcommit→umrelease 提交链，符合 ADR-003
  「新增专业 = 新建 professions/<name>.md + 入口路由表加一行」的既定扩展路径。
- gitRef 比对优于纯时间戳：区域无变更则历史结论可作为先验继续省 token
  （零写放大、防 KV Cache 抖动）；区域有变更立即失效。但记忆是历史点而非现在时：
  答案证据永远来自当次 read，gitRef 只负责漂移检测与失效触发——
  即「变更感知按需滚动的 wiki 八爪鱼」，不宣称「实时」。
- 锁文件 + 区域不相交分派是平台无关的并发安全方案，不引入跨环境依赖。
- 显式局限：页面 agent-local、跨会话/跨 agent 锁不生效，共享知识走 constraints/ 晋升。

## Consequences

- `skills/um/SKILL.md` 路由表 +1 行、description/whenToUse 增补触发词；
  `professions/` +1 分册；`references/` +2 文件；人类文档（README/ARCHITECTURE）同步。
- 目标项目 `.um.agents/memory/` 下出现 `uma/` 子目录（本地缓存，不 sync）。
- uma 自身严格只读：分析产出的改进方向落地仍需人工触发 umpp / umreview。
