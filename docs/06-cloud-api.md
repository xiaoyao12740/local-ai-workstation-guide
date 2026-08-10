# 06. V0.2 云端模型 API 入口

> Last verified: 2026-08-10
> 额度、Endpoint、模型和计划规则属于动态信息，使用前必须复查控制台。

## V0.2 实现状态

| 路线 | 证据等级 |
| --- | --- |
| DeepSeek API | Static + Runtime PASS |
| 阿里云百炼 / Qwen API | Static + Runtime PASS |
| Open WebUI 同时连接本地与云模型 | Isolated Runtime + Visual PASS |
| OpenAI API | Documentation only — Runtime NOT TESTED |
| Anthropic Claude API | Documentation only — Runtime NOT TESTED |

完整教程按下面顺序阅读：

1. [API 基础概念](cloud/api-basics.md)
2. [DeepSeek 最小客户端](cloud/deepseek.md)
3. [百炼 / Qwen 最小客户端](cloud/bailian.md)
4. [Open WebUI 云 Provider](cloud/openwebui-provider.md)
5. [API Key 安全与费用保护](cloud/api-security.md)
6. [分层故障排查](cloud/troubleshooting.md)
7. [V0.2 Runtime Validation](../V0.2_VALIDATION.md)

本页保留跨平台概念和 OpenAI/Claude 的静态边界说明；真实运行证据只覆盖 DeepSeek 与百炼/Qwen。

## 本章目标

- 理解平台、模型家族、API 协议和 Agent 客户端是四个不同概念。
- 使用同一个最小 Python 示例调用 OpenAI、DeepSeek 或阿里云百炼中的 Qwen。
- 理解为什么 Claude Code 与 Codex 各有原生模型渠道，以及第三方路由的边界。
- 在不把令牌写入代码的前提下完成一次真实 API 调用。

## 先把名称对齐

| 平台/公司 | 代表模型家族 | 常见 API 形态 | 更自然的 Coding Agent 路线 |
| --- | --- | --- | --- |
| Anthropic API | Claude | Anthropic Messages API | Claude Code 原生路线 |
| OpenAI Platform | GPT / Codex 系列 | Responses API、Chat Completions 等 | Codex 原生路线 |
| DeepSeek API | DeepSeek 系列 | OpenAI 兼容接口 | 通用 SDK；接 Claude Code 需兼容层 |
| 阿里云百炼 / Model Studio | Qwen / 通义千问为主，也可能提供其他模型 | DashScope 与 OpenAI 兼容接口 | 通用 SDK；接 Claude Code 需兼容层 |
| Ollama（本地） | 可下载的 Qwen、DeepSeek 衍生模型及其他开放权重模型 | Ollama API，部分工具支持 OpenAI 风格调用 | 本地 Agent 或社区路由层 |

> 百炼是模型服务平台，Qwen 是模型家族，DashScope 是其 API/SDK 名称之一。三者有关联，但不是同一个层级。

## 想使用某个模型，去哪里开通 API？

