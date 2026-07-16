# 🔬 Research 工作流 & 📄 ADR

## Research 工作流

遇到未知技术：**禁止直接编码**。

必须创建 `Research Issue`，流程如下：

```
Research
    ↓
Experiment
    ↓
Decision
    ↓
ADR
    ↓
Implementation
```

### Research Phase
- 收集官方文档、官方仓库、标准规范
- 构建实验性 PoC（原型验证）
- 记录发现与结论

### Decision Phase
- 基于实验数据做技术选型
- 记录 trade-off 分析
- 明确决定

### ADR Phase
- 将决定写入 ADR（架构决策记录）

---

## 📄 ADR 规范

任何有长期影响的决定，**必须记录 ADR**。

### 必须记录 ADR 的场景
- 技术栈选型（框架、语言、数据库）
- 架构模式选择（MVVM、MVI、Clean Architecture）
- 跨模块接口协议
- 第三方服务集成
- 构建系统变更

### 示例 ADR 列表

```
ADR-001  Why KMP
ADR-002  Why Compose Multiplatform
ADR-003  Why PlayerEngine
ADR-004  Why Provider Architecture
```

### ADR 模板

```
# ADR-{NNN}: {标题}

## 状态
[Proposed | Accepted | Deprecated | Superseded]

## 背景
为什么要做这个决定？

## 决策
我们选择了什么？

## 理由
为什么这样选？替代方案为什么不选？

## 影响
这个决定会带来什么影响？
```

---

## 🌐 信息原则（硬约束）

**优先级**（严格降序）：

1. 官方文档
2. 官方仓库
3. 标准规范（RFC、ISO、W3C）
4. 权威技术资料（论文、知名技术博客）

**禁止**：
- 猜测 API 行为
- 基于无依据经验做假设
- 伪造不存在的 API 或参数

**标注规范**：所有结论必须标记来源类型：

| 标记 | 含义 |
|------|------|
| `Fact` | 来自官方文档/可验证事实 |
| `Assumption` | 合理推测，未验证 |
| `Decision` | 团队决定的技术选择 |
