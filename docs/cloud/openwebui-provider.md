# Open WebUI 云 Provider：持久化凭据前先过安全门

> Last verified: 2026-08-10
> Runtime status: DEEPSEEK / QWEN PROVIDER UI VALIDATION PASS

V0.2 的目标是在同一个 Open WebUI 中同时使用本地 Ollama、DeepSeek 与百炼/Qwen。与临时 PowerShell 不同，Open WebUI 中添加的 Provider Connection 会随应用配置持久保存，因此数据卷、管理员账户、备份与网络暴露都必须按敏感资产处理。

## Runtime 前置门

### Runtime verified

- [x] 本次 V0.2 隔离实例的宿主端口只绑定 `127.0.0.1:3001`，不是 `0.0.0.0` 或 `::`。
- [x] Compose 明确设置 `WEBUI_AUTH=true`。

### User responsibilities / security requirements

- 使用强且唯一的本地管理员密码。
- 不在公共网络、端口转发、反向代理或公网隧道中暴露此实例。
- 将包含账户、聊天和持久配置的 Open WebUI Volume、数据库与完整备份视为敏感资产。
- 不把数据库、Volume 导出、管理员页面或 Connection 页面截图提交到 Git。

只读检查：

```powershell
docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"
docker compose ps
```

安全默认应类似：

```text
127.0.0.1:3000->8080/tcp
```

如果显示 `0.0.0.0:3000` 或 `[::]:3000`，先迁移到仓库 Compose 或使用隔离的回环端口实例；不要先粘贴云 Key。本项目 V0.2 验证使用独立 Compose 项目 `local-ai-workstation-v02`、端口 `127.0.0.1:3001` 和独立数据卷，不改动维护者原有的 3000 实例。

## 凭据与数据卷边界

Open WebUI 的 ConfigVar 会持久保存到应用内部数据。官方 Docker 启动方式会自动生成并在数据目录保存 `WEBUI_SECRET_KEY`；该密钥与登录会话及部分敏感数据加密有关。不要为了教程随意更换它，也不要删除数据卷来“刷新配置”。

本项目不对当前版本 Provider API Key 的内部字段级加密实现作未经源码核验的保证。最稳妥的假设是：

> 拥有 Open WebUI 管理权限、数据库或完整 Volume 备份的人，可能接触到 Provider 配置或以该实例身份使用云模型。

因此：

- Volume 备份与 API Key 同级保护。
- 不把 Volume 上传网盘、GitHub Issue 或公开对象存储。
- 不在管理员 Connection 页面截图。
- 删除 Connection 不等于吊销 Provider Key；真正吊销或轮换仍在 Provider 控制台完成。

## 添加 DeepSeek

当前 Open WebUI 官方入口：

```text
Admin Settings → Connections → OpenAI → Add Connection
```

填写：

| Field | Value |
| --- | --- |
| URL | `https://api.deepseek.com/v1` |
| API Key | 你的 DeepSeek API Key（不要复制到教程或截图） |
| Model IDs Filter | 优先留空使用 `/models` 自动发现 |

Open WebUI 当前页面仍可能展示旧 `deepseek-chat` / `deepseek-reasoner` 示例；DeepSeek Provider 当前官方目录已使用 V4 模型名。以实时 `/models` 和 DeepSeek 官方目录为准，不照抄第三方页面中的旧示例。

保存后只验证：

- 本地 Ollama 模型仍存在。
- 当前 DeepSeek 模型能被选中。
- 使用短 Prompt：`Reply exactly with: CLOUD_API_OK`。
- 不开启调试日志或截取包含 Key 的设置页。

## 添加百炼 / Qwen

在同一入口新增另一条 OpenAI-compatible Connection：

| Field | Value |
| --- | --- |
| URL | 控制台创建按量付费 Key 时显示的 OpenAI-compatible API Host |
| API Key | 对应 Region / Workspace 的按量付费 Key |
| Model IDs Filter | 若自动发现失败，只填写控制台当前已开通的模型 ID |

Region、Workspace、Key、API Host 与 Model 必须匹配。不要使用 Coding Plan / Token Plan Key，也不要在仓库记录真实 Workspace ID。

## 验收分层

```text
Connection saved
≠ model discovered
≠ HTTP request passed
≠ exact-output instruction passed
≠ billing reconciled
```

每一层单独记录。HTTP 200 但回答不是精确 `CLOUD_API_OK` 时，Transport/API 仍为 PASS，Instruction compliance 标记 WARN。

## 脱敏实测结果

隔离实例已经完成以下浏览器端验证：

- Open WebUI 能发现并选择 DeepSeek 与百炼/Qwen 的云模型。
- `deepseek-v4-flash` 完成一次中英文双语对话。
- `qwen3.7-plus` 对精确输出提示返回 `CLOUD_API_OK`。
- 截图不包含 API Key、邮箱、Workspace ID 或 Connection 设置页。

| DeepSeek | Qwen |
| --- | --- |
| ![DeepSeek 在 Open WebUI 中完成双语对话](../../assets/cloud/openwebui-deepseek-bilingual-chat-1.png) | ![Qwen 3.7 Plus 在 Open WebUI 中返回精确验证结果](../../assets/cloud/openwebui-qwen37-validation.png) |

> 截图里的模型自我介绍仅是生成内容，不是厂商承诺。例如“完全免费”“没有使用限制”、知识截止日期和功能范围都可能不准确，必须以 Provider 控制台、官方文档和真实测试为准。

### Qwen Model ID 证据口径

Python 客户端与 Open WebUI 均使用百炼普通按量 Workspace API 的 `qwen3.7-plus`。模型选择器、提示词和 `CLOUD_API_OK` 返回值同屏，Model ID 不依赖聊天正文中的自我介绍推断。

## 禁用、删除与轮换

- 临时不用：在 Connections 中关闭对应 Connection，保留配置。
- 不再使用：删除 Connection，并在 Provider 控制台轮换或吊销 Key。
- 怀疑泄露：先在 Provider 控制台吊销 Key，再处理本地 Connection 和备份。
- 不要用删除整个 Volume 代替单一 Provider 的凭据轮换；这会同时删除账户、聊天和其他配置。

## OpenAI 与 Claude 的证据等级

维护者当前没有 OpenAI API Key 或 Anthropic API Key，因此本项目只根据官方资料解释相关架构与静态配置，不会标记 OpenAI/Claude Runtime PASS。V0.2 的详细真机证据范围是 DeepSeek 与百炼/Qwen。

## 官方来源

- [Open WebUI: OpenAI-compatible Provider](https://docs.openwebui.com/getting-started/quick-start/connect-a-provider/starting-with-openai-compatible/)
- [Open WebUI: Environment configuration](https://docs.openwebui.com/reference/env-configuration/)
- [Open WebUI: Hardening](https://docs.openwebui.com/getting-started/advanced-topics/hardening/)
- [DeepSeek model list](https://api-docs.deepseek.com/api/list-models/)
- [百炼 OpenAI-compatible Chat](https://help.aliyun.com/zh/model-studio/compatibility-of-openai-with-dashscope)
- [百炼官方模型目录](https://help.aliyun.com/zh/model-studio/models)
