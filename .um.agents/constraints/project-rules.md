# 项目规范（um-skills 仓库自举）

## 本仓库定位
多环境（dsh/opencode/codex）可路由的工程技能链路库。

## 架构约束
- core/references/ = 平台无关规则层，单一事实来源，改一处生效
- adapters/<env>/ = 平台相关工具层，每环境一份，禁止在 core 中写平台工具
- SKILL.md = 路由表（Phase → reference 映射），禁止内联大段规则
- 面向 agent 的文件（SKILL.md/references）禁止面向人类写作；README/ARCHITECTURE 面向人类

## 维护纪律
- 新增规则：先判断平台无关 → 放 core；平台相关 → 放对应 adapter
- 修改规则：只改 core 一处，禁止复制到各 skill
- 记忆分级：团队共识 → constraints/（入库）；个人/歧义 → memory/*.local.md（不 sync）
