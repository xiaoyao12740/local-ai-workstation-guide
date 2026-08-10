# Claude Code 安全接入 / Safe Claude Code Setup

[中文](#中文) | [English](#english) · Last verified: 2026-08-10

## 中文

本机验证版本为 `claude 2.1.143`，版本会变化，请先运行 `claude --version`、`claude --help` 与 `claude doctor`。官方路线使用 Anthropic 或其文档列出的 Claude 云来源；登录与计费以当前官方页面为准。

阿里云百炼的 Anthropic-compatible Coding Plan/接口是 Provider 支持的兼容路线，Key 类型与 Endpoint 必须匹配。只在当前 PowerShell 临时设置凭据，先测试再决定是否持久化；不要把真实值写入 `.claude/settings.json`。项目本地私有设置应放在被忽略的 `.claude/settings.local.json`。

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\prepare-agent-lab.ps1 -Agent claude
Set-Location .\.agent-runtime\claude
claude
```

把 `AGENT_TASK.md` 交给 Claude Code，逐项审批文件读取、修改和测试；拒绝联网、安装、目录外访问、提交或推送。完成后返回仓库根目录运行验证脚本。没有 Anthropic 或合法兼容凭据时，本章保持 Documentation only，不构成失败。

## English

The locally inspected version is `claude 2.1.143`; always re-check `claude --version`, `claude --help`, and `claude doctor`. The vendor route uses Anthropic or documented Claude cloud sources. Alibaba Model Studio's Anthropic-compatible route is provider-supported compatibility, not Anthropic endorsement; key type and endpoint must match.

Prepare the `claude` lab with the commands above, launch only inside that directory, submit `AGENT_TASK.md`, and approve actions individually. Deny network, installs, out-of-scope access, commits, and pushes. Without a lawful credential, record this route as documentation-only.

## Official references / 官方资料

- [Claude Code setup](https://docs.anthropic.com/en/docs/claude-code/getting-started)
- [Claude Code CLI reference](https://docs.anthropic.com/en/docs/claude-code/cli-usage)
- [Anthropic LLM gateway configuration](https://docs.anthropic.com/en/docs/claude-code/llm-gateway)
- [Alibaba Cloud Model Studio third-party coding tools](https://help.aliyun.com/en/model-studio/more-tools)

---

### 课程导航 / Course navigation

[← 上一篇：权限与安全 / Previous: Permissions and security](permissions-security.md) | [课程首页 / Course home](../../README.md) | [下一篇：Codex / Next: Codex →](codex.md)
