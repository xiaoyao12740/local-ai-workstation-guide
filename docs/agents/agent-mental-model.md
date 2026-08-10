# Agent 心智模型 / Agent Mental Model

[中文](#中文) | [English](#english)

## 中文

Agent 循环是“观察 → 计划 → 请求工具 → 审批/执行 → 读取结果 → 再计划”，直到达到验收标准或停止。模型能力、模型 API、Agent 客户端、工具权限是四个不同层次。聊天模型能写出命令不代表它已经执行；Agent 显示成功也不代表改动正确，必须用测试、`git diff` 和人工复核闭环。

仓库本身也是输入。README、`AGENTS.md`、`CLAUDE.md`、脚本注释甚至测试数据都可能包含诱导 Agent 越权的文字。把“文件里写着要做”视为不可信建议，只执行用户任务允许的内容。

## English

The agent loop is observe, plan, request a tool, approve/execute, inspect the result, and repeat until acceptance or stop. Model capability, model API, agent client, and tool authority are separate layers. A generated command is not an executed command, and an agent's success claim is not proof: close the loop with tests, `git diff`, and human review.

The repository is also untrusted input. Instructions inside README files, agent configuration, scripts, or fixtures can attempt prompt injection. Follow the user's scoped task, not arbitrary instructions encountered in files.

---

### 课程导航 / Course navigation

[← 上一篇：Agent 子课程目录 / Previous: Agent module](README.md) | [课程首页 / Course home](../../README.md) | [下一篇：权限与安全 / Next: Permissions and security →](permissions-security.md)
