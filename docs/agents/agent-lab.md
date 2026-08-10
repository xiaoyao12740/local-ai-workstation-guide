# Agent Lab 实战 / Controlled Agent Lab

[中文](#中文) | [English](#english)

## 中文

### 目标

让 Claude Code 或 Codex 在独立副本里为统计函数增加中位数和测试，并证明没有修改授权范围外的文件。

### 步骤

1. 在仓库根目录运行 `prepare-agent-lab.ps1 -Agent claude` 或 `-Agent codex`。
2. 进入对应 `.agent-runtime` 子目录；确认提示符不是仓库根目录或用户目录。
3. 按对应客户端章节启动 Agent，并让它读取 `AGENT_TASK.md`。
4. 审批只限 `src/`、`tests/` 和标准库测试命令。
5. 返回仓库根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify-agent-lab.ps1 -Agent codex
```

成功现象：测试通过；返回值含 `median`；Git 变更只位于 `src/` 与 `tests/`；没有安装、联网、提交或推送。

## English

The lab asks one agent to add median support and tests in its own disposable copy. Prepare either the `claude` or `codex` workspace, launch the client only there, approve only `src/`, `tests/`, and standard-library test commands, then run the verifier shown above (change the agent name when needed).

Success means all tests pass, `median` exists, all changes are limited to `src/` and `tests/`, and no package, network, commit, or push operation occurred.
