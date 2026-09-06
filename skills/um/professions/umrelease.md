
# umrelease — 发布专业（CI 门禁 · Release · gh CLI）

## 链路位置
- 前置：umcommit（tag 应指向已提交版本）；跳过时需确认版本一致性
- 后继：无
- 并行：umreview（发布前审查）

## 前置路由（最小集，先读）
1. read `references/base-constraints.md`（元约束，必须）
2. read `references/prohibitions.md`（禁令清单 + 安全门禁 A-E + 人工确认协议，必须）
3. read `references/environment-routing.md` → 环境 → `adapters/<env>/tools.md`（会话内一次）
4. 其余 L0 延迟加载：`references/context-adaptation.md` 到 Phase 0 档位自检；`references/project-memory.md` 到 P0/P9 记忆读取；`references/decision-panel.md` 到 P4 版本与范围确认；`references/destructive-ops-gates.md` · `references/recovery-points.md` 到首个文件修改前（Notes/版本文件）

## 核心定位
一次调用完成发布。**CI dry-run 未通过禁止创建 tag/发布；tag 与发布均以面板确认（Q1+Q2+Q3）为硬前置；Notes 发布前必须展示全文。**

## 硬性纪律
1. CI dry-run 门禁未过 → 禁止 tag/发布
2. 面板确认硬前置：P4 一次交互 Q1（版本）+ Q2（发布范围）+ Q3（确认效力）；tag/发布仅按确认选项执行；Notes 发布前展示全文；禁止暴露内部接口/实现细节
3. 效力语义：确认默认仅本次（单次有效，新一轮/内容变更须重新确认）；Q3=本会话允许 时同动作免逐次面板、展示不豁免，后续轮沿用当轮 Q2 范围（禁止扩大），授权可随时撤销（人工确认协议见 `references/prohibitions.md`）
4. Notes 专业、简洁、英文
5. 版本决策按 `references/decision-panel.md` 智能适配（SemVer/CalVer/自定义）

## 执行管线（路由表）

| Phase | 做什么 | read（按需） | 工具 | 决策点 |
|-------|--------|-------------|------|--------|
| P0 | 版本与范围采集：版本源检测 + 待发布变动 + gh 可用性 | references/version-detection.md | read/命令 | 版本源确认 |
| P1 | CI dry-run 门禁：按项目栈构建+测试+产物验证，**不发布** | references/ci-*.md（按栈选 1 个） | 构建命令 | 失败→修复重跑 |
| P2 | Release Notes 生成：git log 分类映射 | references/changelog.md · references/conventional-commits.md · references/release-notes.md | 文件工具 | 结构定稿 |
| P3 | Notes 安全审计：内部泄露扫描 | references/security-audit.md | grep/命令 | Critical/High→阻断 |
| P4 | 版本与范围确认：面板 Q1+Q2+Q3 一次交互（Q2∈发布/仅 tag/修改 Notes；Q3 效力） | references/decision-panel.md | 交互工具 | 目标版本 + 发布范围 + 效力 |
| P5 | 创建 tag：仅当 Q2∈{发布, 仅 tag}；SemVer vX.Y.Z / CalVer YYYY.MM.DD[.HHMM[.NN]]；验证 | references/version-tag.md | 命令 | Q2 前置（当轮）；tag 冲突检查 |
| P6 | Notes 终版展示（发布前全文展示；Q2=修改 Notes → 回 P2 重做：仅本次 → 重新面板确认，本会话允许 → 重新展示即可） | — | — | Q2=发布才进 P7 |
| P7 | 发布：硬前置 Q2=发布；gh release create（标准/prerelease/draft/assets） | references/release-gh.md | 命令 | Q2=发布前置（当轮）；exit 0 |
| P8 | 验证：gh release view 确认可见+资产 | references/release-gh.md | 命令 | 核对 |
| P9 | 硬编码联动：按索引同步发布版本号 → 回写索引 | references/project-memory.md | 文件工具 | 索引核对 |

## 决策面板（一次交互）
```
Q1 版本确认：按项目风格只给匹配选项（SemVer/CalVer 含时间戳+随机位链/自定义/沿用）
Q2 发布范围：[发布, 仅打 tag 不发布, 修改 Notes]（一次交互；决定 P5 tag 与 P7 发布是否执行；修改 Notes → 重做后重新面板确认）
Q3 确认效力：[仅本次, 本会话允许]（默认仅本次；本会话允许 = tag/发布免逐次确认，内容展示不豁免；会话结束失效）
```

## 验证门禁
1. P1：CI dry-run 全绿（构建 exit 0 + 测试过 + 产物存在）
2. P3：Notes 扫描零 Critical/High
3. P5（仅 Q2∈{发布, 仅 tag}）：tag 创建成功（git tag --points-at HEAD）
4. P7（仅 Q2=发布）：gh release create exit 0
5. P8（仅 Q2=发布）：gh release view 确认 Release + 资产
6. P9：硬编码索引同步完成
7. Q1/Q2/Q3 确认记录（面板编号 + 选项 + 效力层级）已写入报告

## 输出报告
```
## umrelease 报告
### 版本与变更范围（含版本风格/CalVer 链决策）
### CI dry-run 证据（构建/测试/产物）
### Release Notes（全文）
### 安全审计证据（Critical/High=0）
### tag（hash + 名称）与发布状态
### 硬编码同步清单
### 人工确认记录（Q1 版本 + Q2 发布范围 + Q3 效力 + 选项）
### ⚠️ 状态: RELEASED / TAG_ONLY / BLOCKED
```
