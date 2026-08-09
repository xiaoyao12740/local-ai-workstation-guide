# V0.1 Release Candidate Checklist / 发布候选验收清单

> Review date: 2026-08-10  
> Scope: Windows 10/11 → PowerShell → WSL 2 Ubuntu → Docker Desktop → Ollama → local small model → Open WebUI.

本清单严格区分静态验证和干净电脑实测。打勾表示已经获得相应证据，不表示其他层级自动通过。

## 范围冻结

- [x] V0.1 只把 Windows 本地聊天工作站作为必做路线。
- [x] Cloud API、Claude Code、Codex 与 CCR 标为 Later/Optional。
- [x] Linux 原生、macOS、服务器、公网、反向代理和多用户不属于 V0.1。
- [x] README 明确说明 CCR 不是完成基础工作站的条件。

## 新手主线静态审计

- [x] README 从零顺序包含 WSL、硬件选型、Docker、Ollama 和 Open WebUI。
- [x] 不要求读者为了 V0.1 预先安装 Git、Python、Node.js 或 CCR。
- [x] 提供不依赖 Git 的 Download ZIP 获取方式。
- [x] 主线章节标明 Windows PowerShell 与 WSL Bash。
- [x] 需要仓库根目录的 Compose 命令已说明运行目录。
- [x] Windows 路径、WSL Home 与 `/mnt/c`、`/mnt/d` 的含义已区分。
- [x] WSL 安装要求重启时明确要求重启后重新验收。
- [x] 各主线章节包含目标、前置条件、验证、成功现象、常见问题与下一步。
- [x] README 的时间是参考范围，不是完成承诺。

## 硬件与模型保护

- [x] 默认演示标签为 `qwen3.5:4b`，并链接当前 Ollama 模型库。
- [x] README 提醒 8GB RAM 优先更小模型、约 16GB 从 1B–4B Q4 起步。
- [x] 7B/8B Q4 被标为可尝试，而不是低配推荐。
- [x] Ryzen 5 5625U / 16GB / Vega 明确标为 Low-end feasibility example。
- [x] 未编造 tokens/s、温度、功耗、加载时间或固定内存公式。
- [x] 在维护者现有环境下载并运行 README 默认模型 `qwen3.5:4b`。
- [ ] 在干净环境重新验证默认模型下载与运行。

## Docker 与网络一致性

- [x] Compose 对外映射为 `127.0.0.1:3000:8080`。
- [x] 浏览器使用 `http://localhost:3000`。
- [x] 容器自身健康检查使用 `http://localhost:8080/health`。
- [x] Open WebUI 访问 Windows Ollama 使用 `http://host.docker.internal:11434`。
- [x] 文档明确容器中的 `localhost` 指容器自身。
- [x] Compose 配置可在不启动 Engine 的情况下解析。
- [x] Docker Engine 与已有 Open WebUI 容器完成运行时健康检查。
- [ ] 使用仓库 Compose 新建隔离 Open WebUI 实例（当前与已有容器名、端口冲突）。
- [x] 浏览器使用 `qwen2.5:7b` 完成一次 Open WebUI → Ollama 对话并准确返回 `LOCAL_AI_OK`。
- [x] 安全停止/启动已有容器后，确认仍挂载同一 Volume 且恢复健康。

## 只读检查脚本

- [x] 检查 Windows 名称与 Build。
- [x] 检查固件虚拟化状态。
- [x] 检查系统盘剩余空间和可见 RAM。
- [x] 区分 WSL 命令、WSL 2 发行版、Ubuntu 与默认版本信息。
- [x] 区分 Docker CLI/Compose 与 Docker Engine 是否响应。
- [x] Engine 可用时区分 Open WebUI 容器不存在、停止或运行。
- [x] 区分 Ollama CLI 与 Ollama API 是否响应。
- [x] 独立检查 Open WebUI `/health`。
- [x] 不打印环境变量值或凭据。
- [x] 不安装、启动、停止、删除、下载或修改配置。
- [x] PowerShell 语法解析通过。

## 安全与破坏性命令

- [x] `.env`、Agent 私有配置、CCR 数据库和备份被 Git 忽略。
- [x] Secret scan 通过。
- [x] 仓库没有 GGUF、SafeTensors、VHD、SQLite 或真实用户配置。
- [x] `wsl --unregister` 明确标为会删除发行版数据，不能作为普通修复。
- [x] 未把 `docker system prune`、删卷或重置 Docker 写成一键修复。
- [x] `ollama rm` 仅作手动模型管理说明，并带删除风险提示。
- [x] LICENSE、SECURITY、DISCLAIMER 与 CONTRIBUTING 文件存在。

