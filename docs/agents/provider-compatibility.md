# Provider 兼容性 / Provider Compatibility

[中文](#中文) | [English](#english) · Last verified: 2026-08-10

## 中文

| 层级 | 含义 | 教程口径 |
| --- | --- | --- |
| 厂商官方 | Agent 与厂商明确支持的模型/云渠道 | 首选 |
| Provider 官方兼容 | Provider 文档声明兼容某客户端协议 | 可用，但不是客户端厂商背书 |
| 社区 Router | 第三方做协议转换或模型映射 | V0.4 Experimental |

Claude Code 官方 Gateway 路线面向 Claude 模型；Anthropic 不支持通过 Gateway 把 Claude Code 路由到非 Claude 模型。百炼提供的 Anthropic-compatible Qwen 接法属于阿里云支持的兼容方案，不是 Anthropic 官方支持。Codex 的 ChatGPT 登录与 OpenAI API Key 是不同授权/计费来源；第三方 Provider 必须与当前 Codex Responses 协议兼容，不能为了兼容旧 Chat Completions 而降级新客户端。

## English

Distinguish vendor-supported routes, provider-documented compatibility, and community routers. Anthropic's supported gateway path targets Claude models; routing Claude Code to non-Claude models is not Anthropic-supported. Model Studio's Anthropic-compatible Qwen route is Alibaba-supported compatibility. Codex ChatGPT sign-in and OpenAI API billing are separate, and a third-party Codex provider must support the current Responses path rather than forcing a legacy downgrade.
