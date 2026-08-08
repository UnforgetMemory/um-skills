# gitignore 全面覆盖审计

调用 skill：`gitignore-generator`（生成器辅助；本文档为审计执行规范）

## 目标

对**非项目源代码**（构建产物、缓存、环境、IDE、OS、本地数据）实现目录级/文件级全面覆盖。

## 优先级规则（硬性）

1. **目录级别优先**：`build/` `dist/` `node_modules/` `.cache/` `target/` `__pycache__/` — 忽略整个目录
2. 文件级别仅当无法目录化：`.env`（含真实密钥）、单文件配置、`*.log`
3. 精确匹配：`/build/`（根级）vs `build/`（任意层级）——按需选择
4. 路径分隔符统一 `/`，条目行尾无空格

## 覆盖分类清单（逐类核对）

| 类别 | 典型条目（目录级优先） |
|---|---|
| 构建输出 | `dist/` `build/` `out/` `target/` `*.o` `*.class` |
| 依赖与缓存 | `node_modules/` `.cache/` `.pytest_cache/` `.gradle/` `__pycache__/` |
| 环境与密钥 | `.env` `.env.local` `.env.*.local` `*.pem` `*.key` |
| IDE | `.idea/` `.vscode/` `*.iml` |
| OS | `.DS_Store` `Thumbs.db` `*.swp` `*~` |
| 测试产物 | `coverage/` `.coverage` `playwright-report/` `test-results/` |
| 本地数据 | 项目约定的本地目录（如 `.localref/`）、本地 DB 副本 |

> 注：锁文件（`package-lock.json` / `Cargo.lock` 等）按项目策略决定，通常**提交**，不属于本清单。

## 审计步骤

1. `git status --ignored` 查看当前忽略状态，找出**未忽略**的非源代码产物
2. `git status --porcelain` 检查应忽略却被跟踪/未跟踪的产物
3. `git ls-files | grep -E "<产物模式>"` 发现已被跟踪的产物 → 需人工确认后 `git rm --cached`（**不自动执行**）
4. 补充规则 → 逐条验证：`git check-ignore -v <path>` 返回命中规则即通过
5. 负向例外按需：先忽略目录再放行个别文件（`!keep.me`）

## 验证门禁

```bash
# 所有非源代码产物必须命中规则；未命中的路径列出后补规则
git check-ignore -v build/ dist/ node_modules/ .env .DS_Store 2>&1
```

每个补入条目记录证据：`git check-ignore -v` 输出的命中路径 + 规则行号。

## 输出

```
新增规则: <pattern> — 命中: <path>（check-ignore 证据）
已跟踪产物: <path> — 建议: git rm --cached（待人工确认）
```
