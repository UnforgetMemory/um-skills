# gh Release 工作流

调用 skill：`changelog-automation` / `conventional-commits`（完整规范以该 skill 为准，本文档为 `gh release create` 执行清单）

## 1. tag 生成

基于 version-management.md 检测到的版本号或 Q1 确认结果，生成 SemVer tag：

```bash
# 验证 tag 格式
TAG="v${VERSION}"          # 如 v1.2.3
echo "${TAG}" | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?(\+[a-zA-Z0-9.]+)?$'

# 检查 tag 是否已存在（防止覆盖）
git tag -l "${TAG}" | grep -q "^${TAG}$" && echo "EXISTS: tag ${TAG} already exists" && exit 1
```

## 2. 创建 tag

```bash
# 从当前 HEAD 创建轻量 tag
git tag "${TAG}"

# 或从指定 commit 创建
git tag "${TAG}" <commit-hash>

# 验证
git tag --points-at HEAD
```

## 3. 生成 Release Notes

Release Notes 结构（专业、英文、简洁）：

```markdown
## Summary

One- or two-sentence overview of what this release delivers. Focus on user-visible value.

## Highlights

- Major feature A: brief description
- Performance improvement B: impact metric
- Bug fix C: what was fixed and why it matters

## Breaking Changes

List any breaking changes with migration notes. If none, state "None in this release."

## Known Issues

Any known issues in this release. If none, omit this section.

## Upgrade Guide

Any special steps required to upgrade. If standard deployment applies, state "Standard deployment process applies."
```

**禁止出现在 Release Notes 中的内容**：
- 内部 API 端点路径（`/api/v1/internal/...`）
- 内部 IP / 主机名
- 密钥 / token / 密码
- 内部实现的类名、函数名、模块路径
- 内部代码仓库引用
- 内部 Issue / PR 编号（除非公开）
- 内部 JIRA 或 Task ID
- 内部人员邮箱
- 数据库表名、字段名
- 配置文件路径

## 4. 发布（gh release create）

```bash
# 标准发布（自动推导 notes）
gh release create "${TAG}" \
  --title "${TITLE}" \
  --notes-file release-notes.md \
  --target "${BRANCH:-main}"

# Prerelease（预发布）
gh release create "${TAG}" \
  --title "${TITLE}" \
  --notes-file release-notes.md \
  --prerelease \
  --target "${BRANCH:-main}"

# Draft（草稿，不公开）
gh release create "${TAG}" \
  --title "${TITLE}" \
  --notes-file release-notes.md \
  --draft \
  --target "${BRANCH:-main}"

# 含资产上传
gh release create "${TAG}" \
  --title "${TITLE}" \
  --notes-file release-notes.md \
  --target "${BRANCH:-main}" \
  ./dist/*.tar.gz ./dist/*.zip

# 从 CHANGELOG 提取作为 Release Notes
# 提取 [X.Y.Z] 小节内容到临时文件后传入
```

## 5. 验证

```bash
# 查看发布详情
gh release view "${TAG}"

# 列出所有资产
gh release view "${TAG}" --json assets --jq '.assets[].name'

# 列出所有 releases
gh release list --limit 5 --json tagName,isLatest,createdAt
```

## 6. 回滚 / 修正

```bash
# 删除 release（不删除 tag）
gh release delete "${TAG}"

# 删除 tag（本地 + 远程）
git tag -d "${TAG}"
git push origin ":refs/tags/${TAG}"
```

## 7. 输出格式

```
## 发布摘要
Tag: v1.2.3
Target: main (abc1234)
Title: Release v1.2.3
Assets: dist/app.tar.gz (2.3MB)
Status: ✅ Published at https://github.com/owner/repo/releases/tag/v1.2.3
```