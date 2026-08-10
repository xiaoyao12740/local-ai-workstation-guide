# 路由规则 / Routing Rules

## 中文

按风险递增：单 Provider/模型/Agent → 两模型手动切换 → 独立 Profile → 一条可解释规则 → 可观测验证。不要一开始配置复杂自动 fallback。除非能用安全、无费用的干跑验证，否则只说明 fallback 原理，不伪造 429、假 Key 或故障。

## English

Progress from one provider/model/agent to manual model switching, one isolated profile, one explainable rule, and observed validation. Do not begin with complex automatic fallback, and never fake errors, credentials, or 429 responses to manufacture evidence.

---

### 课程导航 / Course navigation

[← 上一篇：Agent Profiles / Previous: Agent profiles](agent-profiles.md) | [课程首页 / Course home](../../README.md) | [下一篇：可观测性 / Next: Observability →](observability.md)
