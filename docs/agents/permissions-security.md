# 权限与安全 / Permissions and Security

[中文](#中文) | [English](#english)

## 中文

最小权限基线：只打开 `.agent-runtime/<agent>`；默认不联网；需要写入时仅允许工作区；破坏性命令、目录外读取、安装软件、登录、提交和推送必须单独审批。不要把整个 `C:\`、`D:\`、用户目录、SSH 目录、浏览器资料、其他仓库或密钥目录交给 Agent。

模型服务网络与工具网络不同：Agent 为调用云模型需要访问 Provider，不等于它的 Shell 可以自由下载、搜索或访问局域网。教程实验不需要工具网络。

永远不要使用 `--dangerously-skip-permissions`、`--yolo` 或同类跳过审批选项。不要截图登录页、邮箱、头像、套餐、Key、Token 或本机完整路径。发现异常立即停止 Agent，检查 `git status`、`git diff` 和进程，再撤销凭据。

## English

Least-privilege baseline: open only `.agent-runtime/<agent>`, deny tool-network access by default, allow writes only inside that workspace, and separately approve destructive commands, out-of-scope reads, installs, authentication, commits, and pushes. Never expose whole drives, the home directory, SSH/browser profiles, unrelated repositories, or credential stores.

Provider connectivity is not shell connectivity. An agent may need the model API while its tools remain offline. Never use permission-bypass or “yolo” modes. Stop on unexpected behavior, inspect status/diff/processes, and rotate affected credentials.
