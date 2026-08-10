# 截图验收清单 / Screenshot Acceptance List

> [!NOTE]
> **教程阶段 / Guide stage:** V0.4 · 高级社区路由 / Advanced Community Routing
> **阅读范围 / Reading range:** 第 13 章 + Routing 专题 / Chapter 13 + Routing section
> **前置内容 / Prerequisite:** 先完成 V0.3；这是 Advanced / Experimental 路线，不是基础工作站必需项。 / Complete V0.3 first; this Advanced / Experimental route is optional.

以下截图由维护者在真实 Runtime 完成后提供。地址栏、Token、Key、Credential 名称、账户、邮箱、余额、完整本机路径和请求/响应正文必须隐藏。

The maintainer captures these only after real runtime. Hide the address bar, tokens, keys, credential labels, account identity, balance, full local paths, and request/response bodies.

| # | 界面 / Screen | 必须表现 / Must show | 建议裁剪 / Crop |
| ---: | --- | --- | --- |
| 1 | CCR Home / Server | v3.0.20、服务状态、loopback Gateway | 只保留主面板；不要地址栏 |
| 2 | Providers | DeepSeek 或百炼单一 Provider、连接检查成功、Model ID | 隐藏 Key/Workspace/用量 |
| 3 | API Keys | 已创建 CCR Client Key 的“存在状态” | 不显示完整值，最好只截列表状态 |
| 4 | Agent Profile | Agent、Provider、Model、局部/仅 CCR 启动模式 | 隐藏配置文件绝对路径 |
| 5 | Observability | 时间、Agent、最终 Provider/Model、HTTP 状态、耗时、Token 数 | 关闭 request/response body 与 Credential 列 |

README 最多使用第 1 张；其余放 `assets/routing/` 并只在详细章节展示。若 Codex Profile 生成 `wire_api = "chat"`，不要截图成成功，应保留为脱敏的兼容性阻塞证据。

Use at most screenshot 1 in README. Place detailed evidence under `assets/routing/`. If a Codex profile generates `wire_api = "chat"`, record a sanitized compatibility blocker instead of presenting it as success.

---

### 教程导航 / Guide navigation

[← 上一篇：Routing 故障排查 / Previous: Routing troubleshooting](troubleshooting.md) | [教程首页 / Guide home — 完成完整路线](../../README.md)
