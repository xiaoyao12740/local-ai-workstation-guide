# Research Status / 研究状态

> Last verified: 2026-08-09  
> 本页记录强时效信息的证据状态。正文只采用当前官方资料确认的结论；AI 回答、博客和社区帖子只作为检索线索。

## 资料可信度优先级

```text
1. 官方文档
2. 官方 GitHub 仓库 / 官方源码
3. 官方配置 Schema / Release Notes
4. 官方 npm / PyPI / Docker Registry / 模型库
5. 官方 Issue / Maintainer 回复
6. 社区资料
7. AI 搜索结果、博客、论坛
```

如果社区实践与官方支持范围不同，必须明确区分 `Officially supported` 与 `Community / Compatible / Experimental`。描述得具体不等于已得到验证；官方未说明的内部实现、认证优先级和安全属性不得靠推断补齐。

提交资料时请附链接、访问日期、地区和软件版本，并遮盖账号、API Key、余额、订单号、Cookie、OAuth 凭据及其他个人信息。

## 已确认 / Confirmed

### R-01 Claude Code Gateway 边界

- Claude Code 可以连接实现其支持 API 格式的 LLM Gateway。
- `ANTHROPIC_BASE_URL`、`ANTHROPIC_AUTH_TOKEN` 与 `ANTHROPIC_API_KEY` 是公开连接配置。
- 仅设置 Base URL 不会自动替代已保存的 Claude.ai 登录；可用 `/status` 核对连接来源。
- Anthropic 不支持通过 Gateway 将 Claude Code 路由到非 Claude 模型。此类方案必须标为第三方兼容或实验方案。

