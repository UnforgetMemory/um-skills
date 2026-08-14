# 简洁英文注释规范

## 原则

1. 注释解释 **WHY**（决策理由、边界、陷阱）——绝不复述 **WHAT**（代码本身已经说了）
2. 语言：**英文**（仓库统一；禁止非英文注释）
3. 简洁：一行或极短块；如果命名能表达，就不写注释
4. 只用于**非显而易见**的逻辑；显而易见的代码 + 注释 = 噪音

## 必须添加的场景

| 场景 | 示例 |
|----------|---------|
| 非显而易见的决策 | `// retry once; server returns 503 on cold cache` |
| 边界 / 魔法数字 | `// max 5MB — matches upstream limit` |
| 陷阱 / 顺序约束 | `// do NOT reorder: tx must commit before notification` |
| 复杂算法策略 | 一句话：所选算法及原因 |
| 兼容 / 迁移原因 | `// legacy clients send null here; keep default` |

## 禁止

- ❌ 显而易见的代码上的注释（`// increment i`）
- ❌ 非英文注释（违反语言纪律）
- ❌ 噪音注释（无上下文的 `// TODO: fix later`、重复文件名的块头）
- ❌ 被注释掉的代码（删除它；需要时从 git 历史恢复）
- ❌ 描述函数"做什么"的大段块注释

## 格式

```
// WHY-only, sentence case, one line when possible
const timeout = 30_000; // 30s: matches upstream API limit
```

- 行内注释与代码风格对齐
- 英文语法正确、术语准确
- **修改代码必须同步修改相关注释——过期注释就是 bug**

## 评审清单

- [ ] 所有新注释为英文
- [ ] 每条注释解释 WHY，而非 WHAT
- [ ] 无噪音 / 无被注释掉的代码
- [ ] 注释与实际行为一致
