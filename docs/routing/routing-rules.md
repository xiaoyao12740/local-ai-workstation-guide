# 路由规则 / Routing Rules

> [!NOTE]
> **教程阶段 / Guide stage:** V0.4 · 高级社区路由 / Advanced Community Routing
> **阅读范围 / Reading range:** 第 13 章 + Routing 专题 / Chapter 13 + Routing section
> **前置内容 / Prerequisite:** 先完成 V0.3；这是 Advanced / Experimental 路线，不是基础工作站必需项。 / Complete V0.3 first; this Advanced / Experimental route is optional.

## 中文

按风险递增：单 Provider/模型/Agent → 两模型手动切换 → 独立 Profile → 一条可解释规则 → 可观测验证。不要一开始配置复杂自动 fallback。除非能用安全、无费用的干跑验证，否则只说明 fallback 原理，不伪造 429、假 Key 或故障。

## English

Progress from one provider/model/agent to manual model switching, one isolated profile, one explainable rule, and observed validation. Do not begin with complex automatic fallback, and never fake errors, credentials, or 429 responses to manufacture evidence.

---

### 教程导航 / Guide navigation

[← 上一篇：Agent Profiles / Previous: Agent profiles](agent-profiles.md) | [教程首页 / Guide home](../../README.md) | [下一篇：可观测性 / Next: Observability →](observability.md)
