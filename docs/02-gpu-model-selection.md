# 02. 硬件、显存与本地模型选择

> [!NOTE]
> **教程阶段 / Guide stage:** V0.1 · 本地 AI 工作站 / Local AI Workstation
> **阅读范围 / Reading range:** 主线第 00–05 章 / Main guide Chapters 00–05
> **前置内容 / Prerequisite:** 按主线顺序阅读；第 00 章无需前置知识。 / Follow the main sequence; Chapter 00 has no prerequisite.

> Last verified: 2026-08-09
> 模型标签、文件体积和运行时支持会变化，请在下载前复查 Ollama 官方模型库与文档。

## 本章目标

- 分清 CPU、RAM、GPU、VRAM、共享内存和磁盘。
- 使用“推荐 / 可尝试 / 不建议”而不是绝对容量公式。
- 为普通轻薄本选择用于学习和联调的小模型。
- 用 `ollama ps` 验证真实 CPU/GPU Offload，不靠猜测。

## 先纠正两个误区

**显存不等于系统内存。** 独立显卡通常有专用 VRAM；集成显卡会共享系统内存，但共享容量不等于具备 CUDA/ROCm 能力，也不等于同等性能。

**模型文件大小不等于实际运行内存。** 运行时还需要 KV Cache、上下文、Ollama Runtime、操作系统、Docker/Open WebUI、GPU/CPU Offload 和其他程序的空间。

## 低配置案例，不是推荐配置

本项目最初的一套环境是 Ryzen 5 5625U、16GB RAM、AMD Vega 集成显卡的轻薄笔记本。它不是推荐的大模型推理硬件，而是一个**低配置工具链可行性案例**：即使本地算力有限，学习者仍能搭建 WSL 2、Docker、Ollama、Open WebUI、云 API 和 Coding Agent。

这台机器的限制包括：

- 无大容量独立显存。
- Vega 核显不在 Ollama Windows ROCm 明确支持表中。
- CPU 推理与内存带宽有限。
- 16GB RAM 还要供 Windows、WSL、Docker 和其他程序使用。
- 轻薄本持续满载受散热和功耗限制。

因此，“成功加载一次”不能写成“推荐日常使用”。这台机器更适合小模型学习，本地重任务应交给更强硬件或合法云 API。

### 能力上限不等于可用速度

模型发布时间较新、架构较强或官方标注支持推理，只能说明模型本身可能具备相应能力，不能据此推导它在任意电脑上都能快速响应。实际体验还受到 CPU/GPU、RAM/VRAM、内存带宽、量化、Context、输出长度、是否启用 Thinking，以及散热和持续功耗限制影响。

本项目测试机运行 `qwen3.5:4b` 时，一次普通中英双语自我介绍在 Open WebUI 中显示“思考用时 5 分钟”。这不是经过控制变量的性能测试，不能推广到所有 Ryzen 5 5625U 或同型号电脑；它只作为物理边界案例说明：无独显轻薄本可以完成部署和推理验证，但复杂推理、长回复、高频 Agent 调用可能很慢。不要把“模型成功加载”或“最终生成了高质量答案”误写成“硬件适合日常高负载推理”。

## 同级轻薄本的三级建议

适用条件：移动端 Ryzen 5/Core i5 级 CPU、16GB RAM、无独显。

### 推荐体验：1B–4B Q4

适合：

- 验证 Ollama 与 Open WebUI。
- 简单聊天和文本任务。
- 学习 API 与 Agent 数据流。
- 在不追求速度的情况下完成本地联调。

