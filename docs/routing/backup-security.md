# 备份与安全 / Backup and Security

> [!NOTE]
> **教程阶段 / Guide stage:** V0.4 · 高级社区路由 / Advanced Community Routing
> **阅读范围 / Reading range:** 第 13 章 + Routing 专题 / Chapter 13 + Routing section
> **前置内容 / Prerequisite:** 先完成 V0.3；这是 Advanced / Experimental 路线，不是基础工作站必需项。 / Complete V0.3 first; this Advanced / Experimental route is optional.

## 中文

仅在 CCR 完全停止后备份数据库，连同 WAL/SHM 一致处理。备份放在仓库外受限目录，并记录版本和日期。导出文件必须逐项人工检查秘密后才能分享；默认不分享。恢复前先复制现状并验证回滚路径。

## English

Back up the database only while CCR is fully stopped, handling WAL/SHM consistently. Store backups outside the repository in a restricted location with version/date metadata. Manually inspect exports for secrets before any sharing; the default is not to share. Preserve rollback before restore.

---

### 教程导航 / Guide navigation

[← 上一篇：可观测性 / Previous: Observability](observability.md) | [教程首页 / Guide home](../../README.md) | [下一篇：Routing 故障排查 / Next: Routing troubleshooting →](troubleshooting.md)
