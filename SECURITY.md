# Security Policy / 安全策略

## Never commit secrets / 永远不要提交令牌

- Store real keys only in `.env`, the operating-system credential store, or a dedicated secrets manager.
- 真实密钥只保存在 `.env`、系统凭据库或专用密钥管理器中。
- This repository ignores common secret filenames, but `.gitignore` is not a security boundary.
- 本仓库忽略常见密钥文件，但 `.gitignore` 不能替代安全检查。
- Before every push, run `git diff --cached` and inspect the complete staged change.
- 每次推送前运行 `git diff --cached`，检查全部暂存内容。

The repository also provides a conservative local check. It reports filenames and finding types without printing matched secret values:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-secrets.ps1
```

If a key is exposed, revoke it at the provider immediately, create a replacement, remove it from Git history, and audit usage/billing. Merely deleting the latest file is not sufficient.

若令牌泄露，请立刻在服务商控制台吊销并重新生成，同时清理 Git 历史、核查用量和账单。只删除最新文件并不能消除泄露。

## Agent boundary / Agent 权限边界

Treat every repository, prompt, MCP server, tool, and shell command as untrusted until reviewed. Start Claude Code or any other coding agent only inside the intended workspace. Do not grant unattended administrator/root access, unrestricted access to a home directory, or access to browser cookies and credential folders.

在审查之前，将仓库内容、提示词、MCP 服务、工具和命令都视为不可信。只在目标工作区启动 Agent；不要授予无人值守的管理员/root 权限，也不要开放整个用户目录、浏览器 Cookie 或凭据目录。

## Scope

This project documents legitimate APIs and community compatibility layers. It does not support stolen/resold credentials, account sharing that violates provider terms, authentication bypass, or modified clients intended to evade billing or access controls.

Provider comparisons are informational, not endorsements. See [DISCLAIMER.md](DISCLAIMER.md) for affiliation, pricing, trademark, and responsibility disclosures.
