
# umrelease — 发布专业（CI 门禁 · Release · gh CLI）

## 链路位置
- 前置：umcommit（tag 应指向已提交版本）；跳过时需确认版本一致性
- 后继：无
- 并行：umreview（发布前审查）

## 前置路由（最小集，先读）
1. read `references/base-constraints.md`（元约束，必须）
2. read `references/environment-routing.md` → 环境 → `adapters/<env>/tools.md`（会话内一次）
3. 其余 L0 延迟加载：`references/context-adaptation.md` 到 Phase 0 档位自检；`references/project-memory.md` 到 P0/P9 记忆读取；`references/decision-panel.md` 到 P4 版本确认

## 核心定位
一次调用完成发布。**CI dry-run 未通过禁止创建 tag/发布；Notes 发布前必须人工确认。**

## 硬性纪律
1. CI dry-run 门禁未过 → 禁止 tag/发布
2. Notes 发布前展示确认；禁止暴露内部接口/实现细节
3. Notes 专业、简洁、英文
4. 版本决策按 `references/decision-panel.md` 智能适配（SemVer/CalVer/自定义）

## 执行管线（路由表）

| Phase | 做什么 | read（按需） | 工具 | 决策点 |
|-------|--------|-------------|------|--------|
| P0 | 版本与范围采集：版本源检测 + 待发布变动 + gh 可用性 | references/version-detection.md | read/命令 | 版本源确认 |
| P1 | CI dry-run 门禁：按项目栈构建+测试+产物验证，**不发布** | references/ci-*.md（按栈选 1 个） | 构建命令 | 失败→修复重跑 |
| P2 | Release Notes 生成：git log 分类映射 | references/changelog.md · references/conventional-commits.md | 文件工具 | 结构定稿 |
| P3 | Notes 安全审计：内部泄露扫描 | references/security-audit.md | grep/命令 | Critical/High→阻断 |
| P4 | 版本确认：面板 Q1（风格匹配选项 + CalVer 链） | references/decision-panel.md | 交互工具 | 目标版本 |
| P5 | 创建 tag：SemVer vX.Y.Z / CalVer YYYY.MM.DD[.HHMM[.NN]]；验证 | references/version-tag.md | 命令 | tag 冲突检查 |
| P6 | Notes 展示 + 发布确认：面板 Q2 | — | 交互工具 | 显式确认 |
| P7 | 发布：gh release create（标准/prerelease/draft/assets） | references/release-gh.md | 命令 | exit 0 |
| P8 | 验证：gh release view 确认可见+资产 | references/release-gh.md | 命令 | 核对 |
| P9 | 硬编码联动：按索引同步发布版本号 → 回写索引 | references/project-memory.md | 文件工具 | 索引核对 |

## 决策面板（一次交互）
```
Q1 版本确认：按项目风格只给匹配选项（SemVer/CalVer 含时间戳+随机位链/自定义/沿用）
Q2 发布确认：[发布, 仅打 tag 不发布, 修改 Notes]（依赖 Q1 结果）
```

## 验证门禁
1. P1：CI dry-run 全绿（构建 exit 0 + 测试过 + 产物存在）
2. P3：Notes 扫描零 Critical/High
3. P5：tag 创建成功（git tag --points-at HEAD）
4. P7：gh release create exit 0
5. P8：gh release view 确认 Release + 资产
6. P9：硬编码索引同步完成

## 输出报告
```
## umrelease 报告
### 版本与变更范围（含版本风格/CalVer 链决策）
### CI dry-run 证据（构建/测试/产物）
### Release Notes（全文）
### 安全审计证据（Critical/High=0）
### tag（hash + 名称）与发布状态
### 硬编码同步清单
### ⚠️ 状态: RELEASED / TAG_ONLY / BLOCKED
```