## 自动化与人工检查

- [x] Markdown 本地链接检查通过。
- [x] Compose 解析通过。
- [x] Python 示例语法编译通过。
- [x] PowerShell 脚本语法解析通过。
- [x] WSL Bash 脚本 `bash -n` 通过。
- [x] UTF-8 replacement-character 扫描通过。
- [x] README、Compose、文档中的端口、服务名和模型名完成一致性审计。
- [ ] 外部链接在发布当天再次抽查。
- [ ] GitHub 页面实际渲染检查（徽章、Mermaid、表格与锚点）。

## 尚未完成的真实环境验收

- [ ] 在一台没有 WSL、Docker Desktop、Ollama 的干净 Windows 电脑从 README 第一行开始执行。
- [ ] 覆盖需要 Windows 重启的 WSL 安装分支。
- [ ] 覆盖 Docker Desktop 首次启动、WSL Integration 与卡在 Starting 的排查。
- [ ] 覆盖慢速或中断网络下的镜像与模型下载提示。
- [ ] 覆盖 8GB RAM 设备的小模型替代路径。
- [ ] 由一名没有 Linux/Docker 经验的真实读者完成可用性测试。

## 当前环境 WARN / TODO

- Docker CLI 与 Compose 已安装，但核验时 Docker Engine 未运行；按范围冻结要求未主动启动。
- Ollama CLI 已安装，但核验时本地 Ollama API 未运行；按范围冻结要求未主动启动。
- 因 Engine 未运行，无法读取 Open WebUI 容器是否存在或停止；`/health` 当前不可达。
- WSL 只读命令确认 Ubuntu 与 WSL 2 存在；宿主 PATH 中存在一个失效项目，WSL 会输出路径转换警告。该警告不阻塞本教程链路，且测试过程未擅自修改用户 PATH。
- `wsl --status` 的本地化输出未被脚本确认为“默认版本 2”，但现有 Ubuntu 的 VERSION 2 已独立确认。这是 INFO，不影响现有发行版验收。

## Release Candidate 判定

当前状态：**Runtime RC passed on the maintainer workstation / 维护者本机运行时发布候选通过**。

静态验证已经完成；当前维护者机器的 Docker、Ollama、README 默认模型、本地推理、Open WebUI 健康、容器到 Ollama 网络、安全停止/启动以及浏览器真实对话均已通过。干净 Windows 从零安装尚未测试，因此可称为 `v0.1 Runtime RC`，但不能标记为最终 `v0.1.0`。

## Visual RC

- [x] README 总体架构 Mermaid 明确 V0.1 必做范围。
- [x] WSL2 成功状态运行证据摘要。
- [x] Windows 任务管理器“虚拟化：已启用”真实截图。
- [x] Docker Desktop Engine Running 真实截图。
- [x] Ollama 默认模型、量化、Processor、Context 与推理结果摘要。
- [x] Open WebUI 使用 `qwen3.5:4b` 的模型选择与中英双语真实对话截图。
- [x] 所有已加入图片均有描述性 Alt Text 和教学说明。
- [x] 已加入 SVG 与截图不含账号、Key、Token、Cookie、私人路径或无关聊天历史。
- [x] 图片本地路径有效，文件名可读。
- [x] 普通截图均小于 500KB，SVG 保持轻量。
- [x] 所有最终截图完成人工 Image Privacy Review。
- [x] Visual RC 三角色审阅完成并处理 BLOCKER / IMPORTANT。

早期 Open WebUI 原始验证截图含本地会话 UUID；AI 裁剪版本改变了部分字体/UI，因此两者都没有进入仓库。最终采用用户重新提供的无地址栏真实截图。

### Visual RC 三角色审阅

- **Reviewer A — Windows 新手：** BLOCKER 0。虚拟化位置、Docker 正常状态和最终聊天界面已有直观参照；图片说明强调不必逐像素一致。
- **Reviewer B — 开发者但未部署 LLM：** BLOCKER 0。端口、容器到宿主地址和默认模型未因截图改变；Docker 截图中的既有端口与教程安全默认值已明确区分。
- **Reviewer C — AI / DevOps：** BLOCKER 0。模型自述未作为规格或 Benchmark；100% CPU 仍定位为低配可行性案例；Runtime RC 与 Clean Windows NOT TESTED 保持区分。
- **IMPORTANT 已处理：** README 增加真实最终成果图；所有截图增加版本变化提示、用途说明和隐私审查。
- **NICE TO HAVE（不阻塞）：** 以后可在干净 Windows 终验时替换为完全按照仓库 Compose 创建的 Open WebUI 截图。
