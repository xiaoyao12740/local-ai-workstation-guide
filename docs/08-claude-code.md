# 08. Claude Code、Codex 与兼容路由

> Last verified: 2026-08-09  
> Claude Code、Codex、Gateway 与 CCR 更新较快，执行命令前复查官方文档。

## 本章目标

- 为 Claude 与 OpenAI 模型选择更自然的 Coding Agent 路线。
- 区分官方 Gateway 连接机制、Provider 官方兼容方案与社区 Router。
- 理解协议适配为什么不只是修改 Base URL。
- 用 Provider → Gateway → Agent 三层方法完成验收。

## 两条原生路线

### Claude Code + Claude

Claude Code 是 Anthropic 的 Coding Agent。使用 Anthropic 官方 API、以及官方明确支持的云平台/企业网关时，遵循 [Anthropic Claude Code documentation](https://code.claude.com/docs/en/overview)。

Claude Code 当前原生支持 Windows，WSL 2 不再是安装硬前提；但官方当前比较表说明 WSL 2 支持 sandboxing，因此 Linux 工具链或希望使用沙箱时，WSL 2 仍是本教程推荐方案。安装优先采用当前 Native Install 文档，不把旧 npm 全局安装当作唯一方案。

### Codex + OpenAI

Codex 是 OpenAI 的 Coding Agent，适合使用 OpenAI 模型完成代码理解、修改、测试、审查和调试。安装、登录、模型与 API 方式以 [OpenAI Codex documentation](https://developers.openai.com/codex/) 为准。

教程不把 OpenAI 模型强行接入 Claude Code 描述成最佳实践。即使兼容层可以完成部分工作，Codex 通常更能利用 OpenAI 原生 Agent 接口和行为约定。

Codex 的两种常见认证来源必须分开理解：

- 运行 `codex` 并选择 `Sign in with ChatGPT`，使用的是 ChatGPT 计划中包含的 Codex 产品权益，额度随计划变化。
- 使用 API Key 时，走对应 API Provider 的账户、额度与计费规则；这不是“免费的 ChatGPT API”。

自定义 Provider 可以在 `config.toml` 中用 `env_key` 指定凭据所在的环境变量。配置文件只保存变量名，真实 Key 留在本机环境中。不要记录或猜测 Codex 内部多种认证方式的固定优先级。

## Provider 与 Agent 对照

| 想使用的模型 | 更自然的路线 | 兼容实验的正确定位 |
| --- | --- | --- |
| Claude | Claude Code | Anthropic 官方支持的 Gateway/云来源 |
| OpenAI GPT/Codex 系列 | Codex | 社区路由接 Claude Code，需完整验收 |
| DeepSeek | 支持其 API 的通用 Agent | 社区路由适配 Claude Code/Codex 类工作流 |
| Qwen API（阿里云百炼） | 百炼官方文档提供 Claude Code/Codex 接入 | 阿里云官方兼容方案，不等于 Anthropic/OpenAI 对非原生模型的支持 |
| Ollama 本地模型 | 支持 Ollama 的本地 Agent | 社区路由适配，能力受模型限制 |

## Claude Code 官方 Gateway 边界

Anthropic 当前文档确认：实现其支持协议格式的 LLM Gateway 可作为连接机制；同时明确表示 Anthropic 不维护、审计第三方 Gateway，也不支持通过 Gateway 将 Claude Code 路由到非 Claude 模型。

```text
官方支持：Claude Code → LLM Gateway → Claude 模型/官方云来源

第三方兼容：Claude Code → Router/Gateway → Qwen/DeepSeek/OpenAI 模型
```

后者可能由对应 Provider 或社区项目提供文档，但不能写成 Anthropic 官方支持。

### Gateway 变量

当前官方连接文档给出：

```text
ANTHROPIC_BASE_URL
ANTHROPIC_AUTH_TOKEN
ANTHROPIC_API_KEY
```

- `ANTHROPIC_BASE_URL` 指向 Gateway。
- 只设置 Base URL 不会自动替代已保存的 claude.ai 登录认证。
- Token/Key 激活时，Claude Code `/status` 应显示实际 Base URL 和凭据来源。
- 先在当前 Shell 临时设置并验证，再考虑持久配置。

不要把真实凭据写入可能提交的 `.claude/settings.json`。使用 `.claude/settings.local.json` 时，也必须先确认它已被 Git 忽略。

参考：[Claude Code Gateway](https://code.claude.com/docs/en/llm-gateway) 与 [Gateway connection](https://code.claude.com/docs/en/llm-gateway-connect)。

## 为什么不能只改 Base URL

Claude Code 会期待 Anthropic 风格的请求、事件和模型行为，OpenAI-compatible Endpoint 通常是另一套格式。Router 至少可能需要转换：

- 消息角色和请求字段。
- 模型名、快/慢模型和任务路由。
- Tool Use / Function Calling Schema。
- Streaming 事件和错误响应。
- Context、最大输出、Token 统计与缓存。

所以“普通聊天成功”不能证明“Coding Agent 兼容”。

## Claude Code Router v3：高级社区方案

截至核验日期，npm `latest` 为 `@musistudio/claude-code-router@3.0.20`，要求 Node.js 22+。版本变化很快，安装前查询：

```bash
node --version
npm view @musistudio/claude-code-router version engines
npm install -g @musistudio/claude-code-router
ccr ui
```

v3 当前主流程：

```text
Providers → Add Provider/Model
    → Server → Start
    → Agent Config → 选择 Claude Code、Codex 等客户端
    → Logs → 检查 Provider、Model、Token、延迟与错误
```

当前默认管理 UI 为 `http://127.0.0.1:3458`，模型 Gateway 为 `http://127.0.0.1:3456`。保持 localhost 绑定，不直接暴露公网。

当前 CLI 文档已确认：

```bash
ccr start
ccr ui
ccr stop
```

网上常见的 `ccr code`、`ccr model`、旧 Router JSON 和环境变量教程可能属于其他版本，不能无验证复制。

### v3 配置的重要变化

当前官方仓库说明运行配置存入 SQLite。旧 `config.json` 只会在没有 SQLite 配置时作为一次迁移源；迁移后编辑 JSON 不影响当前配置。不要直接编辑运行中的 `config.sqlite`、`-wal` 或 `-shm` 文件。

旧 JSON 的 `$ENV_VAR` 插值属于 legacy/migration 路径，不能当作 v3 当前 UI/SQLite 的默认 Secret 方案。Provider Credential 通过本地管理 UI 添加；不要把真实 Key 写进示例 JSON、截图或 Git 历史。

CCR 官方资料确认数据目录和导出备份可能包含 Provider Credentials、CCR Client Keys 与请求数据，因此必须整体视为 Secret。当前资料没有明确证明 Provider Key 的具体加密/明文实现，教程不作推断。

三类凭据必须分开：

```text
Provider Credential  → CCR 调用上游模型
CCR Client API Key    → Claude Code / Codex 等客户端调用 CCR Gateway
Management Token      → 浏览器访问 CCR 管理 UI / RPC
```

不要复用上游 Provider Credential 作为 CCR Client Key。应用级备份优先使用 `Settings → Export data`；完整数据目录备份要先停止写入，且备份不得上传 GitHub 或公开云盘。不要让初学者直接编辑 SQLite、WAL 或 SHM 文件。

参考：[CCR repository](https://github.com/musistudio/claude-code-router) 与 [v3 configuration docs](https://github.com/musistudio/claude-code-router/blob/main/docs/src/content/docs/en/configuration/configuration-file.md)。

## 社区路由准入检查

- [ ] 官方仓库、许可证和维护者可识别。
- [ ] 最近仍有 Release、Commit 或 Issue 维护。
- [ ] 配置 Schema 与安装版本一致。
- [ ] Key 能通过安全机制保存，日志默认脱敏。
- [ ] 不要求网页 Cookie、订阅 Token 或来源不明凭据。
- [ ] localhost 绑定、备份和更新方式清晰。
- [ ] 已在隔离仓库验证工具调用、错误处理和费用。

动态问题记录在 [RESEARCH_REQUESTS.md](../RESEARCH_REQUESTS.md)。

## 百炼官方兼容优先于社区 Router

阿里云当前提供 Coding Plan 的 OpenAI-compatible 与 Anthropic-compatible Endpoint，并有 Claude Code/Codex 接入文档。教学顺序应是：

```text
百炼官方兼容接口 → Claude Code/Codex
    → 理解 OpenAI/Anthropic 协议差异
        → CCR 多 Provider/多 Agent 高级路由
```

Claude Code 使用百炼非 Claude 模型仍不能描述成 Anthropic 官方支持；它是阿里云提供并负责说明的兼容方案。Key、Endpoint 和 Plan 用途必须匹配，详见 [云 API 章节](06-cloud-api.md)。

### Claude Code + Coding Plan

百炼当前官方文档提供 `ANTHROPIC_AUTH_TOKEN`、Coding Plan Anthropic-compatible Endpoint 以及模型映射示例，因此这条路线不需要先安装 CCR。配置保存在用户级 `~/.claude/settings.json`（Windows 为 `C:\Users\<用户名>\.claude\settings.json`）；它是本机私有配置，不得复制进仓库。模型名和支持范围变化很快，实际填写时直接采用百炼当前官方页面与控制台显示的值，完成后用 `/status` 核对连接。

### Codex + 百炼的版本边界

截至核验日，百炼官方文档写明：Coding Plan 只支持 Chat/Completions，并给出旧版 Codex 兼容示例；不能写成“最新版 Codex 可无条件直连 Coding Plan”。支持 Responses API 的百炼按量方案可按其官方文档使用新版 Codex。降级客户端会带来功能与安全更新缺失风险，因此本教程不把固定旧版本作为默认安装步骤，只记录这一兼容限制并引导读者复查官方页面。

```text
Claude Code → Coding Plan Anthropic-compatible（百炼官方方案）
最新版 Codex → OpenAI 官方登录，或百炼支持 Responses API 的方案
Coding Plan → Chat/Completions → 仅按百炼当期兼容说明评估旧版 Codex
```

## 三层验收

1. **Provider**：先用最小 API 示例验证模型。
2. **Gateway**：验证聊天、流式输出和无副作用 Tool Call，检查日志脱敏与 localhost。
3. **Agent**：在 [hello-agent](11-agent-lab.md) 验证文件、测试、修复和 Git diff。

任一层失败都回到该层排查，不同时更换 Provider、Endpoint、模型和 Agent。

## Key 与“买来的令牌”

教程只接受用户本人在官方平台或明确授权渠道合法获得、可查看用量并可撤销的 API Key。来源不明、无法撤销、要求共享账号/Cookie、明显违反条款的转售凭据不应接入 Agent。

专业表述是“配置自定义 Provider/API Gateway”，不是“破解”“白嫖”或“绕过”。

## 成本与能力

- Claude Code + Claude：原生匹配，权限和费用以 Anthropic 为准。
- Codex + OpenAI：OpenAI 原生 Agent；ChatGPT 产品权限与 API Platform 计费需区分。
- DeepSeek：适合成本敏感实验，但质量、工具兼容和价格需实测。
- Qwen API：在百炼开通，可能有时限试用额度；以控制台为准。
- Ollama：无云推理费，但占用本机算力、电力、内存和磁盘。

## 完成后的状态

你应能为目标模型选择原生 Agent，区分官方 Gateway 与社区 Router，并使用三层方法验证，而不是把返回文本当作“完美兼容”。
