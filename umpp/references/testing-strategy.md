# 🧪 测试策略

## 测试金字塔

```
          UI Test
             10%

        Store Test
             20%

     Scenario Test
             40%

     Provider Test
             30%
```

禁止 Provider API → UI 测试的跳跃。

## 外部 API 测试规则

针对风控 API、OAuth、Cookie、Token、Signature 等不稳定外部依赖：

必须采用 **分层测试策略**：

### Mock

用于测试 **业务逻辑**。使用模拟数据隔离外部依赖。

### Fixture

保存 **真实响应** 作为测试数据：

```
fixtures/
  bilibili/
    login-request.json
    login-response.json
    login-error-case.json
```

### Contract Test

保证 Provider 符合 **内部领域契约**（Interface 定义）。

- Provider 实现必须通过契约测试
- 契约测试运行在 CI 中
- 契约变更必须同步更新所有实现

### Integration Test

验证 **真实世界** 交互。

- 低频执行（每日/每周）
- 需要真实凭据
- 失败时自动创建 Issue

### Real API Smoke Test

生产环境健康检查：

- 部署后自动触发
- 核心 API 路径可用性验证
- 认证流程端到端验证
