
# umcommit — 提交专业（CHANGELOG · 审计提交 · 安全推送）

## 链路位置
- 前置：umpp（复杂任务需先规划）；跳过时需说明
- 后继：umrelease（提交后需发布时）
- 并行：umreview（提交前审查，可先行）

## 前置路由（最小集，先读）
1. read `references/base-constraints.md`（元约束，必须）
2. read `references/prohibitions.md`（禁令清单 + 安全门禁 A-E，必须）
3. read `references/environment-routing.md` → 环境 → `adapters/<env>/tools.md`（会话内一次）
4. 其余 L0 延迟加载：`references/context-adaptation.md` 到 Phase 0 档位自检；`references/project-memory.md` 到 P2/P8 记忆读取；`references/decision-panel.md` 到首个决策点；`references/destructive-ops-gates.md` · `references/recovery-points.md` 到首个文件修改前（CHANGELOG/版本文件）

## 核心定位
一次调用完成提交链路。**Commit 内容先展示确认；Push 必须显式允许。**

## 硬性纪律
1. 禁止未经确认的 push；commit 前必须展示内容
2. 安全审计 Critical/High → Hard Block，禁止提交
3. 只提交本次变更范围，禁止修改无关模块
4. 版本源以官方文件优先，记忆索引只是硬编码同步清单

## 执行管线（路由表）

| Phase | 做什么 | read（按需） | 工具 | 决策点 |
|-------|--------|-------------|------|--------|
| P0 | 变更采集：git status/diff/log 识别风格 | — | 环境命令 | 范围清单 |
| P1 | 提交规划：原子拆分（≥3 文件→≥2 commit） | references/conventional-commits.md | — | 拆分确认 |
| P2 | 版本识别：官方源检测→风格解析→智能适配 | references/version-detection.md | read | 决策面板 Q1 |
| P3 | CHANGELOG 编写 | references/changelog.md | 文件工具 | 版本化/Unreleased |
| P4 | CHANGELOG 安全审计 | references/security-audit.md | grep/命令 | Critical/High→阻断 |
| P5 | 提交消息生成 + 面板确认 | references/decision-panel.md | 交互工具 | 面板 Q2 |
| P6 | 暂存+审计（add 后 commit 前） | references/security-audit.md | grep/命令 | Hard Block |
| P7 | 执行提交：--signoff -F 消息文件；逐组验证 | — | 环境命令 | log 验证 |
| P8 | 硬编码同步：按索引短路径逐处更新→回写索引 | references/project-memory.md | 文件工具 | 索引核对 |
| P9 | 推送：面板 Q3 意愿→条件执行→验证 | — | 环境命令 | 显式确认 |

## 决策面板（一次交互，禁止分轮）
```
Q1 版本升级：按项目风格只给匹配选项
   SemVer→[major,minor,patch,自定义,skip] / CalVer→[日期,自定义,skip]
   无版本源→智能判断（库→询问建立；纯脚本→跳过仅 Unreleased）
Q2 提交确认：[确认 N 个 commit, 修改意见]（已展示 PLAN+消息）
Q3 推送意愿：[提交后推送, 仅本地提交]（条件执行，commit 失败则暂停回报）
```

## 验证门禁
1. P4：CHANGELOG 扫描零 Critical/High
2. P6：暂存区+消息扫描零 Critical/High
3. P7 每组后：git log -1 验证
4. P8：硬编码索引核对完成（无遗漏）
5. P9：仅显式确认后 push；终态 git status 干净

## 输出报告
```
## umcommit 报告
### 变更范围 / 提交计划
### CHANGELOG 更新 / 版本决策（含目标版本）
### 安全审计证据（Critical/High=0）
### 硬编码同步清单（路径+证据）
### 已提交 commits
### ⚠️ 状态: COMMITTED (NOT PUSHED) / PUSHED / BLOCKED
```
