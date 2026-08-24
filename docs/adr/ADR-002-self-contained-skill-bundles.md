# ADR-002: 技能自包含分发（统一顶层 skills/ + 生成式 vendor）

## Status

Superseded by [ADR-003](ADR-003-umbrella-single-skill.md)（2026-08-14）
—— vendor 副本违背单一事实源初衷并引入路由副本漂移面，由伞形单技能方案取代。
其「vercel-labs/skills 安装器事实核查」一节仍然有效，被 ADR-003 继续引用。
原状态：Accepted（2026-08-14，取代 [ADR-001](ADR-001-shared-layers-as-pseudo-skills.md)）。

## Context

目标安装器为 vercel-labs/skills。对其源码的核查结论（Fact，均出自
github.com/vercel-labs/skills 主分支源码）：

1. 安装单元 = **技能自身目录**：`installer.ts copyDirectory(skill.path → dest)`
   递归复制并解引用 symlink；技能目录之外的任何文件永不参与安装
2. 目标目录名取自 frontmatter `name`（`sanitizeName(skill.name)`）
3. 发现规则（`skills.ts discoverSkills`）：优先扫描仓库根（深度 1）与官方
   统一顶层容器 **`<root>/skills/`**（深度 3，发现 SKILL.md 即停止下探）；
   根级 SKILL.md 会提前返回只装该技能；全递归兜底仅在零命中时触发
4. `parseSkillMd` 要求 frontmatter 含字符串 `name` 与 `description`，
   否则目录被跳过——这是「core/adapters 不被安装」的直接机制
5. 支持交互多选与 `--skill` 选择性安装（`add.ts`）：任何依赖兄弟目录的
   设计在选择子集时必然产生悬空引用
6. `.claude-plugin/marketplace.json` / `plugin.json` 清单只增加搜索路径，
   不存在共享资产机制

ADR-001 的桩方案（core/adapters 加伪 SKILL.md）在整库安装时可行，但：
(a) 两个假条目污染技能选择列表；(b) 选择性安装/单技能安装立即断链；
(c) 依赖 name→dirname 巧合。故取代之。

## Decision

采用**统一顶层容器 + 技能自包含**模型：

```
um-skills/
├── core/references/        ← L0+L2 唯一编辑点（无 SKILL.md，安装器忽略）
├── adapters/               ← L3 唯一编辑点（同上）
├── scripts/sync-references.ps1   ← 生成器（apply / -Check / -Verify）
└── skills/                 ← 官方统一顶层容器，唯一分发物
    ├── umpp/
    │   ├── SKILL.md        （路由表，引用 references/*.md 与 adapters/<env>/…）
    │   ├── references/     ← 由 core/references 按引用闭包 vendor（生成产物）
    │   └── adapters/<env>/ ← 整树镜像（生成产物）
    └── umcommit/ umrelease/ umreview/（同构）
```

- 规则内容只在 `core/` 与 `adapters/` 编辑；改后必须运行
  `scripts/sync-references.ps1` 再生成四个技能的副本
- SKILL.md 路径约定改为技能内相对路径（`references/X.md`、
  `adapters/<env>/tools.md`），不再使用 `../`
- vendored 副本入库提交（安装器从 GitHub 直接复制）；一致性由 `-Check` 门禁保障

## Rationale

- 与安装器的复制模型严格对齐：每个技能 = 一个完整可分发单元，
  整库装、多选装、`--skill` 单装全部正确
- 采用官方 `skills/` 容器约定（深度 3 下探），仓库根保持干净，
  canonical 层天然不被安装器误收
- 否决「单一伞技能吞并全部」：会丢失四专业独立注册、独立触发词与链路 UX
- 代价：仓库内 ~4× 共享层副本（约 140KB 级，磁盘成本；运行时仍懒加载，
  token 账本不变）+ 需要同步脚本纪律

## Consequences

- 修改规则的工作流变为两步：编辑 core/adapters → 运行 sync 脚本；
  CI/提交前用 `-Check` 防漂移
- 未被任何 SKILL.md 引用的 canonical 文件不会进入分发物
  （当前已知孤儿：`core/references/release-notes.md`，待单独处置）
- DSH/OpenCode/Codex 手工部署改为复制 `skills/*` 四个目录；
  目标机旧布局残留的 core/adapters 仅提示不删除
