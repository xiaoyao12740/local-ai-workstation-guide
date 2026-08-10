"""Minimal Alibaba Cloud Model Studio connectivity check with safe preflight."""

from __future__ import annotations

import sys

from common import (
    ConfigurationError,
    require_environment,
    status_message,
    validate_model_studio_base_url,
)


PROVIDER = "Alibaba Cloud Model Studio / Qwen"
PROMPT = "Reply exactly with: CLOUD_API_OK"
EXPECTED_RESULT = "CLOUD_API_OK"


def load_configuration() -> tuple[str, str, str, str]:
    """Load and validate all values before importing an SDK or sending a request."""
    api_key = require_environment("DASHSCOPE_API_KEY")
    base_url = require_environment("DASHSCOPE_BASE_URL")
    model = require_environment("DASHSCOPE_MODEL")
    domain = validate_model_studio_base_url(base_url)
    return api_key, base_url, model, domain


def bailian_status_message(status_code: int) -> tuple[str, str]:
    """Add Model Studio context without exposing the provider response body."""
    if status_code == 400:
        return "REQUEST", "Request rejected; verify model, region, workspace, API Host, and parameters"
    if status_code == 401:
        return "AUTH", "Authentication failed; verify the Key belongs to this region and API Host"
    if status_code == 403:
        return "AUTHORIZATION", "Request is not permitted for this workspace or model"
    if status_code == 404:
        return "MODEL", "Endpoint or model was not found for this region/workspace"
    return status_message(status_code)


def main() -> int:
    try:
        api_key, base_url, model, domain = load_configuration()
    except ConfigurationError as exc:
        print(f"[CONFIG] {exc}", file=sys.stderr)
        return 2

    try:
        import openai
        from openai import OpenAI
    except ImportError:
        print(
            "[DEPENDENCY] The openai package is not installed. "
            "Run: python -m pip install -r examples/cloud/requirements.txt",
            file=sys.stderr,
        )
        return 3

    client = OpenAI(api_key=api_key, base_url=base_url, timeout=30.0, max_retries=0)

    try:
        raw_response = client.chat.completions.with_raw_response.create(
            model=model,
            messages=[{"role": "user", "content": PROMPT}],
            max_tokens=16,
            stream=False,
        )
        completion = raw_response.parse()
        result = (completion.choices[0].message.content or "").strip()
    except openai.APIConnectionError:
        print(
            "[NETWORK] Request could not reach Model Studio. "
            "Check DNS, TLS, proxy settings, connectivity, and the configured API Host.",
            file=sys.stderr,
        )
        return 10
    except openai.APIStatusError as exc:
        category, message = bailian_status_message(exc.status_code)
        print(f"[{category}] {message} (HTTP {exc.status_code})", file=sys.stderr)
        return 20
    except (IndexError, AttributeError, TypeError):
        print("[RESPONSE] Provider returned an unexpected response shape.", file=sys.stderr)
        return 30

    print(f"Provider: {PROVIDER}")
    print(f"Endpoint: {domain}")
    print(f"Model: {model}")
    print(f"HTTP: {raw_response.status_code}")
    print(f"Result: {result}")
    if result != EXPECTED_RESULT:
        print(
            "[RESULT] The API call succeeded, but the model did not return the exact validation token.",
            file=sys.stderr,
        )
        return 4
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
