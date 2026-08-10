# Agent Lab / Agent 实验室

[中文](#中文) | [English](#english)

## 中文

这是一个无网络、无第三方依赖、无密钥的最小 Python 项目。基线实现提供平均值、最小值和最大值；代理任务见 `AGENT_TASK.md`。只允许修改这个副本，不要修改模板或仓库其他目录。

验证：

```powershell
python -m unittest discover -s tests -p "test_*.py" -v
git diff -- src tests
```

## English

This is a minimal, offline, standard-library-only Python project. The baseline calculates mean, minimum, and maximum; see `AGENT_TASK.md` for the agent task. Modify only a prepared copy, never the template or unrelated repository paths.

Validation uses the same two commands shown above.
