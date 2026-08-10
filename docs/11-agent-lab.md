# 11. Agent 实战：hello-agent

## 本章目标

在一个无真实凭据、无重要文件、可随时删除的独立仓库中，让 Coding Agent 完成：读取规范、创建代码、运行测试、修复错误、展示差异，并在人工确认后提交。

## 为什么单独建仓库

不要把第一次 Agent 实验放在个人主页、毕业设计、现有 Docker 环境或主目录中。隔离仓库让权限和差异更容易审查。

## 创建练习区

Windows PowerShell：

```powershell
New-Item -ItemType Directory -Path hello-agent
Set-Location hello-agent
git init -b main
```

WSL/Linux：

```bash
mkdir hello-agent
cd hello-agent
git init -b main
```

创建 `README.md`：

```markdown
# hello-agent

Build a Python command-line program that accepts a name and prints
`Hello, <name>!`. Add unit tests and usage instructions.

Constraints:
- Python standard library only.
- Do not access the network.
- Do not modify files outside this repository.
- Do not commit until the user reviews the diff.
```

先人工提交任务基线：

```bash
git add README.md
git commit -m "chore: add agent exercise specification"
git switch -c exercise/agent-run
```

## 给 Agent 的任务

```text
Read README.md and inspect the repository. Implement the smallest solution that
satisfies the specification. Add unit tests, run them, and show me the complete
diff and test output. Do not use the network, do not access files outside this
repository, and do not create a Git commit until I approve it.
```

## 学习者应该观察什么

1. Agent 是否先读取规范，而不是直接堆代码。
2. 创建了哪些文件，是否超出范围。
3. 使用了什么命令，是否请求网络或管理员权限。
4. 测试是否真的执行，而非只声称通过。
5. 失败时是否阅读错误并做最小修复。
6. 最终差异是否清晰、没有缓存和临时文件。

## 人工验收

```bash
git status --short
git diff --check
git diff
python -m unittest discover -v
```

手动测试：

```bash
python app.py Alice
```

预期输出：

```text
Hello, Alice!
```

检查通过后，由用户决定是否提交：

```bash
git add README.md app.py tests
git diff --cached
git commit -m "feat: complete hello-agent exercise"
```

## 第二轮：故意引入一个错误

在新分支修改测试，要求空名字返回非零退出码并显示帮助。让 Agent 先运行测试看到失败，再实现边界处理。这样可以观察它是否基于证据调试，而不是重写全部程序。

## Claude Code 与 Codex 的对比实验

若你同时合法拥有两种 Agent 渠道，可在两个独立分支重复同一任务，比较：

- 首次方案是否满足规范。
- 工具和命令调用是否清晰。
- 测试失败后的修改范围。
- 最终差异大小与可读性。
- Token/费用和人工审查时间。

不要只比较“哪个回答看起来更聪明”，更要比较可审查性和完成任务的总成本。

## 完成后的状态

你完成了一个真实但低风险的 Agent 循环，并亲自检查了文件、命令、测试、差异和 Git 提交。

---

### 课程导航 / Course navigation

[← 上一篇：故障排查 / Previous: Troubleshooting](10-troubleshooting.md) | [课程首页 / Course home](../README.md) | [下一篇：最终验收 / Next: Acceptance →](12-acceptance.md)
