# Cloud API examples / 云 API 教学示例

> Status: V0.2 Implementation Phase 1
> Real DeepSeek request: NOT RUN

最小示例遵循同一接口：

```text
environment variable
→ provider base URL
→ model ID from environment/config
→ one non-stream chat request
→ sanitized status/result
```

当前文件：

```text
examples/cloud/
├── README.md
├── requirements.txt
├── common.py
└── deepseek_chat.py
```

实现要求：

- DeepSeek Key 只从 `DEEPSEEK_API_KEY` 读取，模型只从 `DEEPSEEK_MODEL` 读取。
- 当前模型 ID 会变化；示例没有永久默认模型。
- 缺少 Key 时在发出网络请求前安全退出。
- 不打印 Key、部分 Key、长度、Authorization Header、原始错误正文或异常请求对象。
- 400/401/402/403/404/422/429 与 5xx 分层提示；网络异常单独处理。
- 连通性 Prompt 极短、输出上限为 16 tokens、Thinking 显式关闭。
- CI 只编译并执行离线测试；真实调用只允许由维护者本机人工执行并写入脱敏 Validation。

## 离线验证

不安装依赖、不设置 Key 时也可以验证 Preflight：

```powershell
python .\examples\cloud\deepseek_chat.py
python -m unittest discover -s tests -p "test_*.py" -v
```

第一条命令应以 `[CONFIG] DEEPSEEK_API_KEY is not set...` 安全退出，不应出现 Traceback 或网络请求。

完整配置与未来真实运行步骤见 [DeepSeek 最小客户端](../../docs/cloud/deepseek.md)。目前不宣称任何云 Provider 已通过真实调用。
