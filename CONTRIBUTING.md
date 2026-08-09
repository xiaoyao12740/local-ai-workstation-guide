# Contributing / 贡献指南

感谢你帮助改进这份教程。提交 Issue 或 Pull Request 时，请说明：

1. 操作系统、WSL、Docker、Ollama 等相关版本。
2. 使用的是 Windows PowerShell、WSL Bash，还是容器终端。
3. 预期结果、实际结果与完整但已脱敏的错误信息。
4. 命令来源是否为官方文档，并附上链接与访问日期。

## Documentation rules

- 每条命令必须标明运行环境。
- 安装步骤必须提供验证方法和常见失败处理。
- 硬件建议只能写经验范围，不得虚构跑分或 tokens/s。
- 不提交模型权重、数据卷、聊天记录、日志或真实凭据。
- 新增外部工具时，必须区分官方组件与社区兼容层。

## Secret check

提交前检查：

```bash
git status --short
git diff --cached
```

若凭据曾进入 Git 历史，必须立刻撤销并轮换；仅删除文件不够。

