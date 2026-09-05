# uma 记忆协议（L2 — 区域 wiki 八爪鱼）

> 基础格式（时间戳模板/目录/分级）唯一事实源：[project-memory.md](project-memory.md)；
> 本文只定义 uma 专有规则，不重复基础规则。

## 1. 定位：记忆 = 先验（prior），不是真相源（source of truth）
- 记忆页是「上一次分析时点」的历史快照（Snapshot），永远不是现在时
- 回答的证据永远来自当次会话的 read（文件:行）；记忆只负责：省掉重新发现结构地图的 token、指路（先看哪里）、漂移检测
- 三级结论状态：
  | 状态 | 含义 | 可否作为回答证据 |
  |------|------|-----------------|
  | `Live` | 当次会话 read 验证过的结论 | ✅ 唯一证据来源 |
  | `Snapshot` | 记忆页历史结论，gitRef 匹配但本会话未复验 | ❌ 仅导航/假设生成 |
  | `Advice` | 观点/建议类（如「推荐迁到 X 库」） | ❌ 只能作建议方向，且受时间戳失效约束 |
- 每次回答前把相关 Snapshot 假设清单逐条转 Live：read 取证后才可进入答案正文

## 2. 存储布局（<projectRoot>/.um.agents/memory/uma/）
```
uma/
├── index.local.md            ← 区域索引（region → 页面 + gitRef + updatedAt）
├── <region>.local.md         ← 每区域一页（region = 路径 slug，如 src-auth）
└── locks/                    ← 区域写锁（瞬时）
```
- 全部 `.local.md`：个人分析缓存，不 sync（.gitignore 已含 memory/）
- 需团队共享的结论 → 按 project-memory.md 分级规则晋升 constraints/（人工确认）
- 门禁豁免：本区位于 gitignore 内，写操作免 prohibitions.md 门禁 D0-D3 分级；删除记忆页仍须人工确认
- 局限（显式承认）：页面是 agent-local 历史点；跨会话/跨 agent 锁不生效，
  仅靠 gitRef 漂移检测兜底；跨 agent 共享知识只能走 constraints/ 晋升

## 3. 页面文件头（有效期标记）
```
<!--
createdAt: YYYY-MM-DD HH:mm:ss +08:00 (来源)   ← project-memory.md 模板
updatedAt: YYYY-MM-DD HH:mm:ss +08:00 (来源)
gitRef: <sha>                    ← 本区域最近一次变更 commit
regionPaths: <path1> <path2>     ← 本页覆盖的路径集合
-->
```
- 时间戳只取实时锚点（base-constraints「时间与最新语义」），禁止猜测
- 页面正文分区：`事实（Fact）` 区受 gitRef 驱动；`建议（Advice）` 区受 updatedAt 驱动

## 4. 过时判定（读取时实时比对）
1. git 项目：`git log -1 --format=%H -- <regionPaths>` vs 页内 `gitRef`
   - 相等 → FRESH：区域未变，历史结论可作**先验**（结构地图/导航），具体断言仍需当次复验
   - 不等 → STALE：仅重析该区域 → 回写页 + index + 新 gitRef
   - 无页 → MISSING：全新分析
2. 非 git 项目：回退 project-memory.md 时间戳规则（updatedAt 距今 > 90 天视为可能过期，采信前询问）
3. 建议区双轨失效：gitRef 相等 ≠ Advice 仍成立（外部生态会变）→ Advice 区按 updatedAt 90 天阈值复核
4. 内容无实质变化 → 不写（禁止为刷 updatedAt 而写）

## 5. 区域锁（防多 agent 同区域并发写）
- 写前：独占创建 `locks/<region>.lock`（内容：owner + 获取时间锚点）；创建失败 = 已锁
- 已锁：放弃本轮写入并上报冲突（禁止等待/强写/覆盖他人页）
- 写完：立即删除锁文件
- 陈旧锁（创建时间 > 30 分钟）：检查 owner 存活（subagent 状态）→ 确认死亡才可接管
- subagent 分派：区域两两不相交；每个 subagent 只写自己区域的页，index 由主 agent 汇总写

## 6. 八爪鱼纪律（变更感知的按需刷新 · 准实时 · 不乱动）
- 按需滚动：只读取本次分析涉及的区域页，禁止全量加载
- 无变更不动：FRESH 区域零写入
- 不频繁动：一次会话同一区域至多回写一次
- 现在时永远来自代码：报告结论必须标 Live / Snapshot / Advice，未复验项禁止进入答案正文
