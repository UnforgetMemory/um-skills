# 简洁英文注释规范

## 原则

1. 注释解释 **WHY**（决策原因、边界、陷阱），不重复 **WHAT**（代码本身已表达）
2. 语言：**英文**（代码库统一语言，禁止中文注释）
3. 简洁：一行或极短块；能用命名表达就不加注释
4. 只为**非显然**逻辑补充；明显代码加注释 = 噪音

## 何时必须加

| 场景 | 示例 |
|---|---|
| 非显然的决策 | `// retry once; server returns 503 on cold cache` |
| 边界 / 魔数 | `// max 5MB — matches nginx client_max_body_size` |
| 陷阱 | `// do NOT reorder: tx must commit before notification` |
| 复杂算法策略 | 一句话说明算法选择及原因 |
| 兼容 / 迁移原因 | `// legacy clients send null here; keep default` |

## 何时禁止

- ❌ 明显代码的注释（`// increment i`）
- ❌ 中文注释（违反统一语言纪律）
- ❌ 噪音注释（无上下文的 `// TODO: fix later`、重复文件名的块注释）
- ❌ 被注释掉的代码（删除而非注释；需要时用 git 历史找回）
- ❌ 大段描述函数"做什么"的冗余块注释

## 格式

```typescript
// WHY-only, sentence case, one line when possible
const timeout = 30_000; // 30s: matches upstream API limit
```

- 行内注释与代码对齐风格一致
- 英文语法正确、术语准确
- 修改代码时必须同步更新相关注释（过期注释 = bug）

## 审查检查

- [ ] 新增注释全部为英文
- [ ] 每条注释解释 WHY 而非重复 WHAT
- [ ] 无噪音 / 无被注释掉的代码
- [ ] 注释与实际行为一致
