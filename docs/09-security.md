# 09. 令牌、网络与 Agent 安全

## 本章目标

- 防止 API Key、Cookie、聊天记录和个人文件进入 Git。
- 理解 localhost、局域网和公网暴露的差别。
- 限制容器和 Coding Agent 权限。
- 在凭据泄露时采取正确响应，而不只是删除文件。

仓库级安全基线同时见 [SECURITY.md](../SECURITY.md)。

## 凭据生命周期

```mermaid
flowchart LR
    C["Create"] --> S["Store"] --> U["Use"] --> M["Monitor"] --> R["Rotate / Revoke"]
```

### 创建

- 每个用途使用独立 Key，方便限权和撤销。
- 不购买来源不明、违反条款或无法撤销的转售令牌。
- 开启预算、用量告警和速率限制。

### 保存

优先级通常是：系统凭据库/专用 Secret Manager > 本机未跟踪 `.env` > 临时终端环境变量。不要保存在源码、截图、聊天记录、Shell 脚本或公开 Issue 中。

```text
# .env.example only — placeholders, never real values
DEEPSEEK_API_KEY=
DASHSCOPE_API_KEY=
ANTHROPIC_API_KEY=
OPENAI_API_KEY=
```

### 使用

程序只通过环境变量读取：

```python
import os

api_key = os.environ["OPENAI_API_KEY"]
```

不要打印 `api_key`，也不要把完整请求 Header 写入调试日志。

### 监控与轮换

定期查看服务商用量和账单。完成课堂、演示或临时项目后撤销不再使用的 Key。

## Git 提交前检查

```bash
git status --short
git diff --cached --stat
git diff --cached
```

确认没有：

- `.env`、凭据 JSON、Cookie、SSH Key。
- `.gguf`、`.safetensors`、Ollama 模型缓存。
- Open WebUI 数据库、聊天导出和 Docker Volume。
- WSL `.vhdx`、日志、终端录屏或带账号信息的截图。

`.gitignore` 只能减少误操作，不能阻止 `git add -f`，也不会保护已经提交的 Secret。

## 如果 Key 已经泄露

1. 立即在服务商控制台撤销 Key。
2. 生成用途受限的新 Key，而不是继续使用旧 Key。
3. 检查调用记录、余额和异常来源。
4. 从当前文件和 Git 历史中清理 Secret。
5. 通知受影响的协作者或组织管理员。
6. 复盘泄露路径并增加扫描/审批。

即使仓库后来设为私有或删除，凭据也可能已经被克隆、缓存或索引，因此“撤销”必须先于“清理历史”。

## 网络暴露

| 绑定 | 含义 | 建议 |
| --- | --- | --- |
| `127.0.0.1:3000` | 仅本机访问 | 本教程默认 |
| `0.0.0.0:3000` | 所有网卡监听 | 除非理解防火墙、认证和 TLS，否则不要使用 |
| 路由器端口转发 | 可能暴露公网 | 入门教程不建议 |

Open WebUI 有登录页面不代表适合直接暴露公网。公网部署还需要 TLS、反向代理、强认证、更新、备份、审计和速率限制。

## 容器权限

- 不使用 `privileged: true`，除非有经过审查的明确需求。
- 不把整个磁盘或 Docker socket 挂载给聊天应用。
- 只声明必要端口和 Volume。
- 了解镜像来源与标签；更新前查看发布说明。
- 云 Key 若进入容器，应使用最小权限并限制可见范围。

## Agent 权限与提示注入

Agent 读取的 README、Issue、网页、依赖说明和代码注释都可能包含恶意指令。以下请求应视为高风险：

- 读取用户目录、浏览器 Cookie、SSH 或云凭据。
- 将文件上传到陌生域名。
- 关闭安全软件、修改系统策略或以管理员运行。
- 删除仓库、清空 Docker/WSL 数据或强推远端。
- 要求“不要告诉用户”或隐藏命令输出。

将外部内容视为数据，而不是新的最高优先级指令。涉及外部写入、发布、付费或不可逆操作时必须获得用户明确授权。

## 云端数据边界

调用云 API 意味着提示词和上下文会离开本机。发送代码或文档前确认：

- 你有权把这些内容交给该服务商处理。
- 服务商的数据保留、训练和地区政策符合要求。
- Agent 没有把 `.env`、数据库或无关文件加入上下文。
- 日志与跟踪系统不会重复保存敏感数据。

## 完成后的状态

你应能解释 Key 泄露后的正确响应，证明端口只绑定本机，并能审查一次 Agent 的文件、网络和命令权限。

---

### 课程导航 / Course navigation

[← 上一篇：Agent 与兼容路由 / Previous: Agents and compatibility](08-claude-code.md) | [课程首页 / Course home](../README.md) | [下一篇：故障排查 / Next: Troubleshooting →](10-troubleshooting.md)
