# 📋 GitHub Project 管理规范

GitHub Project 是 **软件生命管理系统**，不是 Todo List。

## 层级结构

```
Vision
    ↓
Roadmap
    ↓
Epic
    ↓
Issue
    ↓
Task
    ↓
Verification
```

## Issue 规范

**禁止**:
```
实现播放器   ← 过于模糊，无法执行
```

**必须**:
```
EPIC: Player System

Tasks:
- PlayerEngine 抽象
- Android 平台实现
- Desktop 平台实现
- 状态管理
- 错误恢复
- 字幕集成
```

## 状态流转

**禁止**: `Todo → Doing → Done`（过于简单，无法反映真实进度）

**使用**:

```
Backlog
    ↓
Ready
    ↓
Implementing
    ↓
Review
    ↓
Verified
    ↓
Done
```

## 完成定义 (`Done`)

代码完成 ≠ Done。

必须满足所有条件：

```
Code
    ↓
Test
    ↓
Review
    ↓
Documentation
    ↓
Verification
```

每一项都必须真实执行，不可跳步。
