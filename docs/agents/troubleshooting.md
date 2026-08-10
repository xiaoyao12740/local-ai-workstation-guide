# Agent 故障排查 / Agent Troubleshooting

[中文](#中文) | [English](#english)

## 中文

按层定位，不要先重装：CLI 是否存在 → 登录/Key 是否属于正确产品 → Provider 是否可达 → 当前目录是否正确 → 沙箱是否允许所需写入 → 审批是否被拒绝 → 测试是否失败 → Git 是否出现越界修改。

- `401/403`：检查凭据来源、Endpoint 和套餐；不要把 Key 发到 Issue。
- 模型不可用：从客户端或 Provider 当前列表确认 Model ID，不猜名称。
- 无法写文件：检查是否在 `.agent-runtime/<agent>` 与 workspace-write 沙箱。
- Agent 卡住：停止后查看最后一条工具请求；不要放宽到整盘权限。
- 越界修改：立即停止，保留 `git diff` 证据，丢弃该实验副本并重新准备。

## English

Diagnose in layers: CLI, credential product, provider reachability, current directory, sandbox write scope, approval, tests, then Git scope. Never reinstall first. For authentication errors, verify key/endpoint pairing without sharing the key. For unavailable models, use current provider discovery. If an agent stalls or edits outside scope, stop it; do not grant whole-drive access.
