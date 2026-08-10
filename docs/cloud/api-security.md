# 云 API 安全与费用保护

> [!NOTE]
> **教程阶段 / Guide stage:** V0.2 · 云端模型接入 / Cloud Model Integration
> **阅读范围 / Reading range:** 第 06 章 + Cloud 专题 / Chapter 06 + Cloud section
> **前置内容 / Prerequisite:** 建议先完成 V0.1；云端调用会产生额度或费用。 / Complete V0.1 first; cloud calls may consume quota or incur cost.

> Last verified: 2026-08-10
> Scope: V0.2 — DeepSeek 与阿里云百炼按量 API；OpenAI/Claude 仅作边界说明

API Key 是可调用付费服务的凭据，不是普通配置字符串。最小安全闭环是：

```text
Create → Store → Use → Monitor → Rotate → Revoke/Delete
```

## 1. 创建与最小权限

- 只从 Provider 官方控制台创建 Key。
- 学习与生产使用不同 Key；不同 Provider、Region、Workspace 和计费计划不要共用。
- 能设置项目、模型、额度或来源限制时，采用完成任务所需的最小范围。
- 创建后立即确认费用提醒、免费额度边界和停止调用的方法。

## 2. Python 示例：只放在当前 Shell

本项目使用当前 PowerShell 进程的环境变量。关闭该窗口后变量不会自动保留；示例结束后主动清除：

```powershell
Remove-Item Env:DEEPSEEK_API_KEY -ErrorAction SilentlyContinue
Remove-Item Env:DASHSCOPE_API_KEY -ErrorAction SilentlyContinue
```

禁止把真实值放进源码、README、`.env.example`、截图、Issue、PR、日志或 Git 历史。`.env.example` 只能保留空值或显眼占位符。

本教程也不输出所谓“辅助信息”：完整 Key、前六位、后四位、长度、Authorization Header、Cookie 都不应进入公开证据。打码截图仍可能因裁剪遗漏、浏览器自动填充或元数据而泄露信息。

## 3. Open WebUI：持久化边界不同

PowerShell 临时环境变量不等于 Open WebUI Connection。管理员在网页中保存的 Provider Connection 属于持久配置；下列对象都按敏感资产处理：

- Open WebUI 管理员账户；
- 应用数据库与完整数据卷；
- `WEBUI_SECRET_KEY` 及其连续性；
- 完整备份、迁移包和 Connection 设置页。

标准 Docker 启动方式可自动生成 Secret；长期或多 Worker 部署应按官方文档配置稳定且不进入 Git 的 `WEBUI_SECRET_KEY`。删除 Connection 不等于在 Provider 端吊销 Key，删除整个 Volume 也不是单个 Key 的轮换方法。

## 4. 泄露后的正确顺序

```text
1. 在 Provider Console 立即 revoke / delete / rotate
2. 停止继续调用
3. 检查 Usage / Billing 与异常访问
4. 清理本地环境变量、Connection、日志与备份
5. 检查 Git 当前树和历史
6. 若曾提交 Git，执行历史清理并通知所有协作者更换旧克隆
```

只删除 GitHub 当前文件不能使已经泄露的 Key 恢复安全；第一步永远是 Provider 端失效凭据。

## 5. 费用保护

价格、免费额度、活动和控制台路径都是动态信息。本项目不复制长期价格表，只链接官方页面并记录核验日期。

### DeepSeek

在官方平台人工核对 Usage/Billing、API Key 使用情况和余额可用性。官方也提供余额查询 API，但 V0.2 不自动打印余额，因为金额与账户信息不需要进入教程日志。

### 阿里云百炼

按账户实际可见能力配置模型用量监控、费用告警和免费额度用完即停。免费额度按模型、地域、账户资格和活动变化，不承诺每个账户相同，也不承诺永久免费。调用后仅记录“Provider-side usage reconciled: YES/NO”，不记录金额、余额或账户 ID。

## 6. 截图与公开证据

允许公开：Provider 名、脱敏域名、模型 ID、HTTP 状态、日期、通用成功标记、裁剪后的聊天结果。

禁止公开：Key、Workspace ID、邮箱、余额、订单、账户 ID、Connection 设置页、浏览器密码管理提示、数据库或 Volume 导出。

## 官方来源

- [DeepSeek: Get User Balance](https://api-docs.deepseek.com/api/get-user-balance/)
- [阿里云百炼：模型用量](https://help.aliyun.com/zh/model-studio/model-usage-statistics)
- [阿里云百炼：账单与成本管理](https://help.aliyun.com/zh/model-studio/bill-query-and-cost-management)
- [Open WebUI: Environment configuration](https://docs.openwebui.com/reference/env-configuration/)

---

### 教程导航 / Guide navigation

[← 上一篇：Open WebUI 云 Provider / Previous: Open WebUI cloud providers](openwebui-provider.md) | [教程首页 / Guide home](../../README.md) | [下一篇：Cloud 故障排查 / Next: Cloud troubleshooting →](troubleshooting.md)
