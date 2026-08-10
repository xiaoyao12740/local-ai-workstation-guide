# Gateway 基础 / Gateway Basics

## 中文

Gateway 是 Agent 与上游 Provider 之间的协议、认证、路由和记录边界。它能集中管理但也扩大风险：一个本地数据库可能同时持有多个上游 Key、客户端 Key、日志和 Profile。默认仅监听 `127.0.0.1`，不做公网映射、隧道或路由器端口转发。

CCR 使用自己的 Gateway、管理 UI、数据目录和凭据；旧 Open WebUI `:3000` 不在路由架构中，也不得作为中转层。

## English

A gateway mediates protocol, authentication, routing, and records between agents and providers. Centralization also concentrates risk: one local database may hold upstream keys, client keys, logs, and profiles. Bind to loopback only; do not publish, tunnel, or port-forward it.

CCR uses its own gateway, management UI, data directory, and credentials. The legacy Open WebUI on port 3000 is not part of the routing architecture and must not become an intermediary.

---

### 课程导航 / Course navigation

[← 上一篇：Routing 子课程目录 / Previous: Routing module](README.md) | [课程首页 / Course home](../../README.md) | [下一篇：安装 CCR / Next: Install CCR →](ccr-install.md)
