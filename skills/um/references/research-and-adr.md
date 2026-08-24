# 调研工作流与 ADR

## 调研工作流

遇到未知技术：**禁止直接写代码。** 创建 Research Issue 并遵循：

```
Research → Experiment → Decision → ADR → Implementation
```

### 调研阶段
- 收集官方文档、官方仓库、标准/规范
- 构建实验性 PoC（原型验证）
- 记录发现与结论

### 决策阶段
- 基于实验数据选择技术
- 记录权衡分析
- 明确做出决策

### ADR 阶段
- 将决策写入 ADR（Architecture Decision Record，架构决策记录）

## ADR 规则

任何有长期影响的决策**必须**记录为 ADR。

### 必须记录 ADR
- 技术栈选型（框架、语言、数据库）
- 架构模式选择（MVVM、MVI、Clean Architecture）
- 跨模块接口协议
- 第三方服务集成
- 构建系统变更

示例列表：
```
ADR-001  Why KMP
ADR-002  Why Compose Multiplatform
ADR-003  Why PlayerEngine
ADR-004  Why Provider Architecture
```

### ADR 模板

```
# ADR-{NNN}: {Title}

## Status
[Proposed | Accepted | Deprecated | Superseded]

## Context
Why is this decision being made?

## Decision
What did we choose?

## Rationale
Why this option? Why not the alternatives?

## Consequences
What impact does this decision have?
```

## 信息原则（硬约束）

严格优先级顺序：

1. 官方文档
2. 官方仓库
3. 标准/规范（RFC、ISO、W3C）
4. 权威技术资料（论文、知名技术博客）

禁止：
- 猜测 API 行为
- 基于无依据经验的假设
- 编造不存在的 API 或参数

### 来源标注 —— 每个结论都必须标记

| 标记 | 含义 |
|--------|---------|
| `Fact` | 来自官方文档 / 可验证的事实 |
| `Assumption` | 合理推断，未经验证 |
| `Decision` | 团队选定的技术方案 |
