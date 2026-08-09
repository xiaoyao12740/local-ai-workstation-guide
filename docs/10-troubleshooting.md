# 10. 故障排查：一次只修一层

## 排查顺序

```text
硬件/虚拟化 → WSL 2 → Docker Engine → Ollama API → Open WebUI
```

先执行根目录检测脚本。它只打印组件状态，不打印环境变量值：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-environment.ps1
```

本章首先覆盖 V0.1 基础路线。Cloud API 与 Agent/Router 排查保留在文末“Later”小节，不属于首次本地对话的完成条件。

## WSL 无法安装或启动

| 现象 | 检查 | 安全处理 |
| --- | --- | --- |
| 虚拟化未启用 | 任务管理器 → CPU | 在 BIOS 只改 VT-x/SVM，记录原设置 |
| `0x80370102` | 虚拟化与 Virtual Machine Platform | 启用所需 Windows 功能并重启 |
| Ubuntu 是 Version 1 | `wsl -l -v` | `wsl --set-version Ubuntu 2` |
| WSL 更新失败 | Windows Update、代理、系统版本 | 先保存工作，不删除发行版 |
| 路径翻译警告 | 检查 Windows PATH 中失效盘符 | 修正单个无效项，不重装 WSL |

不要使用 `wsl --unregister` 作为普通修复命令，它会删除目标发行版的数据。

## Docker daemon 未运行

```powershell
docker version
docker info
```

- 只有 Client：Docker CLI 存在，但 Engine 没运行。
- named pipe 不存在：启动 Docker Desktop，等待 Linux Engine 就绪。
- WSL 内不可用：检查 WSL Integration。
- Docker Desktop 卡住：先保存容器工作，查看诊断；不要直接删除 Docker 数据目录。

## 端口被占用

```powershell
Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
Get-NetTCPConnection -LocalPort 11434 -ErrorAction SilentlyContinue
```

确认占用进程后再决定停止它或修改 Compose 左侧宿主端口，例如 `127.0.0.1:3001:8080`。不要随机终止不认识的系统进程。

## Ollama 客户端存在但服务不可达

```powershell
ollama --version
Invoke-RestMethod http://127.0.0.1:11434/api/tags -TimeoutSec 3
```

第二条失败时先启动 Ollama。若 Windows 成功、WSL 失败，属于跨环境网络问题；若两边都失败，先不要排查 Open WebUI。

## 模型下载失败或磁盘不足

```powershell
ollama list
Get-Volume | Select-Object DriveLetter, SizeRemaining, Size
```

- 确认模型大小和目标磁盘剩余空间。
- 检查代理、DNS 和连接中断。
- 不使用来源不明的模型镜像。
- 不自动执行 `ollama rm`；先确认模型名称和依赖。

## RAM/VRAM 不足或 OOM

1. 关闭其他高内存/GPU 应用。
2. 降低模型规模或量化等级。
3. 缩短上下文。
4. 降低并发。
5. 记录实际内存，而不是套用他人配置。

Windows AMD 核显不应被当作 CUDA 设备。没有可靠官方依据时，按 CPU/共享内存路径排查。

## Open WebUI 页面打不开

```powershell
docker compose ps
docker compose logs --tail 200 open-webui
Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
```

检查容器是否健康、端口是否映射为 `127.0.0.1:3000:8080`，以及浏览器是否访问了正确协议和端口。

## Open WebUI 看不到 Ollama 模型

1. Windows 直接访问 `/api/tags`。
2. 检查 `.env` 的 `OLLAMA_BASE_URL`。
3. 检查 Compose 展开值：`docker compose config`。
4. 检查容器日志中的连接地址。
5. 理解容器内 `localhost` 指容器本身，Windows 宿主通常使用 `host.docker.internal`。

## 云 API 401 / 403 / 404 / 429

> Later / V0.1 之后的增强内容。

| 状态 | 常见原因 |
| --- | --- |
| 401 | Key 错误、撤销、环境变量名错误 |
| 403 | 项目、地区、模型或组织权限不足 |
| 404 | Endpoint 路径或 Model ID 错误 |
| 429 | 速率、并发、试用额度、余额或预算限制 |

不要在 Issue 中粘贴完整请求 Header。诊断时记录 Provider、Endpoint 域名、Model、HTTP 状态和脱敏错误 ID 即可。

## 环境变量没有生效

PowerShell 查看是否存在但不输出值：

```powershell
if (Test-Path Env:DEEPSEEK_API_KEY) { "set" } else { "missing" }
```

Bash：

```bash
if [ -n "${DEEPSEEK_API_KEY:-}" ]; then echo set; else echo missing; fi
```

新终端不会继承旧终端的临时变量。容器也不会自动获得宿主全部环境变量，只会获得 Compose 明确传入的值。

## Agent/Router 能聊天但不能工作

> Later / V0.1 之后的高级内容。

“能返回文本”只是第一层。继续检查：

- Tool Use / Function Calling 是否被正确翻译。
- Streaming 事件是否符合客户端预期。
- Claude Code 内置模型名是否映射到真实模型。
- 路由是否区分快速/主模型。
- 上下文、最大输出和错误码是否被截断。
- Provider 是否支持 Agent 需要的能力。

若兼容层失败，先用 Provider 的最小 API 示例验证模型，再查路由日志，最后查 Agent。不要同时改 Endpoint、模型名、Key 和路由配置。

## 提交 Issue 的脱敏模板

```text
OS / WSL version:
Docker / Ollama / Open WebUI version:
Command environment: Windows PowerShell | WSL Bash | Container
Expected result:
Actual result:
HTTP status or error type:
Steps already checked:
Sensitive values removed: yes
```
