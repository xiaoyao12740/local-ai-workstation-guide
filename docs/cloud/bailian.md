# 百炼 / Model Studio 最小客户端：静态与真实调用

> Last verified: 2026-08-10  
> Runtime status: PASS — 2026-08-10，`qwen3.7-plus`，HTTP 200，`CLOUD_API_OK`

真实调用使用脱敏 Workspace 域名 `<workspace>.cn-beijing.maas.aliyuncs.com`。仓库不记录真实 Workspace ID、API Key、余额或账户 ID。

本章只处理阿里云百炼（Model Studio）**按量付费模型 API**。Coding Plan、Token Plan、Claude Code、Codex 与 Agent 套餐不属于 V0.2 Python 客户端范围。

## 先对齐名称

- 阿里云百炼 / Model Studio：创建 Key、选择地域与业务空间、调用和计费的平台。
- Qwen / 通义千问：模型家族，不是 API Key 或 Endpoint。
- DashScope：阿里云文档和环境变量中仍使用的 API/SDK 名称。

## 三个必填环境变量

在仓库根目录的 Windows PowerShell：

```powershell
$env:DASHSCOPE_API_KEY = "<YOUR_API_KEY>"
$env:DASHSCOPE_BASE_URL = "<控制台创建 Key 时显示的 OpenAI-compatible API Host>"
$env:DASHSCOPE_MODEL = "<当前已开通的模型 ID>"
```

代码不根据 `sk-ws` 或旧 `sk-` 前缀判断 Key。它只检查值是否存在；真正有效性由 Provider 验证。

## Base URL 为什么必须由用户提供

百炼的 Region、Workspace、API Key 与 API Host 必须匹配。当前官方推荐北京、新加坡等地域使用 Workspace 专属域名，例如：

```text
https://{WorkspaceId}.cn-beijing.maas.aliyuncs.com/compatible-mode/v1
```

`{WorkspaceId}` 必须来自你自己的控制台，本仓库不会记录真实值。现有旧域名可能继续可用，但不要把某一个全局地址当成所有用户的唯一标准；优先复制创建 Key 时控制台显示的 API Host。

## 防误传保护

`DASHSCOPE_API_KEY` 是高价值凭据。客户端在导入 SDK 或联网前要求：

- URL 使用 HTTPS。
- Host 属于核验日官方 `*.maas.aliyuncs.com` 或兼容保留域名。
- 路径以 `/compatible-mode/v1` 结束。
- URL 不含用户名、密码、自定义端口、Query 或 Fragment。

当前允许域名规则：

```text
*.maas.aliyuncs.com
dashscope.aliyuncs.com
dashscope-intl.aliyuncs.com
dashscope-us.aliyuncs.com
```

这是防止新手把 Key 误发给复制错误的第三方 URL，不是替代 TLS、Provider 认证或官方文档。阿里云新增域名后必须更新规则与 `Last verified`。

## 离线 Preflight

```powershell
Remove-Item Env:DASHSCOPE_API_KEY -ErrorAction SilentlyContinue
Remove-Item Env:DASHSCOPE_BASE_URL -ErrorAction SilentlyContinue
Remove-Item Env:DASHSCOPE_MODEL -ErrorAction SilentlyContinue
.\.venv\Scripts\python.exe .\examples\cloud\bailian_chat.py
```

应返回 `[CONFIG] DASHSCOPE_API_KEY is not set...`，不应出现 Traceback 或网络请求。

## 本次真实调用采用的边界

- Prompt：`Reply exactly with: CLOUD_API_OK`
- Non-stream
- `max_tokens=16`
- Timeout 30 秒
- Retries 0
- 不打印 Key、Header、原始错误正文、Workspace ID、余额或账户信息

HTTP 错误只给脱敏分类。百炼的余额/额度、Workspace、地域与 Key 类型错误不直接复制 DeepSeek 的 HTTP 402 逻辑；以阿里云当前错误码与控制台为准。

## 官方来源

- [百炼 OpenAI Chat 兼容接口](https://help.aliyun.com/zh/model-studio/compatibility-of-openai-with-dashscope)
- [获取 API Key](https://help.aliyun.com/zh/model-studio/get-api-key)
- [百炼错误码](https://help.aliyun.com/zh/model-studio/error-code)
- [百炼模型列表](https://help.aliyun.com/zh/model-studio/getting-started/models)

---

### 课程导航 / Course navigation

[← 上一篇：DeepSeek / Previous: DeepSeek](deepseek.md) | [课程首页 / Course home](../../README.md) | [下一篇：Open WebUI 云 Provider / Next: Open WebUI cloud providers →](openwebui-provider.md)
