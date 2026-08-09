# V0.1 Runtime Validation / 运行时验收记录

> Validation date: 2026-08-10
>
> Status: Runtime RC passed on the current maintainer workstation
>
> This is a low-end feasibility test on an existing Windows workstation, not a clean-install test or recommended hardware baseline.

## RC.2 isolated Compose validation / RC.2 隔离 Compose 验证

2026-08-10 使用仓库当前 `docker-compose.yml` 进行了隔离验证：

- Compose project：`local-ai-workstation-rc2`
- 宿主端口：`127.0.0.1:3001`（通过 `OPEN_WEBUI_PORT=3001`）
- 容器名由 Compose 自动生成：`local-ai-workstation-rc2-open-webui-1`
- 独立数据卷：`local-ai-workstation-rc2_open-webui-data`
- `GET /health`：HTTP 200，`{"status":true}`
- 容器到 `http://host.docker.internal:11434/api/tags`：HTTP 200，并返回本地 Ollama 模型列表
- 既有 `open-webui` 容器与 3000 端口在测试期间保持运行且健康

验证结束后只清理上述 RC.2 项目新建的容器、网络和空测试数据卷；既有 Open WebUI、Ollama 模型和用户数据未被改动。

## Test environment

| Item | Observed value |
| --- | --- |
| Windows | Windows 11 Enterprise, build 26100 |
| CPU | AMD Ryzen 5 5625U with Radeon Graphics |
| Visible RAM | 15.3 GiB |
| GPU | AMD Radeon integrated graphics |
| WSL | 2.7.3.0; Ubuntu running as WSL 2 |
| Docker Client / Engine | 29.4.3 / 29.4.3 |
| Docker Compose | 5.1.3 |
| Ollama | 0.31.1 |
| Open WebUI | 0.9.5, existing rolling `:main` image |
| Open WebUI image digest | `sha256:74093dadc9c6aabc23987a74fd8c2fb8d995b1a5b22e83b0036fb9d6af590e8c` |
| README default model | `qwen3.5:4b`, 4.7B, Q4_K_M |
| Browser test model | `qwen2.5:7b`, 7.6B, Q4_K_M |
| Secondary model | `phi3:mini`, 3.8B, Q4_0 |

The existing Open WebUI container predates this repository. It uses image `ghcr.nju.edu.cn/open-webui/open-webui:main`, the `open-webui` named volume, bridge networking, and host port 3000. The repository Compose was not started because its fixed container name and port would conflict with that user environment.

## Runtime PASS

| Check | Evidence |
| --- | --- |
| Docker Engine runtime | Client and Server both reported 29.4.3 |
| Ollama API | `http://127.0.0.1:11434/api/tags` returned the installed model list |
| Container → Ollama | Existing Open WebUI container retrieved `/api/tags` through `http://host.docker.internal:11434` |
| Local inference | `qwen2.5:7b` returned exactly `LOCAL_AI_OK` through Ollama `/api/generate` |
| README default inference | `qwen3.5:4b` installed successfully and returned exactly `LOCAL_AI_OK` with `think=false` |
| Processor detection | `ollama ps` reported `100% CPU`, context 4096 |
| Open WebUI health | `/health` returned HTTP 200 with `{"status":true}` |
| Browser conversation | User selected `qwen2.5:7b` in Open WebUI and received exactly `LOCAL_AI_OK`; screenshot confirmed |
| Safe stop/start | Existing `open-webui` changed running → exited → running/healthy |
| Volume continuity | Before and after restart it mounted the same `open-webui:/app/backend/data` volume |
| Image continuity | Before and after restart it used the same image and digest |

## Runtime WARN

- The existing Open WebUI publishes port 3000 on `0.0.0.0` and `::`, while the tutorial intentionally defaults to safer `127.0.0.1:3000`. Existing user configuration was not changed.
- `phi3:mini` completed inference but did not obey the exact-output prompt reliably. This is a model-behavior warning, not an Ollama transport failure.
- The host WSL process prints a path-translation warning for a stale PATH entry; it did not block the tested path and the user PATH was not changed.
- `wsl --status` localization is not parsed as a hard requirement; Ubuntu VERSION 2 was confirmed independently.
- `qwen3.5:4b` download slowed to tens of KB/s near completion and made the first-time setup substantially longer than the README reference range. The resumed pull later completed successfully.
- The first constrained `qwen3.5:4b` request used a very small `num_predict` limit while thinking was enabled and produced no final response text. Retesting with `think=false` returned exact output. This is a useful model-mode caveat, not a transport failure.
- The existing Open WebUI version is 0.9.5, not the newer release observed during documentation research. No upgrade was attempted because that could affect user data.

## NOT TESTED

- Repository `docker-compose.yml` runtime creation, because the existing `open-webui` container, port 3000, and user volume would conflict.
- Clean Windows installation without preinstalled WSL, Docker Desktop, Ollama, models, or Open WebUI.
- Windows 10, 8GB RAM, discrete GPU, fresh downloads, slow-network recovery, or first-time account creation.
- Docker `compose down` recreation. Only safe stop/start was tested; no container or Volume was deleted.

## Environment changes

- Created local Git baseline commit `fbe992a` (`chore: establish v0.1 static RC baseline`).
- Started the already-installed Docker Desktop and Ollama applications.
- Docker Desktop automatically started the pre-existing `open-webui` container because its restart policy is `always`.
- Temporarily stopped and restarted that container once; it returned healthy with the same image and Volume.
- Downloaded and retained `qwen3.5:4b` (about 3.4GB) at the user's request.
- Loaded `phi3:mini` and `qwen2.5:7b` for inference. Ollama unloads them according to its normal keep-alive behavior.
- Added this validation record and updated release status files.

## Existing environment impact

No existing container, Docker Volume, network, Ollama model, account, chat database, WSL distribution, PATH entry, or user configuration was deleted, overwritten, reset, or upgraded. The repository Compose was not started. No credential or private Open WebUI content was read.

## Status rule

The project is a **Runtime RC** on this maintainer workstation: the browser → Open WebUI → Ollama → local model → response chain was manually confirmed, and the exact README default model was installed and verified through the Ollama API. This still does not prove a clean Windows installation because WSL, Docker, Ollama, models, and Open WebUI already existed before the test. Clean Windows validation remains a later black-box test.
