# 安装 CCR / Install CCR

Last verified: 2026-08-10 (CCR Windows Desktop 3.0.20; npm package 3.0.20, Node.js `>=22`)

## 中文

本教程在 Windows 上的实际 Runtime 基线是 **CCR 官方 Windows Desktop 3.0.20**。它已完成安装、Provider 配置、`127.0.0.1:3456` Gateway、Claude Code 启动与日志验证。

从 Release 页面下载 Windows 用户对应的 `Claude-Code-Router_3.0.20.exe`，不要下载 macOS、AppImage、blockmap、YAML 或源码压缩包。安装后先配置 Provider 与模型，再建立“仅从 CCR 打开”的 Agent Profile。

### 其他安装路线的证据边界

- **npm CLI：PARTIAL / 静态与失败路径验证。** 包版本、Node engine 与帮助信息已核验；本机持久安装因 `better-sqlite3` 预构建下载超时而回退到 `node-gyp`，未作为本教程 Runtime 基线。
- **Docker：DOCUMENTED / BLOCKED BY NETWORK。** 官方构建路线和 loopback 端口配置已检查，但 Docker Hub 认证端点超时，因此未产生容器或卷。
- 不要为了 npm 回退编译盲目安装数 GB 的 Visual Studio C++ Build Tools；Windows 新手优先使用已验证的 Desktop 路线。

管理界面与 Gateway 必须仅监听 loopback。含 `ccr_web_token` 的完整管理 URL 等同密码，不能粘贴到 Issue、日志或截图；公开证据只显示无查询参数的 `http://127.0.0.1:3458`。

## English

The runtime-tested Windows baseline is **official CCR Windows Desktop 3.0.20**. Installation, provider configuration, the loopback gateway at `127.0.0.1:3456`, Claude Code launch, and runtime logs were validated.

Windows users should download `Claude-Code-Router_3.0.20.exe`, not a macOS build, AppImage, blockmap, YAML metadata, or source archive. Configure a provider and model first, then create an agent profile scoped to launches from CCR only.

The npm path is PARTIAL: package metadata and help were checked, but a native `better-sqlite3` prebuild timeout caused a `node-gyp` fallback, so npm is not the runtime baseline. The Docker path is documented but was blocked by a Docker Hub authentication timeout before any container or volume was created. Do not install a multi-gigabyte compiler toolchain merely to force the npm path.

Keep management and gateway listeners loopback-only. A full management URL containing `ccr_web_token` is a credential; publish only the token-free loopback origin.

Official sources: [CCR npm package](https://www.npmjs.com/package/@musistudio/claude-code-router), [CCR repository](https://github.com/musistudio/claude-code-router), [v3 guide](https://github.com/musistudio/claude-code-router/blob/main/docs/src/content/docs/en/guides.md), [v3.0.20 Windows release](https://github.com/musistudio/claude-code-router/releases/tag/v3.0.20), and [official Docker deployment](https://github.com/musistudio/claude-code-router/blob/main/docker/README.md).

---

### 课程导航 / Course navigation

[← 上一篇：Gateway 基础 / Previous: Gateway basics](gateway-basics.md) | [课程首页 / Course home](../../README.md) | [下一篇：凭据边界 / Next: Credential boundaries →](credential-boundaries.md)
