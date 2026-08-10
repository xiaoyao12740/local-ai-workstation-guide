# Agent Profiles / Agent 配置档案

> [!NOTE]
> **教程阶段 / Guide stage:** V0.4 · 高级社区路由 / Advanced Community Routing
> **阅读范围 / Reading range:** 第 13 章 + Routing 专题 / Chapter 13 + Routing section
> **前置内容 / Prerequisite:** 先完成 V0.3；这是 Advanced / Experimental 路线，不是基础工作站必需项。 / Complete V0.3 first; this Advanced / Experimental route is optional.

Last verified: 2026-08-10

## 中文

试验阶段选择“仅从 CCR 打开的 Agent”或等价局部模式，不改系统默认配置。每个 Profile 应记录 Agent、Provider ID、模型、协议和配置目标；应用前备份，应用后只在独立 Agent Lab 验证。

Claude Code 经 CCR 路由非 Claude 模型属于 Community / Experimental。当前 Claude Code → CCR → DeepSeek Runtime 已通过，但这不是 Anthropic 对非 Claude 模型的官方支持。

Codex 结论必须拆成两层：

- **静态协议兼容：PASS。** CCR 生成配置使用 `wire_api = "responses"`；OpenAI 的 Codex 配置参考说明当前该字段唯一支持值为 `responses`。
- **Codex → CCR Runtime：NOT TESTED。** 为保护现有 ChatGPT/Codex 登录、订阅额度和系统默认配置，没有启动第三方路由 Runtime，也没有把系统默认 Codex Profile 打开。

如果生成 `wire_api = "chat"`，应记录为兼容性阻塞，不要降级当前 Codex 客户端。

## English

During trials, affect only agents launched from CCR rather than system defaults. Record the agent, provider, model, protocol, and target config; back up first and validate only in an isolated Agent Lab.

Claude Code routing to a non-Claude model through CCR is Community / Experimental. The Claude Code → CCR → DeepSeek runtime passed, but it is not Anthropic support for a non-Claude model.

Codex has two separate findings:

- **Static protocol compatibility: PASS.** The generated profile uses `wire_api = "responses"`; the OpenAI Codex configuration reference lists `responses` as the only supported value.
- **Codex → CCR runtime: NOT TESTED.** The existing ChatGPT/Codex sign-in, subscription allowance, and system-default configuration were deliberately protected. The imported system-default Codex profile remained disabled.

Treat `wire_api = "chat"` as a compatibility blocker rather than downgrading the current Codex client. See the [official Codex configuration reference](https://developers.openai.com/codex/config-reference).

---

### 教程导航 / Guide navigation

[← 上一篇：Provider / Previous: Providers](providers.md) | [教程首页 / Guide home](../../README.md) | [下一篇：路由规则 / Next: Routing rules →](routing-rules.md)
