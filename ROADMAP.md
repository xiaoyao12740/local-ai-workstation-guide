# 项目路线图 / Project Roadmap

> Last verified: 2026-08-10  
> 当前公开版本：`v0.2.0-rc.1`
> 当前开发阶段：V0.2 RC；V0.3 Runtime 开始前须先完成 Issue #9

本项目使用一个仓库和连续的 Git Tag / GitHub Release 记录演进，不复制多套版本目录。V0.1 必须始终可以在不申请云 API、不安装 Coding Agent 和 CCR 的情况下独立完成。

```mermaid
flowchart LR
    V1["V0.1 Local AI"] --> V2["V0.2 Cloud AI"]
    V2 --> V3["V0.3 Coding Agent"]
    V3 --> V4["V0.4 Advanced Routing"]
```

## V0.1 — Local AI Workstation

**状态：** `v0.1.0-rc.2` 已公开；维护者本机 Runtime RC 通过，Clean Windows 黑盒测试待完成。

```text
Windows → WSL 2 → Docker → Ollama → Open WebUI
```

完成标准：硬件适配的小模型能通过 Ollama 与 Open WebUI 完成真实对话，密钥扫描通过，服务仅绑定本机回环地址。

## V0.2 — Cloud AI Workstation

**状态：** `v0.2.0-rc.1` 发布候选版；实现、维护者 Runtime、用量核对与 RC 审查已完成。

```text
V0.1 → DeepSeek API → Alibaba Cloud Model Studio / Qwen API
     → Open WebUI OpenAI-compatible connections
```

范围：

- 解释 Provider、Model、Endpoint、API Key、Token、Context、Rate Limit、Quota 与 Billing。
- 用 Windows PowerShell 环境变量和最小 Python 客户端调用 DeepSeek 与百炼按量付费 API。
- 覆盖认证失败、余额、限流、模型名与 Endpoint/Key 类型错配。
- 在 Open WebUI 同时显示本地 Ollama 模型与云端模型。
- 不讲 Coding Plan 的 Agent 用法，不把任何真实 Key 写入文件、截图或 Git。

验收证据记录在 `V0.2_VALIDATION.md`，只允许出现 Provider、Endpoint domain、Model、HTTP status、日期与结果。

## V0.3 — Coding Agent Workstation

**状态：** 未开始；V0.2 发布后重新核验官方资料。

```text
V0.2 → Claude Code → Codex → Permission Boundary → Agent Lab
```

重点不是安装数量，而是理解 `LLM → API → Agent → Tools → Shell/Files/Git` 的权限链，并在独立的 `examples/agent-lab/` 沙盒中完成可审查任务。官方登录、官方 API 与 Provider-supported compatibility 必须分层描述。

## V0.4 — Multi-Provider Agent Workstation

**状态：** 未开始；定位为 Advanced / Experimental。

```text
Providers → Gateway / CCR → Routing → Agents → Observability
```

覆盖 Provider、Credential、Client Key、Management Token、Protocol、Model Mapping、日志、备份与凭据隔离。必须区分 Anthropic 官方支持、Provider 官方兼容与社区 Router。版本、Schema 和命令在开发时重新核验，不提前固化。

## 每个版本的发布门禁

```text
Static validation
→ Runtime validation
→ Visual validation
→ Public RC
→ clean-environment or independent-user validation
→ stable release
```

## 仓库容量与拆分原则

不提交模型权重、Docker Volume、WSL VHDX、数据库、模型缓存或大型原始视频。只有出现具有独立代码、依赖、测试、Release 与用户群的软件或大型 Lab 时才拆分新仓库；文档数量增加不是拆分理由。

## 动态资料原则

模型名、价格、免费额度、Endpoint、Key 类型、UI 路径、SDK 与 Router 配置均属于动态信息。文档必须记录 `Last verified`，优先引用官方文档、官方仓库、Schema 与 Release Notes；官方未确认的内容不得写成确定事实。
