# 必要测试覆盖评估

调用 skill：`test-scenarios`（用例设计）/ 语言对应测试 skill（`javascript-testing-patterns`、`python-testing-patterns`、`vue-testing-best-practices` 等）

## 流程

1. 对照 Phase 1 变更清单，列出每个行为变更
2. 对每个变更评估：现有测试是否覆盖？缺什么？

## 必要覆盖标准（最小集）

每个行为变更至少覆盖：

- **Happy path**：有效输入 → 预期结果
- **边界**：空 / 最大长度 / 0 / null / 并发
- **错误路径**：非法输入 → 明确错误（类型 + 信息）
- **回归**：修复类变更必须有"先复现失败"的测试

## 补测纪律（TDD）

1. **RED**：先写失败测试，运行，记录断言错误信息（证明为正确原因失败，非语法/导入错误）
2. **GREEN**：最小实现使其通过，记录通过输出
3. **SURFACE**：真实表面验证（curl / CLI / 浏览器实测）
4. **REGRESSION**：全量套件重跑确认全绿

## 测试质量检查

- [ ] 测试测行为（输出/状态），不测实现细节
- [ ] 测试名描述行为（`returns 400 for invalid email` 而非 `test2`）
- [ ] 无只覆盖 happy path 的缺口
- [ ] 测试可维护（无 sleep 竞态、无超时陷阱）

## 套件运行

```bash
# 按项目实际 runner（示例）
bun test     # 或 npm test / cargo test / pytest / vitest
```

- 全绿才通过门禁
- 预存在失败**单独列出**并标注"非本次引入"，不混入本次结果

## 报告

```
行为变更 → 已有覆盖测试(id) → 缺失用例 → 新增测试(id) → RED→GREEN 证据路径
```
