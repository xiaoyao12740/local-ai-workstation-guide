# Cloud API examples / 云 API 示例规划

> Status: V0.2 Planning. No provider call is performed by this file.

后续最小示例将遵循同一接口：

```text
environment variable
→ provider base URL
→ model ID from environment/config
→ one non-stream chat request
→ sanitized status/result
```

计划文件：

```text
examples/cloud/
├── README.md
├── requirements.txt
├── common.py
├── deepseek_chat.py
└── bailian_chat.py
```

实现要求：

- Key 只从 `DEEPSEEK_API_KEY` 或 `DASHSCOPE_API_KEY` 读取。
- 模型名可配置，不把高变化的“当前模型”固化为永久默认。
- 缺少 Key 时在发出网络请求前安全退出。
- 不打印 Key、Authorization Header 或完整异常请求对象。
- 401/402/403/429 与 5xx 给出不同的可行动提示。
- 示例语法可在 CI 中离线检查；真实调用只进入人工 Runtime Validation。

在实现提交前，本目录不会宣称任何云 Provider 已通过真实调用。