截至核验日期，可从 `qwen3.5:4b` 开始；Ollama 模型库显示其 Q4_K_M 标签约 3.4GB。标签变化时以 [Qwen3.5 tags](https://ollama.com/library/qwen3.5/tags) 为准。

### 可以尝试：7B–9B Q4

**可以尝试不等于推荐配置。** 条件包括后台程序较少、Context 保守、单用户、散热良好，并接受较慢响应和持续 CPU 高负载。

当前可用于实验的代表标签：

| 模型标签 | 官方页面文件体积 | 定位 |
| --- | ---: | --- |
| `qwen3.5:9b` | 约 6.6GB | 综合能力实验档 |
| `deepseek-r1:8b` | 约 5.2GB | 推理模型体验档 |

不要承诺流畅、长 Context、Agent 高频调用或多模型并发。

### 不建议作为日常方案：14B+

`deepseek-r1:14b` 文件约 9GB，16GB 机器理论上可能加载某些量化版本，但系统和 KV Cache 余量小，应列为谨慎实验而非默认推荐。`deepseek-r1:32b` 文件约 20GB，不适合作为 16GB RAM 无独显的常规方案。

## 独立显卡经验范围

以下只是保守起点，不是“一定能跑”的公式：

| 可用 VRAM | 建议起步 | 备注 |
| ---: | --- | --- |
| 4–6GB | 3B–4B Q4 | 控制 Context，关闭其他 GPU 应用 |
| 8GB | 7B–8B Q4 | 日常单用户实验，保留 KV Cache 空间 |
| 12GB | 7B–14B Q4 | 14B 的速度与 Context 需实测 |
| 16GB | 14B Q4 或更小模型高质量量化 | Agent 应先测试工具调用和长上下文 |
| 24GB | 30B–32B Q4 级别 | 仍需考虑 Context 与桌面占用 |
| 48GB+ / 多卡 | 70B Q4 级别（取决于后端） | 需验证多卡、功耗和加载方式 |

模型参数量、架构、量化、Context 和后端不同，不能写成“8GB VRAM 一定适合 8B”。

## AMD Vega：CPU 基线 + Vulkan 可实验

Ryzen 5 5625U 的 Vega 核显不在 Ollama Windows ROCm 官方明确支持列表，因此不保证 ROCm 加速。Ollama 当前还提供 Windows/Linux Vulkan 后端；官方文档说明安装相应后端时 Vulkan 默认启用，并讨论了 iGPU/dGPU 场景。

教程口径：

- ROCm：不假设可用。
- Vulkan：可能获得部分 GPU Offload，但不保证。
- CPU：最低可靠路径。

实际验证：

```powershell
ollama ps
```

`PROCESSOR` 可能显示 `100% CPU`、`100% GPU` 或类似 `48%/52% CPU/GPU`。这比任务管理器猜测更可靠。不要为了尝试 Offload 重装驱动或破坏现有环境。

参考：[Ollama GPU support](https://github.com/ollama/ollama/blob/main/docs/gpu.mdx) 与 [Ollama FAQ](https://github.com/ollama/ollama/blob/main/docs/faq.mdx)。

## Context 会显著增加内存

模型页面标注 128K/256K 不表示普通电脑应该把 Context 拉满。Ollama 当前官方默认：

- 低于 24 GiB VRAM：4K。
- 24–48 GiB VRAM：32K。
- 48 GiB 及以上：256K。

官方也说明 Agent/Coding 等任务常需要更长上下文，但增大 Context 会增加内存。普通电脑先用默认值稳定运行，再逐步提高并观察 `ollama ps`，不要一开始设为 64K/128K。

参考：[Ollama context length](https://github.com/ollama/ollama/blob/main/docs/context-length.mdx)。

## 混合工作站才是重点

```text
小型 Local LLM：隐私、本地验证、基础任务
        +
Cloud LLM API：复杂推理、长上下文、重型 Coding
        +
Docker / Open WebUI / Agent：统一工程体验
```

教程不鼓励“没有好显卡也硬跑大模型”。它要证明的是：高性能本地推理需要硬件，但学习完整 AI 工程工作流不以高端 GPU 为前提。

## 性能记录要求

没有实际测试时不填写 tokens/s、首 Token 延迟、温度、功耗或加载时间。将来展示实测必须记录：设备、模型、量化、Context、Ollama 版本、操作系统、测试日期，并注明结果只代表该设备和环境。

## 完成后的状态

你应能为自己的设备选择“推荐/可尝试/不建议”层级，解释模型文件与运行内存的区别，并通过 `ollama ps` 确认真实处理器分配。

---

### 教程导航 / Guide navigation

[← 上一篇：虚拟化与 WSL 2 / Previous: Virtualization](01-virtualization-wsl.md) | [教程首页 / Guide home](../README.md) | [下一篇：Docker / Next: Docker →](03-docker.md)
