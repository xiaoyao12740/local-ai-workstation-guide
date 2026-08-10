# Provider 配置 / Providers

## 中文

先只配置一个已合法持有的 DeepSeek 或百炼凭据，选择协议、Endpoint 与真实可用 Model ID，执行 UI 的连接检查，再观察一次请求。不要为教程购买新服务，不要同时导入全部 Key。Provider 是否兼容某协议以其当前官方文档和真实检查为准。

本次 Runtime 只验证了 DeepSeek 单 Provider。百炼/Qwen 等第二 Provider 的结构与配置原则已记录，但 Provider 切换、fallback 和负载分配 Runtime 均未测试。

## English

Begin with one lawfully held DeepSeek or Model Studio credential. Choose the documented protocol, endpoint, and discoverable model, run the connection check, then observe one request. Do not purchase a new service or import every credential for this tutorial.

This runtime validated one DeepSeek provider only. A second provider and the switching architecture are documented, while provider switching, fallback, and load balancing were not runtime-tested.

---

### 课程导航 / Course navigation

[← 上一篇：凭据边界 / Previous: Credential boundaries](credential-boundaries.md) | [课程首页 / Course home](../../README.md) | [下一篇：Agent Profiles / Next: Agent profiles →](agent-profiles.md)
