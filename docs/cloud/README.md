# V0.2 Cloud AI 模块设计

> Last verified: 2026-08-10  
> Status: Planning — 尚未声明 Runtime PASS

本目录承载 V0.2 的详细内容；[06-cloud-api.md](../06-cloud-api.md) 继续作为入口页。V0.2 只讨论通用模型 API 与 Open WebUI Provider，不包含 Coding Agent 或 CCR。

## 计划结构

| 文件 | 目标 | 关键验收 |
| --- | --- | --- |
| [api-basics.md](api-basics.md) | Provider、模型、Endpoint、Token、限流与计费 | 静态实现完成；能解释网页会员不等于 API |
| [deepseek.md](deepseek.md) | 环境变量、PowerShell/Python 最小调用、错误处理 | 静态实现完成；Runtime NOT RUN |
| [bailian.md](bailian.md) | 百炼按量付费 Key、地域/业务空间 Endpoint、Qwen 调用 | 静态实现完成；Runtime NOT RUN |
| [openwebui-provider.md](openwebui-provider.md) | Open WebUI 添加 OpenAI-compatible Connection | 静态安全设计完成；Runtime 被旧容器公网卡绑定阻塞 |
| `api-security.md` | Key 生命周期、最小权限、费用保护与截图规则 | Git/日志/截图中无真实 Key |
| `troubleshooting.md` | 认证、模型、网络、限流和 Provider UI 故障 | 按层定位，不盲目重装 |

文件在对应功能进入实现阶段时创建，避免先生成空壳教程。Issue #3 静态实现与 Runtime 已通过；Issue #4 静态设计进行中；Issue #5–#6 尚未开始。

## 已确认的动态边界

### DeepSeek

- 官方 OpenAI-compatible Base URL：`https://api.deepseek.com`；Open WebUI 当前文档使用 `https://api.deepseek.com/v1`。
- 2026-08-10 官方快速开始列出的代表模型为 `deepseek-v4-flash` 与 `deepseek-v4-pro`。
- 模型名必须通过环境变量或示例配置传入，正文不得将核验日模型写成永久默认。
- 官方错误码包含 400、401、402、422、429、500、503。

官方来源：[DeepSeek first API call](https://api-docs.deepseek.com/) · [Error codes](https://api-docs.deepseek.com/quick_start/error_codes/)

### Alibaba Cloud Model Studio / 百炼

- V0.2 使用按量付费 API Key，不使用 Coding Plan / Token Plan Key 调自定义脚本。
- Key、协议、地域、业务空间与 Base URL 必须匹配；新 Key 可能以 `sk-ws` 开头并只显示一次明文。
- 北京地域既存在通用 `dashscope.aliyuncs.com` 路径，也存在带 Workspace ID 的新式 Endpoint；教程必须让读者以自己控制台创建 Key 时显示的 API Host 为准。
- Coding Plan / Token Plan 的 Agent 用法属于 V0.3，不能混入 V0.2 普通 API 示例。

官方来源：[获取 API Key](https://help.aliyun.com/zh/model-studio/get-api-key) · [OpenAI-compatible Chat](https://help.aliyun.com/zh/model-studio/qwen-api-via-openai-chat-completions)

### Open WebUI

- 当前路径：`Admin Settings → Connections → OpenAI → Add Connection`。
- OpenAI-compatible Provider 通常通过 `/models` 自动发现；失败时不一定代表 Chat API 不兼容，可使用 Model IDs Filter。
- Docker 内访问宿主服务时不能把 `localhost` 当作 Windows；云 API 则直接使用 HTTPS Provider URL。

官方来源：[OpenAI-compatible Provider](https://docs.openwebui.com/getting-started/quick-start/connect-a-provider/starting-with-openai-compatible/)

## 不记录的内容

- 真实 API Key 或可逆掩码
- 完整请求/响应头中的认证字段
- 账户余额、订单号、用户 ID 或控制台私人截图
- 未经实测的成功结论
- 将某个活动额度称为“永久免费”
