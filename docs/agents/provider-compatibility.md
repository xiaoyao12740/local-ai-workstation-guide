# Provider 兼容性 / Provider Compatibility

> [!NOTE]
> **教程阶段 / Guide stage:** V0.3 · 受控 Coding Agent / Controlled Coding Agents
> **阅读范围 / Reading range:** 第 07–08、11 章 + Agent 专题 / Chapters 07–08 and 11 + Agent section
> **前置内容 / Prerequisite:** 先理解 V0.2 的 API 与凭据边界；所有实验只在隔离 Agent Lab 中运行。 / Understand V0.2 API and credential boundaries; run experiments only in the isolated Agent Lab.

[中文](#中文) | [English](#english) · Last verified: 2026-08-10

## 中文

| 层级 | 含义 | 教程口径 |
| --- | --- | --- |
| 厂商官方 | Agent 与厂商明确支持的模型/云渠道 | 首选 |
| Provider 官方兼容 | Provider 文档声明兼容某客户端协议 | 可用，但不是客户端厂商背书 |
| 社区 Router | 第三方做协议转换或模型映射 | V0.4 Experimental |

厂商官方路线是 Claude Code → Anthropic Claude，以及 Codex → OpenAI。Claude Code 官方 Gateway 路线面向 Claude 模型；Anthropic 不支持通过 Gateway 把 Claude Code 路由到非 Claude 模型。DeepSeek Anthropic-compatible API → Claude Code 属于 DeepSeek-supported compatibility；百炼 Anthropic-compatible Qwen → Claude Code 属于 Alibaba-supported compatibility。它们都不是 Anthropic 对 Qwen/DeepSeek 的背书。Claude Code → CCR → DeepSeek 或其他非 Claude 模型继续属于 Community / Experimental。Codex 的 ChatGPT 登录与 OpenAI API Key 是不同授权/计费来源；第三方 Provider 必须与当前 Codex Responses 协议兼容，不能为了兼容旧 Chat Completions 而降级新客户端。

## English

Vendor-official routes are Claude Code → Anthropic Claude and Codex → OpenAI. DeepSeek's Anthropic-compatible Claude Code route is DeepSeek-supported compatibility; Model Studio's Anthropic-compatible Qwen route is Alibaba-supported compatibility. Neither is Anthropic endorsement of a non-Claude model. Claude Code → CCR → a non-Claude model remains Community / Experimental. Codex ChatGPT sign-in and OpenAI API billing are separate, and a third-party Codex provider must support the current Responses path rather than forcing a legacy downgrade.

---

### 教程导航 / Guide navigation

[← 上一篇：Codex / Previous: Codex](codex.md) | [教程首页 / Guide home](../../README.md) | [下一篇：安全 Agent Lab / Next: Controlled Agent Lab →](agent-lab.md)
