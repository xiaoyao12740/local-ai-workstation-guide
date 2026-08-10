# 12. 最终验收：证明工作站真的可用

> [!NOTE]
> **教程阶段 / Guide stage:** 跨版本必读 · 安全、排错与验收 / Cross-version Safety, Troubleshooting, and Acceptance
> **阅读范围 / Reading range:** 主线第 09、10、12 章 / Main guide Chapters 09, 10, and 12
> **前置内容 / Prerequisite:** 适用于 V0.1–V0.4；完成所选路线后必须回到这些章节验收。 / Applies to V0.1–V0.4; return here to validate the route you completed.

最终目标不是“所有软件都安装过”，而是每层都有可复现证据。

## 1. Windows 与 WSL

```powershell
wsl --status
wsl --list --verbose
```

- [ ] 默认发行版是预期的 Ubuntu。
- [ ] VERSION 为 2。
- [ ] 知道项目放在 Windows 盘还是 Linux Home，以及为什么。

## 2. Docker

```powershell
docker version
docker info
docker compose version
```

- [ ] Client 与 Server 都正常。
- [ ] `hello-world` 验证成功。
- [ ] 能解释 Image、Container、Volume、Port、Network。

## 3. Ollama 与本地模型

```powershell
ollama list
ollama ps
Invoke-RestMethod http://127.0.0.1:11434/api/tags
```

- [ ] 至少一个适合当前硬件的小模型可运行。
- [ ] 命令行生成成功。
- [ ] HTTP API 生成成功。
- [ ] 没有伪造速度或显存数据。

## 4. Open WebUI

```powershell
docker compose ps
docker compose logs --tail 50 open-webui
```

- [ ] <http://localhost:3000> 可访问。
- [ ] 能看到 Ollama 模型并完成对话。
- [ ] 端口只绑定 `127.0.0.1`。
- [ ] 知道聊天数据保存在哪个 Volume。
- [ ] `down` 后重新 `up -d` 数据仍存在。

## 5. 云 API（可选；V0.1 不要求）

- [ ] 能解释 API 与网页会员的区别。
- [ ] 知道 Qwen API 在阿里云百炼开通，使用 DashScope Key。
- [ ] 知道 Claude、OpenAI、DeepSeek 的官方开通平台。
- [ ] 至少一个合法云 API 最小示例成功。
- [ ] 服务商控制台中能核对用量和费用。
- [ ] 没有把 Key 写入代码、日志、截图或 Git。

## 6. Coding Agent（可选；V0.1 不要求）

- [ ] 能解释模型、API、Agent 和工具层。
- [ ] 知道 Claude Code + Claude 与 Codex + OpenAI 是各自更原生的路线。
- [ ] 能区分 Codex 的 ChatGPT 登录权益与 API Provider Key/计费。
- [ ] 知道百炼 Coding Plan 接 Claude Code 与接 Codex 的协议和版本边界不同。
- [ ] 能把第三方路由标为社区兼容层，而非官方完美支持。
- [ ] 若使用 CCR，能区分 Provider Credential、CCR Client Key 与 Management Token。
- [ ] 在隔离 `hello-agent` 仓库完成代码、测试、修复和差异审查。
- [ ] 未授权 Agent 访问主目录、凭据或管理员权限。

## 7. 安全检查

```bash
git status --short
git diff --cached
```

- [ ] `.env` 被忽略，`.env.example` 只有空值/占位符。
- [ ] 未提交 `auth.json`、`.claude/`、`.codex/`、CCR 数据库或 CCR 导出备份。
- [ ] 无 `.gguf`、`.safetensors`、Volume、聊天记录和 WSL 磁盘。
- [ ] 知道 Key 泄露后必须先撤销和轮换。
- [ ] 云端数据发送符合授权和隐私要求。
- [ ] 了解 API 费用并设置预算/告警。

## 最终架构记录

学习者应填写自己的最终架构，不复制他人硬件结论：

| 项目 | 我的配置 |
| --- | --- |
| Windows 版本 |  |
| CPU / RAM |  |
| GPU / 可用显存 |  |
| WSL 发行版 |  |
| Docker / Compose |  |
| Ollama |  |
| 本地模型与量化 |  |
| Open WebUI |  |
| 已验证云 API |  |
| Coding Agent |  |
| 兼容路由（如有） |  |
| 数据与备份位置 |  |

## 合格标准

所有必需项都有命令输出或人工检查证据；任何依赖试用额度、社区路由或特定版本的内容都明确标注，不用“安装过”“应该可以”代替验证。

---

### 教程导航 / Guide navigation

[← 上一篇：Agent 实战 / Previous: Agent Lab](11-agent-lab.md) | [教程首页 / Guide home](../README.md) | [下一篇：V0.4 Advanced Routing / Next: Advanced routing →](13-routing.md)
