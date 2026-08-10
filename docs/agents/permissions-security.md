# 权限与安全 / Permissions and Security

> [!NOTE]
> **教程阶段 / Guide stage:** V0.3 · 受控 Coding Agent / Controlled Coding Agents
> **阅读范围 / Reading range:** 第 07–08、11 章 + Agent 专题 / Chapters 07–08 and 11 + Agent section
> **前置内容 / Prerequisite:** 先理解 V0.2 的 API 与凭据边界；所有实验只在隔离 Agent Lab 中运行。 / Understand V0.2 API and credential boundaries; run experiments only in the isolated Agent Lab.

[中文](#中文) | [English](#english)

## 中文

最小权限基线：只打开 `.agent-runtime/<agent>`；默认不联网；需要写入时仅允许工作区；破坏性命令、目录外读取、安装软件、登录、提交和推送必须单独审批。不要把整个 `C:\`、`D:\`、用户目录、SSH 目录、浏览器资料、其他仓库或密钥目录交给 Agent。

模型服务网络与工具网络不同：Agent 为调用云模型需要访问 Provider，不等于它的 Shell 可以自由下载、搜索或访问局域网。教程实验不需要工具网络。

旧 Open WebUI `:3000` 不属于 Agent Lab：禁止 Agent 调用它、扫描其数据库、读取 Docker Volume、搜索其 Credential 或修改其容器。该实例的 LAN 暴露作为独立安全维护项保留，不阻塞隔离的 V0.3/V0.4 RC 验证。

永远不要使用 `--dangerously-skip-permissions`、`--yolo` 或同类跳过审批选项。不要截图登录页、邮箱、头像、套餐、Key、Token 或本机完整路径。发现异常立即停止 Agent，检查 `git status`、`git diff` 和进程，再撤销凭据。

## English

Least-privilege baseline: open only `.agent-runtime/<agent>`, deny tool-network access by default, allow writes only inside that workspace, and separately approve destructive commands, out-of-scope reads, installs, authentication, commits, and pushes. Never expose whole drives, the home directory, SSH/browser profiles, unrelated repositories, or credential stores.

Provider connectivity is not shell connectivity. An agent may need the model API while its tools remain offline. Never use permission-bypass or “yolo” modes. Stop on unexpected behavior, inspect status/diff/processes, and rotate affected credentials.

The legacy Open WebUI on port 3000 is outside the Agent Lab. Agents must not call it, inspect its database or volume, search its credentials, or modify its container. Its LAN exposure remains independent security maintenance and does not block isolated V0.3/V0.4 RC validation.

---

### 教程导航 / Guide navigation

[← 上一篇：Agent 心智模型 / Previous: Agent mental model](agent-mental-model.md) | [教程首页 / Guide home](../../README.md) | [下一篇：Claude Code / Next: Claude Code →](claude-code.md)
