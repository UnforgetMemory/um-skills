# 项目规范（um-skills 仓库自举）

## 本仓库定位
多环境（dsh/opencode/codex）可路由的工程技能链路库。

## 架构约束
- skills/um/references/ = 平台无关规则层，单一事实来源，改一处生效
- skills/um/adapters/<env>/ = 平台相关工具层，每环境一份，禁止在 references 中写平台工具
- skills/um/SKILL.md = 入口路由（触发词 → 分册）；professions/*.md = 专业路由表（Phase → reference 映射），禁止内联大段规则
- 面向 agent 的文件（SKILL.md/professions/references）禁止面向人类写作；README/ARCHITECTURE 面向人类

## 维护纪律
- 新增规则：先判断平台无关 → references；平台相关 → 对应 adapter；只改 skills/um/ 内唯一副本，一处生效、无同步步骤
- 分发机制：伞形单技能 skills/um（ADR-003），canonical 即安装物，仓库内不存在第二份规则副本
- 新增专业：新建 professions/<name>.md 分册 + 入口路由表加一行
- 记忆分级：团队共识 → constraints/（入库）；个人/歧义 → memory/*.local.md（不 sync）
