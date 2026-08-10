# CCR 凭据边界 / Credential Boundaries

## 中文

必须区分三类秘密：上游 Provider Key（CCR 调模型）、CCR Client Key（Agent 调 Gateway）、管理 Token（访问管理面）。它们权限不同，不能复用或截图。CCR 数据目录、SQLite、WAL/SHM、请求日志、使用量、Profile、证书、导出与备份都按高敏资产处理。

## English

Keep upstream provider keys, CCR client keys, and management tokens distinct. They authorize different hops and must not be reused or screenshotted. Treat the CCR data directory, SQLite/WAL/SHM files, request logs, usage data, profiles, certificates, exports, and backups as sensitive.

---

### 课程导航 / Course navigation

[← 上一篇：安装 CCR / Previous: Install CCR](ccr-install.md) | [课程首页 / Course home](../../README.md) | [下一篇：Provider / Next: Providers →](providers.md)
