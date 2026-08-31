# 恢复点与 git 恢复手册

> 与 `destructive-ops-gates.md` 配套：破坏性操作前建恢复点，误操作后按本手册恢复。
> 恢复点成本升序：R1 哈希锚点 < R2 工作区快照 < R3 文件备份。够用即可，不过度。

## 恢复点类型

| 类型 | 建立方式 | 适用 |
|------|---------|------|
| R1 哈希锚点 | `git rev-parse HEAD` 记录当前 HEAD | 所有 D1-D3，零成本 |
| R2 工作区快照 | `git stash push -u -m "pre-<op>"`（含未跟踪） | D2/D3 前工作区不干净时 |
| R3 文件备份 | 复制未跟踪内容到 `.um.agents/tmp/`（已 gitignore） | D3 目录删除中的未跟踪文件 |

## 触发规则

- D1：R1 必做
- D2：R1 必做；工作区不干净 → R2
- D3：R1 + 未跟踪内容 R3；目录删除前 R2

## 恢复命令表

| 场景 | 恢复 |
|------|------|
| 误改/误删已跟踪文件 | `git restore <path>` / `git checkout -- <path>` |
| 误删目录（已跟踪） | `git checkout -- <dir>` |
| 误删未跟踪文件 | 从 R3 备份还原；无备份 = 不可恢复 |
| 误 reset --hard | `git reflog` 找哈希 → `git reset --hard <hash>`（再次破坏性，先记录当前哈希） |
| 误 push --force | 与协作者确认后用 reflog 旧哈希回推 |
| 版本文件改错 | `git diff <R1哈希> -- <file>` 对照还原 |

## 验证

- 恢复点建立后立即抽查存在性（`git rev-parse HEAD` 输出、备份文件存在）。
- 恢复后：构建/测试 + `git status` 干净确认。
