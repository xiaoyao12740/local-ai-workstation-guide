# CCR 凭据边界 / Credential Boundaries

> [!NOTE]
> **教程阶段 / Guide stage:** V0.4 · 高级社区路由 / Advanced Community Routing
> **阅读范围 / Reading range:** 第 13 章 + Routing 专题 / Chapter 13 + Routing section
> **前置内容 / Prerequisite:** 先完成 V0.3；这是 Advanced / Experimental 路线，不是基础工作站必需项。 / Complete V0.3 first; this Advanced / Experimental route is optional.

## 中文

必须区分三类秘密：上游 Provider Key（CCR 调模型）、CCR Client Key（Agent 调 Gateway）、管理 Token（访问管理面）。它们权限不同，不能复用或截图。CCR 数据目录、SQLite、WAL/SHM、请求日志、使用量、Profile、证书、导出与备份都按高敏资产处理。

## English

Keep upstream provider keys, CCR client keys, and management tokens distinct. They authorize different hops and must not be reused or screenshotted. Treat the CCR data directory, SQLite/WAL/SHM files, request logs, usage data, profiles, certificates, exports, and backups as sensitive.

---

### 教程导航 / Guide navigation

[← 上一篇：安装 CCR / Previous: Install CCR](ccr-install.md) | [教程首页 / Guide home](../../README.md) | [下一篇：Provider / Next: Providers →](providers.md)
