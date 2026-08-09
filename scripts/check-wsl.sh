#!/usr/bin/env bash
set -u

echo "== WSL kernel =="
uname -a

echo "== Commands =="
for command_name in docker curl git python3 node npm; do
  if command -v "$command_name" >/dev/null 2>&1; then
    printf "[OK]      %s -> %s\n" "$command_name" "$(command -v "$command_name")"
  else
    printf "[MISSING] %s\n" "$command_name"
  fi
done

echo "== Connectivity =="
curl --fail --silent --show-error --max-time 3 http://127.0.0.1:11434/api/tags \
  >/dev/null && echo "[OK] Ollama API" || echo "[WARN] Ollama API unavailable"

docker info >/dev/null 2>&1 \
  && echo "[OK] Docker Engine" || echo "[WARN] Docker Engine unavailable"

echo "No secret values were printed."

