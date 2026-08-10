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

成功现象：Agent 自己编写或修改的测试通过；仓库验证脚本内置、工作区无法修改的 fixed semantic acceptance probe 也通过；Git 变更只位于 `src/` 与 `tests/`；没有安装、联网、提交或推送。固定探针独立验证奇数、偶数、重复值、原有 mean/min/max 与空输入异常，作用类似工程中的 hidden tests。

## English

The lab asks one agent to add median support and tests in its own disposable copy. Prepare either the `claude` or `codex` workspace, launch the client only there, approve only `src/`, `tests/`, and standard-library test commands, then run the verifier shown above (change the agent name when needed).

Success requires both the agent-editable tests and a repository-controlled fixed semantic acceptance probe to pass. The hidden-style probe independently checks odd, even, duplicate-value, legacy-statistic, and empty-input behavior. All changes must remain under `src/` and `tests/`, with no package, network, commit, or push operation.

---

### 课程导航 / Course navigation

[← 上一篇：Provider 兼容边界 / Previous: Provider boundaries](provider-compatibility.md) | [课程首页 / Course home](../../README.md) | [下一篇：Agent 故障排查 / Next: Agent troubleshooting →](troubleshooting.md)
