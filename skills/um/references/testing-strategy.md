# 测试策略

## 测试金字塔

```
          UI Test        10%
        Store Test       20%
     Scenario Test       40%
      Provider Test      30%
```

禁止：从 Provider API 测试直接跳到 UI 测试（跳过中间层）。

## 外部 API 分层测试

对于不稳定的外部依赖（风控 API、OAuth、Cookie、Token、签名），采用分层策略：

### Mock
- 用模拟数据测试**业务逻辑**
- 隔离外部依赖

### Fixture
- 将**真实响应**保存为测试数据
- ```
  fixtures/
    bilibili/
      login-request.json
      login-response.json
      login-error-case.json
  ```

### Contract Test（契约测试）
- 保证 Provider 符合**内部领域契约**（接口定义）
- 每个 Provider 实现都必须通过契约测试
- 契约测试在 CI 中运行
- 契约变更时所有实现必须同步更新

### Integration Test（集成测试）
- 验证**真实环境**交互
- 低频运行（每日/每周）
- 需要真实凭证
- 失败时自动创建 Issue

### Real API Smoke Test（真实 API 冒烟测试）
- 生产健康检查
- 部署后自动触发
- 验证核心 API 路径可用性
- 端到端认证流程验证