来源：[Anthropic Gateway](https://code.claude.com/docs/en/llm-gateway)、[Connect to a gateway](https://code.claude.com/docs/en/llm-gateway-connect)。

### R-02 Claude Code Router v3

- 核验时 npm `latest` 为 `@musistudio/claude-code-router@3.0.20`，要求 Node.js 22+。
- v3 以 UI 和 SQLite 为当前配置路径；旧 `config.json` 主要用于一次性迁移，不再是权威运行配置。
- Provider Credential、CCR Client API Key、Management Token 是三类不同凭据。
- CCR 数据目录、导出文件和备份可能包含凭据与请求数据，必须整体按 Secret 保护。
- 应用级备份优先使用 `Settings → Export data`；完整备份应先停止写入，再复制数据目录。
- 不断言 Provider Key 是否明文保存，也不把某个 SQLite 文件武断解释为特定凭据仓库。

来源：[CCR repository](https://github.com/musistudio/claude-code-router)、[Docker deployment](https://github.com/musistudio/claude-code-router/blob/main/docker/README.md)。

### R-03 Codex 认证与自定义 Provider

- 官方 README 推荐运行 `codex` 后选择 `Sign in with ChatGPT`。
- ChatGPT 计划中的 Codex 权益与 API Platform Key/计费不是一回事。
- Codex 支持自定义 Provider；`env_key` 用于指定读取凭据的环境变量，真实 Key 不应写进 `config.toml`。
- 不记录未经官方文档确认的内部认证优先级。
- `GPT-5.3-Codex` 在核验日仍未被官方模型目录标为 deprecated；模型状态以后仍须动态复查。

来源：[OpenAI Codex](https://github.com/openai/codex)、[OpenAI model directory](https://developers.openai.com/api/docs/models/all)。

### R-04 百炼 / Qwen API

- Qwen 是模型家族；阿里云百炼（Model Studio）是开通和管理 Qwen API 的平台。
- 新人额度按模型独立、输入输出共同扣减，通常有 90 天有效期；确切额度以用户控制台为准，不能宣传“永久免费”。
- 普通按量、Coding Plan、Token Plan 的 Key、Endpoint 与支持模型不能混用。
- Coding Plan Anthropic-compatible Endpoint 为 `https://coding.dashscope.aliyuncs.com/apps/anthropic`。
- Coding Plan OpenAI-compatible Endpoint 为 `https://coding.dashscope.aliyuncs.com/v1`。
- Claude Code + Coding Plan 有百炼官方配置方案；这不等于 Anthropic 官方支持非 Claude 模型。
- 核验时 Coding Plan 仅支持 Chat/Completions，百炼官方 Codex 文档要求旧版兼容方案；支持 Responses API 的按量方案可使用新版 Codex。

来源：[百炼 Claude Code](https://help.aliyun.com/zh/model-studio/claude-code)、[百炼 Codex](https://help.aliyun.com/zh/model-studio/codex)、[Base URL 总览](https://help.aliyun.com/zh/model-studio/base-url)。

### R-05 Open WebUI

- `:main` 与 `:latest` 是滚动标签；可复现环境应锁定实际验证过的 `:vX.Y.Z`。
- `/health` 无需认证，正常时返回 HTTP 200。
- OpenAI-compatible Provider 当前入口为 `Admin Settings → Connections → OpenAI → Add Connection`。

来源：[Quick Start](https://docs.openwebui.com/getting-started/quick-start/)、[Monitoring](https://docs.openwebui.com/reference/monitoring/)、[OpenAI-compatible Provider](https://docs.openwebui.com/getting-started/quick-start/connect-a-provider/starting-with-openai-compatible/)。

### R-06 AMD 核显与 Ollama

- Ryzen 5 5625U 的 Vega 核显不在 Ollama Windows ROCm 官方明确支持列表中。
- Ollama 另有 Windows/Linux Vulkan 后端，部分集显可能获得 offload，但不能保证该设备可用或流畅。
- 本教程以 CPU 为最低可靠路径，用 `ollama ps` 的 `PROCESSOR` 列确认实际运行方式。
- 该电脑只作为低配置可行性案例，不是推荐的大模型推理配置。

来源：[Ollama GPU support](https://github.com/ollama/ollama/blob/main/docs/gpu.mdx)、[Ollama FAQ](https://github.com/ollama/ollama/blob/main/docs/faq.mdx)。

### R-07 入门模型范围

- 核验日模型库文件体积：`qwen3.5:4b` 约 3.4GB、`qwen3.5:9b` 约 6.6GB、`deepseek-r1:8b` 约 5.2GB、14B 约 9GB、32B 约 20GB。
- 16GB 无独显轻薄本建议从 1B–4B Q4 起步；7B–9B Q4 仅列为可尝试；14B+ 不作为日常推荐。
- 文件大小不等于实际 RAM/VRAM 占用，不编造 tokens/s、温度、功耗或加载时间。

来源：[Qwen3.5 tags](https://ollama.com/library/qwen3.5/tags)、[DeepSeek-R1 tags](https://ollama.com/library/deepseek-r1/tags)。

## 动态维护项 / Recheck Before Updating

- CCR 最新版本、CLI 命令、数据格式和 Credential 保护实现。
- Coding Plan 当前支持模型，以及它何时支持最新版 Codex / Responses API。
- Codex 与 Claude Code 当前安装方式、默认模型和认证入口。
- OpenAI 当前模型目录与 deprecated 状态。
- Open WebUI 当前 release、UI 路径和镜像标签规则。
- 百炼各模型免费额度、活动条件、Endpoint 和套餐限制。
- Ollama 当前模型标签、量化文件大小及 GPU 后端支持表。
- Ryzen 5 5625U 在本机的 Vulkan offload 实测结果。

所有涉及上述内容的章节保留 `Last verified: YYYY-MM-DD`，更新时优先重新打开官方来源，而不是复制旧教程。

## 仍不应写成确定事实

- CCR Provider Credential 的具体加密/明文实现，除非官方安全文档或源码审计给出明确结论。
- Codex 内部多种凭据的固定优先级。
- “某个模型文件大小 + 固定系统开销 = 一定所需内存”的简单公式。
- 没有同一设备、版本、量化和上下文设置的性能数字。
- “社区已经有人跑通”自动等同于“官方支持”。
