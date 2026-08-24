# gh Release 工作流

前置门禁：发布前必须通过对应栈的 CI dry-run（见 ci-*.md）与安全审计（见 security-audit.md）。

## 1. Tag 创建与验证

基于版本检测结果生成 SemVer tag（格式规则见 version-tag.md）：

```text
# validate tag format (abort if invalid; forbid +build metadata)
TAG="v${VERSION}"          # e.g. v1.2.3
echo "${TAG}" | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?$' || exit 1

# fail if tag already exists (prevent overwrite)
git tag -l "${TAG}" | grep -q "^${TAG}$" && echo "EXISTS: tag ${TAG} already exists" && exit 1

# create from current HEAD or a specific commit
git tag "${TAG}"
git tag "${TAG}" <commit-hash>

# verify: resolves for any commit (do NOT use --points-at HEAD for non-HEAD tags)
git rev-parse "${TAG}"        # outputs the commit hash the tag points to
git tag -l "${TAG}"           # list the tag
```

## 2. gh release create

```text
# standard release (notes pre-generated and audited, passed via --notes-file)
gh release create "${TAG}" \
  --title "${TITLE}" \
  --notes-file release-notes.md \
  --target "${BRANCH:-main}"

# prerelease
gh release create "${TAG}" \
  --title "${TITLE}" --notes-file release-notes.md --prerelease \
  --target "${BRANCH:-main}"

# draft (not public)
gh release create "${TAG}" \
  --title "${TITLE}" --notes-file release-notes.md --draft \
  --target "${BRANCH:-main}"

# with asset upload
gh release create "${TAG}" \
  --title "${TITLE}" --notes-file release-notes.md \
  --target "${BRANCH:-main}" \
  ./dist/*.tar.gz ./dist/*.zip
```

- 也可从 CHANGELOG 提取 `[X.Y.Z]` 小节内容到临时文件后传入 `--notes-file`

## 3. 验证

```text
gh release view "${TAG}"                                   # view release details
gh release view "${TAG}" --json assets --jq '.assets[].name'  # list all assets
gh release list --limit 5 --json tagName,isLatest,createdAt
```

## 4. 回滚 / 修正

```text
gh release delete "${TAG}"           # delete release (keeps tag)
git tag -d "${TAG}"                  # delete local tag
git push origin ":refs/tags/${TAG}"  # delete remote tag
```

## 5. 输出格式

```text
## 发布摘要
Tag: v1.2.3
Target: main (abc1234)
Title: Release v1.2.3
Assets: dist/app.tar.gz (2.3MB)
Status: ✅ Published at https://github.com/owner/repo/releases/tag/v1.2.3
```
