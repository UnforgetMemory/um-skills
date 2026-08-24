---
name: um
description: >-
  UM 工程链路 · 统一入口。按触发词路由到四个专业分册：umpp（规划）、
  umcommit（CHANGELOG/提交/推送）、umrelease（CI 门禁发布/tag）、
  umreview（五轴审查）。共享 references/ 与 adapters/ 唯一副本，分层懒加载。
  触发词：um/umpp/ULW/umcommit/写 CHANGELOG/提交/推送/umrelease/发布/
  Release/umreview/审查/pre-merge review。
whenToUse: >-
  User says um, umpp, ULW, umcommit, umrelease, or umreview; or asks for
  structured planning of a complex task, CHANGELOG + commit + push,
  gh release publishing, or a code review / cleanup pass.
disable-model-invocation: false
user-invocable: true
---

# um — UM 工程链路统一入口

## 专业路由（按触发词/意图选读**一个**分册，禁止全读）

| 触发词 / 意图 | 分册 |
|---------------|------|
| `umpp` / ULW / 架构设计 / 复杂多步工程任务 | `professions/umpp.md` |
| `umcommit` / 写 CHANGELOG / 提交 / 推送 | `professions/umcommit.md` |
| `umrelease` / 发布 / Release / 版本 tag | `professions/umrelease.md` |
| `umreview` / 审查 / pre-merge review | `professions/umreview.md` |

## 公共前置（每会话一次，先于任何分册执行）

1. read `references/base-constraints.md`（元约束，必须）
2. read `references/environment-routing.md` → 识别环境 → read `adapters/<env>/tools.md`

## 链路

```
umpp（规划）→ umcommit（提交）→ umrelease（发布）
       ↑ 任意阶段可插入 umreview（审查）
```

跨专业衔接时读取对应分册的「链路位置」节；同会话已读的 references 不重复读取。

## 纪律

1. 本入口只做路由：选定分册后按其 Phase 路由表执行，不在入口层做业务决策
2. `references/` 与 `adapters/` 是唯一规则源；修改在本技能目录内进行，一处生效
3. 分册间禁止互相内联规则；subagent 只带自己链路的 reference 路径
