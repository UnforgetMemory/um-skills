# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **umreview skill** — automated pre-merge code review and hygiene pipeline:
  - Multi-axis code review (correctness / readability / architecture / security / performance) with severity-labeled findings (`Critical:` / `Nit:` / `Optional:` / `FYI`)
  - Necessary concise English comments (WHY-only, no noise, no commented-out code)
  - Security audit with secrets scanning (`git diff` / `git grep` key-prefix patterns), trust boundaries, SSRF, and dependency audit
  - Comprehensive `.gitignore` coverage audit for non-source artifacts — directory-level rules preferred, verified via `git status --ignored` and `git check-ignore -v`
  - Required test coverage assessment with RED → GREEN → SURFACE discipline
  - Cleanup of outdated tests (list first, human-confirmed deletion only), leftover test processes, and build artifacts
  - Hard rule: never auto-commit or push — every change is left uncommitted for manual review
- **README**: skills table entry for the umreview skill
- **umcommit skill** — automated CHANGELOG / commit / push pipeline:
  - Security-audited CHANGELOG generation via `changelog-automation` (Keep a Changelog classification mapping + versioned release flow)
  - Security-audited conventional commit messages via `conventional-commits` (atomic commit groups, `--signoff`, AI-attribution footer)
  - Dual security audit via `security-and-hardening`: CHANGELOG text scan + staged diff/message scan with Critical/High Hard Block
  - Version detection (package.json / pyproject.toml / Cargo.toml / build.gradle / pubspec.yaml / VERSION) with mandatory major/minor/patch upgrade question and computed target version
  - Hard rules: commit content always shown for confirmation first; push only after explicit user approval
- **README**: skills table entry for the umcommit skill
