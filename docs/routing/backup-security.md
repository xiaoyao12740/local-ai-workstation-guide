# 备份与安全 / Backup and Security

## 中文

仅在 CCR 完全停止后备份数据库，连同 WAL/SHM 一致处理。备份放在仓库外受限目录，并记录版本和日期。导出文件必须逐项人工检查秘密后才能分享；默认不分享。恢复前先复制现状并验证回滚路径。

## English

Back up the database only while CCR is fully stopped, handling WAL/SHM consistently. Store backups outside the repository in a restricted location with version/date metadata. Manually inspect exports for secrets before any sharing; the default is not to share. Preserve rollback before restore.

---

### 课程导航 / Course navigation

[← 上一篇：可观测性 / Previous: Observability](observability.md) | [课程首页 / Course home](../../README.md) | [下一篇：Routing 故障排查 / Next: Routing troubleshooting →](troubleshooting.md)
