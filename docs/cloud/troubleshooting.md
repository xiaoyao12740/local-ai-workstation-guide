# 云 API 分层故障排查

> Last verified: 2026-08-10
> 原则：从配置向 Provider 逐层定位；不打印凭据，不盲目重装，不删除数据卷。

```text
Configuration → Network → Authentication → Authorization/Workspace
→ Model → Parameters → Billing/Quota → Rate Limit → Provider 5xx → Open WebUI UI
```

## 通用排查表

| 现象 | 可能层级 | 安全检查 | 禁止操作 |
| --- | --- | --- | --- |
| 脚本提示缺少变量 | Configuration | 检查变量名和当前 PowerShell 窗口；重新以隐藏输入设置 | 把 Key 打印出来“确认” |
| DNS、TLS、timeout | Network | 检查网络、代理、系统时间和 Provider 状态页；少量重试 | 反复重装 Python/Docker |
| HTTP 401 | Authentication | 确认 Key 属于目标 Provider，且没有过期或被撤销 | 上传 Key/Header 到 Issue |
| HTTP 403 | Authorization / Workspace / Quota | 核对 Region、Workspace、Endpoint、模型权限及免费额度策略 | 假定所有 Provider 的 403 含义相同 |
| HTTP 404 | Endpoint / Model | 对照控制台 `/models` 与官方模型目录 | 根据模型自我介绍猜 Model ID |
| HTTP 400/422 | Parameters | 检查请求格式、参数范围、Thinking/工具能力 | 无限增加重试次数 |
| 余额或额度提示 | Billing / Quota | 人工查看 Usage/Billing；确认 Key 类型与计划 | 为“测试”故意耗尽余额 |
| HTTP 429 | Rate Limit | 降低并发，等待窗口恢复，查看配额 | 疯狂自动重试；把它当网络断开 |
| HTTP 500/503 | Provider | 少量退避重试并查看官方状态 | 删除 Open WebUI Volume 或重装系统 |
| API 脚本成功但 UI 无模型 | Open WebUI UI | 检查 Connection URL、`/models`、Model IDs Filter 和管理员权限 | 在截图里暴露 Connection/Key |

## DeepSeek 状态分类

当前教程按官方/防御性边界处理：

- `400` → `FORMAT`
- `401` → `AUTH`
- `402` → `BILLING`
- `422` → `PARAMETERS`
- `429` → `RATE_LIMIT`
- `500` / `503` → `PROVIDER`
- `403` / `404` → 通用防御性分类，不声明为 DeepSeek 对所有接口的固定保证

客户端不回显 Provider 响应体，因为响应或异常对象可能包含请求标识、内部细节甚至被错误拼入的敏感值。

## 百炼特有检查顺序

百炼不能机械套用 DeepSeek 的状态说明。优先核对：

1. Key 是否属于当前 Region / Workspace；
2. API Host 是否是创建该 Key 时控制台给出的地址；
3. 是否错误混用了普通按量 Key、Token Plan 或 Coding Plan Endpoint；
4. 模型是否在当前 Workspace 开通；
5. 免费额度用完即停、账户欠费或模型权限是否导致拒绝。

## Open WebUI 中的 `localhost`

容器内的 `localhost` 指容器自身，不是 Windows。仓库 Compose 用：

```text
http://host.docker.internal:11434
```

连接宿主机 Ollama。云 Provider 则使用其官方 HTTPS URL。若 3000 端口已被旧实例占用，可用独立 Compose 项目和 `127.0.0.1:3001` 验证，不要删除旧 Volume。

## 安全的 Negative Path

本项目用离线单元测试验证缺变量、恶意 URL、状态映射和秘密不回显。不会为了打勾而向线上发送假 Key、制造 429、耗尽额度或攻击 Provider。线上无法安全复现的错误在验收表中保留为“offline defensive coverage”，不伪造 Runtime PASS。

## 官方来源

- [DeepSeek API error codes](https://api-docs.deepseek.com/quick_start/error_codes/)
- [阿里云百炼：模型用量](https://help.aliyun.com/zh/model-studio/model-usage-statistics)
- [阿里云百炼：新人免费额度与计费 FAQ](https://help.aliyun.com/zh/model-studio/new-free-quota)
- [Open WebUI: OpenAI-compatible Provider](https://docs.openwebui.com/getting-started/quick-start/connect-a-provider/starting-with-openai-compatible/)

---

### 课程导航 / Course navigation

[← 上一篇：API 安全与费用 / Previous: API safety and cost](api-security.md) | [课程首页 / Course home](../../README.md) | [下一篇：V0.3 Coding Agent / Next: Coding agents →](../07-agent-basics.md)
