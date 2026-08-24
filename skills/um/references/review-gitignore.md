# gitignore 全覆盖审计

## 目标

对**非源代码产物**实现完整的目录/文件级覆盖：构建输出、缓存、环境、IDE、OS、本地数据。

## 优先级规则（硬性）

1. **目录级优先**：`build/` `dist/` `node_modules/` `.cache/` `target/` `__pycache__/` —— 忽略整个目录
2. 仅当目录无法覆盖时才用文件级：`.env`（含真实密钥）、单文件配置、`*.log`
3. 精确匹配：`/build/`（仅仓库根）与 `build/`（任意深度）——按需选择
4. 路径分隔符 `/`，条目末尾无空白

## 覆盖类别（逐类检查）

| 类别 | 典型条目（优先目录级） |
|----------|---------------------------------------------|
| 构建输出 | `dist/` `build/` `out/` `target/` `*.o` `*.class` |
| 依赖与缓存 | `node_modules/` `.cache/` `.pytest_cache/` `.gradle/` `__pycache__/` |
| 环境与密钥 | `.env` `.env.local` `.env.*.local` `*.pem` `*.key` |
| IDE | `.idea/` `.vscode/` `*.iml` |
| OS | `.DS_Store` `Thumbs.db` `*.swp` `*~` |
| 测试产物 | `coverage/` `.coverage` `playwright-report/` `test-results/` |
| 本地数据 | 项目约定的本地目录（如 `.localref/`）、本地数据库副本 |

注意：锁文件（`package-lock.json` / `Cargo.lock` 等）遵循项目策略——通常**提交**；不在此清单内。

## 审计步骤

1. `git status --ignored` —— 查看当前忽略状态；找出**未被忽略**的非源码产物
2. `git status --porcelain` —— 找出应被忽略但仍被跟踪/未跟踪的产物
3. 在跟踪文件中搜索产物模式（`git ls-files` + 模式匹配）→ 若找到，建议 `git rm --cached` 并等待**人工确认**（绝不自动执行）
4. 添加规则 → 逐条验证：`git check-ignore -v <path>` 返回匹配
5. 需要时使用否定例外：忽略目录后无法放行其内文件（git 不会进入已忽略目录）→ 改用 `dir/*` + `!dir/keep.me`

## 验证门禁

```
All non-source artifacts must match a rule; any unmatched path → add a rule.
Run: git check-ignore -v <paths>   → every path must resolve to a rule + line number.
```

为每条新增规则记录证据：来自 `git check-ignore -v` 的匹配路径和规则行号。

## 输出

```
New rule: <pattern> — matches: <path> (check-ignore evidence)
Tracked artifact: <path> — suggest: git rm --cached (await human confirmation)
```
