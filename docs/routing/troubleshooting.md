# 路由排错 / Routing Troubleshooting

## 中文

严格按链路：Agent → Profile → Client Key → Gateway 监听 → 路由规则 → 上游 Key → 协议转换 → Model ID → Provider 状态。`401/403` 先看哪一跳拒绝；`404` 看 Base URL/路径；模型错误看发现列表；无日志说明请求可能没到 Gateway；有入口无上游则看规则和凭据。

- `better-sqlite3` / `node-gyp` / 找不到 Visual Studio：预编译原生模块未下载或 Node ABI 不匹配；优先 Node 22 LTS、官方 Desktop 或官方 Docker，不建议立刻安装编译器。
- Docker Hub `auth.docker.io` 超时：不是 Compose 语法错误；保留 loopback 配置，网络恢复后重试，不把不明镜像站写成默认源。
- `ccr` shim 存在但 `dist/main/cli.js` 缺失：npm 安装中断，属于残缺安装；不要将其标为 PASS。
- UI URL 含 Token：正常鉴权设计，但 URL 属于秘密；截图前隐藏地址栏，泄露后轮换。
- Claude Code 同时报告 `apiKeyHelper` 与 `ANTHROPIC_API_KEY`：先检查 Profile 变量名，再做 presence-only 的 Process/User/Machine 检查。CCR Profile 应保留 `apiKeyHelper`；不要 `/logout`，不要打印 Key。若父进程继承了历史 Key，只在新 PowerShell 当前进程中临时移除，再从同一窗口启动 CCR。
- `ccr-app` 报 Gateway 尚未运行：Desktop 启动与 CLI 调用发生竞态。等待 `http://127.0.0.1:3456/` 返回 HTTP 200 后再运行 Profile 命令，不要反复重装。

## English

Trace the chain in order: agent, profile, client credential, gateway listener, routing decision, upstream credential, protocol transform, model ID, provider. First identify which hop produced an authentication or path error; missing logs often mean the request never reached the gateway.

On Windows, a `better-sqlite3`/`node-gyp` compiler error usually means the prebuilt native binary was unavailable or timed out. Prefer Node 22 LTS, the official Desktop release, or the official Docker route before installing a compiler. Docker Hub authentication timeouts are network failures, not Compose validation failures. A shim without `dist/main/cli.js` is an incomplete install, never a PASS.

If Claude Code reports both `apiKeyHelper` and `ANTHROPIC_API_KEY`, keep the CCR-managed helper and diagnose only variable presence before changing anything. Do not print credentials or run `/logout`. A `ccr-app` “gateway not running” error immediately after Desktop launch is usually a startup race; wait for the loopback health endpoint to return HTTP 200, then retry the profile command.

---

### 课程导航 / Course navigation

[← 上一篇：备份与安全 / Previous: Backup and security](backup-security.md) | [课程首页 / Course home](../../README.md) | [下一篇：截图验收 / Next: Screenshot acceptance →](screenshots.md)
