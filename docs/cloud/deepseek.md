# DeepSeek 最小客户端：静态实现

> Last verified: 2026-08-10  
> Runtime status: NOT RUN — 本阶段未使用真实 Key、未发起付费请求

本阶段只验证配置、代码结构、Thinking 策略、错误分类与缺 Key 安全退出。真实调用必须在静态审查通过并获得用户明确许可后单独执行。

## 当前动态事实

- DeepSeek 当前 OpenAI-compatible Base URL：`https://api.deepseek.com`。
- 当前官方模型目录与 Change Log 列出 `deepseek-v4-flash`、`deepseek-v4-pro`。
- 旧教程常见的 `deepseek-chat` 与 `deepseek-reasoner` 已公告于 2026-07-24 退役，不作为本教程新用户默认示例。
- DeepSeek V4 Thinking 当前默认开启；连通性测试显式传递 `extra_body={"thinking":{"type":"disabled"}}`。

模型 ID 是动态信息。第一次真实测试计划使用核验日成本/速度导向的 `deepseek-v4-flash`，但仍要求用户显式设置 `DEEPSEEK_MODEL`，避免把它冒充永久默认。

## 安装依赖

在仓库根目录的 Windows PowerShell：

```powershell
python -m pip install -r .\examples\cloud\requirements.txt
```

## 当前 Shell 临时配置

```powershell
$env:DEEPSEEK_API_KEY = "<YOUR_API_KEY>"
$env:DEEPSEEK_MODEL = "deepseek-v4-flash"
```

不要把真实值写入仓库文件。关闭当前 PowerShell 后，这种进程级环境变量不会自动保留。

## 运行

```powershell
python .\examples\cloud\deepseek_chat.py
```

程序在任何网络请求前检查 `DEEPSEEK_API_KEY` 与 `DEEPSEEK_MODEL`。缺失时安全退出，不打印 Key、部分 Key、长度或 Traceback。

成功输出只包含允许进入验收记录的字段：

```text
Provider: DeepSeek
Endpoint: api.deepseek.com
Model: deepseek-v4-flash
HTTP: 200
Result: CLOUD_API_OK
```

如果模型没有严格遵循短 Prompt，程序会标记 `[RESULT]`，但不会把它误报为传输失败。

## 设计选择

- 非流式请求，Prompt 为 `Reply exactly with: CLOUD_API_OK`。
- `max_tokens=16`，控制第一次验证的输出和成本。
- Thinking 显式关闭，避免额外延迟、Token 和行为不确定性。
- SDK `timeout=30`、`max_retries=0`，让第一次验证的失败原因更直接；生产重试策略不在本示例范围。
- HTTP 状态分为格式、认证、权限、余额、模型、参数、限流与 Provider 故障。
- DNS、TLS、连接和超时独立归为 `[NETWORK]`。
- 不打印原始错误正文、请求对象、Header、Key、账户或余额。

## 安全清除当前 Shell 变量

```powershell
Remove-Item Env:DEEPSEEK_API_KEY -ErrorAction SilentlyContinue
Remove-Item Env:DEEPSEEK_MODEL -ErrorAction SilentlyContinue
```

## 官方来源

- [DeepSeek first API call](https://api-docs.deepseek.com/)
- [DeepSeek model list](https://api-docs.deepseek.com/api/list-models/)
- [DeepSeek Change Log](https://api-docs.deepseek.com/updates/)
- [DeepSeek Thinking Mode](https://api-docs.deepseek.com/guides/thinking_mode/)
- [DeepSeek error codes](https://api-docs.deepseek.com/quick_start/error_codes/)
- [OpenAI Python SDK error handling](https://github.com/openai/openai-python#handling-errors)
