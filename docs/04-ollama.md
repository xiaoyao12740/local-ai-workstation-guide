# 04. Ollama：本地模型服务

> Last verified: 2026-08-09  
> 模型标签和运行时支持会变化，下载前请复查官方模型库。

## 本章目标

- 安装或检查 Ollama，不重复破坏已有环境。
- 根据上一章硬件建议选择一个保守模型。
- 完成命令行对话和 HTTP API 调用。
- 理解模型文件、运行进程与 Ollama 服务的区别。

## 前置条件与命令环境

- 已阅读 [硬件与模型选择](02-gpu-model-selection.md)，知道低配设备应从小模型起步。
- Windows 系统盘或模型存储盘有足够空间，并能访问 Ollama 官方下载与模型库。
- 本章 V0.1 主线命令均在 **Windows PowerShell** 运行。

## Ollama 负责什么

Ollama 提供本地模型下载、版本标签、运行时管理和 HTTP API。它不是 Docker、聊天网页或 Coding Agent；Open WebUI 和 Agent 可以把它当作一个模型后端。

## 安装

Windows 用户从 [Ollama 官方下载页面](https://ollama.com/download) 获取安装程序。Linux/WSL 用户遵循 [Ollama Linux documentation](https://docs.ollama.com/linux)。若 Windows 已安装并能访问 `11434`，不需要在 WSL 再装一份。

## 服务与客户端检查

```powershell
ollama --version
ollama list
ollama ps
```

验证 API：

```powershell
Invoke-RestMethod http://127.0.0.1:11434/api/tags
```

`ollama --version` 可能只说明客户端存在；API 可访问才说明服务正在响应。

## 选择并运行第一个模型

模型名称和标签会更新，请先查 [Ollama Library](https://ollama.com/library)。普通 CPU/核显和 16 GB 内存设备应从 1B–4B 的 Q4 级模型开始验证，不要直接下载几十 GB 的模型。

低配置首次验证使用核验日期时约 3.4GB 的 Qwen3.5 4B 标签：

```powershell
ollama pull qwen3.5:4b
ollama run qwen3.5:4b
ollama list
ollama ps
```

若该标签未来发生变化，以模型库当前标签为准。退出交互并不一定立刻释放模型；可检查 `ollama ps`。

## HTTP API

PowerShell：

```powershell
$body = @{
  model = "qwen3.5:4b"
  prompt = "只回复：本地 API 正常"
  stream = $false
} | ConvertTo-Json

Invoke-RestMethod `
  -Uri http://127.0.0.1:11434/api/generate `
  -Method Post `
  -ContentType "application/json" `
  -Body $body
```

V0.1 不提供“从 WSL Bash 调用 Windows Ollama”的快捷命令。WSL 默认 NAT 网络下，WSL 访问 Windows 服务通常需要 Windows 主机 IP；只有 mirrored networking 等特定配置才可直接使用 `127.0.0.1`。为避免新手为了一个可选测试修改 Ollama 监听地址或防火墙，本章只验证 Windows PowerShell 路线。需要跨环境联网时，请先阅读 [Microsoft WSL networking](https://learn.microsoft.com/windows/wsl/networking)。

## 模型管理

```powershell
ollama show qwen3.5:4b
ollama stop qwen3.5:4b
ollama rm qwen3.5:4b
```

`ollama rm` 会删除模型文件，教程不会自动执行。先确认名称、是否还有项目依赖以及磁盘备份策略。

## 查看 CPU/GPU 与 Context

```powershell
ollama ps
```

`PROCESSOR` 显示 CPU、GPU 或二者的 Offload 比例，`CONTEXT` 显示当前分配长度。模型库标注的最大 Context 不等于当前硬件适合的 Context；低配置设备先保留默认值。

![Qwen3.5 4B verified local inference summary](../assets/ollama/ollama-qwen35-running.svg)

本项目低配置测试机显示 `100% CPU`，这只是 CPU 推理可行性证据。支持 GPU offload 的设备可能显示 GPU 或 CPU/GPU 混合比例，不需要与图片完全一致。

## Modelfile 只需先理解

Modelfile 可以基于已有模型设置 System Prompt、参数或模板。初学阶段不要复制来源不明的模板，也不要在其中写 API Key。

## 常见问题

| 现象 | 排查 |
| --- | --- |
| 客户端版本存在但 API 不通 | 启动 Ollama 服务，检查 11434 监听 |
| 模型拉取中断 | 检查网络、代理、磁盘空间，再继续拉取 |
| OOM / 自动退出 | 换小模型或低量化，缩短上下文，关闭占用内存的软件 |
| WSL 访问不到 Windows Ollama | 先测试 Windows API，再检查 WSL 网络模式与宿主地址 |
| 输出很慢 | CPU 推理属正常可能；记录实测，不套用他人 tokens/s |

## 完成后的状态

成功现象：`ollama list` 能看到目标模型，命令行生成成功，`/api/generate` 返回响应。做到这里已经拥有可调用的本地模型服务；下一步进入 [Open WebUI](05-openwebui.md) 添加浏览器聊天界面。

---

### 课程导航 / Course navigation

[← 上一篇：Docker / Previous: Docker](03-docker.md) | [课程首页 / Course home](../README.md) | [下一篇：Open WebUI / Next: Open WebUI →](05-openwebui.md)