| 想使用的模型 | 官方开通/计费平台 | 获取的凭据 | 教程中的称呼 |
| --- | --- | --- | --- |
| Qwen / 通义千问 | [阿里云百炼（Model Studio）](https://bailian.console.aliyun.com/) | DashScope API Key | Qwen API（由阿里云百炼提供） |
| DeepSeek | [DeepSeek 开放平台](https://platform.deepseek.com/) | DeepSeek API Key | DeepSeek API |
| Claude | [Anthropic Console](https://console.anthropic.com/) | Anthropic API Key | Claude API |
| OpenAI GPT 系列 | [OpenAI Platform](https://platform.openai.com/) | OpenAI API Key | OpenAI API |

简单记忆：**Qwen 是模型，阿里云百炼是开通和使用 Qwen 云 API 的官方平台之一，DashScope 是调用接口/SDK 名称。**

这与本地模型不同：通过 Ollama 下载并运行 Qwen 或 DeepSeek 的本地版本时，不需要上述云 API Key，但推理会消耗本机 CPU、内存或显卡资源。云端与本地模型的版本、量化方式、上下文和能力也可能不同。

## API 不等于网页会员

购买或订阅聊天网页，通常不自动等于获得同额度的 API 调用。使用 API 时要分别确认：

- API Key 属于哪个项目或账户。
- Endpoint 是否对应目标地区与协议。
- Model 名称是否对当前账户开放。
- 输入 Token、输出 Token、缓存和工具调用如何计费。
- 是否有试用额度、到期时间和适用模型。
- 余额不足、限流或地区限制时会返回什么状态码。

百炼可能向符合条件的账户提供试用或活动额度，但额度会变化，本教程不承诺永久免费。DeepSeek 常被用于成本敏感任务，但实际价格同样以官方计费页为准。

### 百炼新人额度的当前口径

官方页面当前说明：符合条件的模型新人额度通常有效 90 天；到期或耗尽后继续推理可能收费。额度按模型独立，控制台显示的是输入与输出 Token 共同扣减的总额，不能理解为“输入一份 + 输出一份”。部分模型示例为 100 万 Token，但具体参与模型和额度以自己的控制台为准。

若控制台提供“免费额度用完即停”，成本敏感的学习账户应考虑开启，并同时设置余额和用量提醒。

参考：[Alibaba Cloud Model Studio free quota](https://help.aliyun.com/en/model-studio/new-free-quota)。

## 百炼 Key 与 Endpoint 不能混用

不同地区、计费计划和接口协议可能使用不同 Key。以下为核验日期时华北 2（北京）的重要区分：

| 用途 | Endpoint | 凭据与限制 |
| --- | --- | --- |
| 普通 OpenAI-compatible API | `https://dashscope.aliyuncs.com/compatible-mode/v1` | 普通 DashScope Key；用于常规 API 调用 |
| 试用环境（若控制台提供） | `https://trial.cn-beijing.maas.aliyuncs.com/compatible-mode/v1` | 仅使用控制台对应试用 Key/规则 |
| Coding Plan，OpenAI-compatible | `https://coding.dashscope.aliyuncs.com/v1` | Coding Plan Key；用于获准的交互式 Coding Agent |
| Coding Plan，Anthropic-compatible | `https://coding.dashscope.aliyuncs.com/apps/anthropic` | Claude Code 等 Anthropic 协议客户端，使用对应 Plan Key |

```text
普通 API Key ─────→ 普通 Endpoint
试用 Key ─────────→ 试用 Endpoint
Coding Plan Key ─→ Coding Plan Endpoint
```

不要交叉组合。Coding Plan 的用途受官方计划规则限制，不应拿来给自建 Web 后端或无关批处理服务使用。以 [百炼 Base URL 总览](https://help.aliyun.com/zh/model-studio/base-url) 和 [Codex 接入说明](https://help.aliyun.com/zh/model-studio/codex) 为准。

## 安装示例环境

在项目根目录执行：

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
```

WSL/Linux：

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
```

## 设置令牌

只在当前终端会话设置，不要写入源码。

### Windows PowerShell

```powershell
$env:DEEPSEEK_API_KEY = "粘贴你本人合法获得的 Key"
$env:DASHSCOPE_API_KEY = "粘贴你本人合法获得的 Key"
$env:OPENAI_API_KEY = "粘贴你本人合法获得的 Key"
```

### WSL/Linux Bash

```bash
export DEEPSEEK_API_KEY='粘贴你本人合法获得的 Key'
export DASHSCOPE_API_KEY='粘贴你本人合法获得的 Key'
export OPENAI_API_KEY='粘贴你本人合法获得的 Key'
```

不要把带有真实值的终端截图、日志或 Shell 历史上传到公开仓库。

## 最小调用

### DeepSeek

```powershell
$env:PROVIDER = "deepseek"
python .\examples\openai_compatible.py
```

### Qwen API（在阿里云百炼开通）

```powershell
$env:PROVIDER = "qwen"
python .\examples\openai_compatible.py
```

示例默认使用 `qwen-plus` 作为教学模型名。若控制台显示的当前可用名称不同，请设置 `$env:MODEL`，不要盲目复制过时名称。

### OpenAI

```powershell
$env:PROVIDER = "openai"
$env:MODEL = "填写你的 OpenAI 项目当前可用模型 ID"
python .\examples\openai_compatible.py
```

OpenAI 示例要求显式设置 `MODEL`。原因是模型可用性会随项目权限和产品更新变化，教程不应把快速变化的默认值永久写死。对于新的 Agent 应用，优先阅读 OpenAI 当前的 Responses API 与 Codex 文档。

## OpenAI 能否作为 Claude Code 后端？

概念上可以通过网关或社区路由层进行协议和模型名适配，但这不是 Claude Code 的原生 OpenAI Provider。适配层需要处理 Anthropic Messages 与 OpenAI 风格接口之间的差异，并可能影响：

- System Prompt 与模型行为。
- Streaming 事件格式。
- Tool Use / Function Calling。
- Prompt Caching。
- 上下文与 Token 统计。
- Claude Code 内置模型名和快慢模型路由。

因此教程给出的建议是：

1. 使用 Claude 模型时优先 Claude Code + Anthropic 官方 API。
2. 使用 OpenAI 模型进行编码 Agent 工作时优先 Codex。
3. 需要统一入口或实验不同 Provider 时，再使用社区兼容层，并把它视为可替换基础设施。
4. DeepSeek 与 Qwen 也遵循相同原则：价格只是选型维度之一，工具兼容性和任务质量必须实测。

## 验证方法

成功时脚本会打印 Provider、模型名和模型回复，但不会打印 API Key。随后检查服务商控制台的调用记录、Token 用量和费用是否符合预期。

## 常见错误

| 状态/现象 | 常见原因 | 排查顺序 |
| --- | --- | --- |
| 401 | Key 错误、过期或环境变量未生效 | 检查变量名；在控制台重新生成并轮换 |
| 403 | 模型/地区/项目无权限 | 核对 Endpoint、区域和模型授权 |
| 404 | Endpoint 或模型名错误 | 对照服务商当前文档与控制台 |
| 429 | 速率、并发、额度或余额限制 | 降低请求频率并检查配额/账单 |
| 请求成功但 Agent 失败 | 聊天兼容不等于工具调用兼容 | 检查路由层、流式事件和 Tool Use |

## 官方参考

- [OpenAI API documentation](https://developers.openai.com/api/docs/)
- [OpenAI Codex](https://developers.openai.com/codex/)
- [Anthropic Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview)
- [DeepSeek API](https://api-docs.deepseek.com/)
- [阿里云百炼 OpenAI 兼容接口](https://help.aliyun.com/zh/model-studio/compatibility-of-openai-with-dashscope)

## 完成后的状态

你应能解释四个平台与模型家族的对应关系，安全运行至少一个云 API 示例，并知道为什么“接口兼容”不等于“Agent 完美兼容”。
