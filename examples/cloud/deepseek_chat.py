"""Minimal DeepSeek connectivity check with secret-safe output.

No request is made until both required environment variables pass preflight.
"""

from __future__ import annotations

import sys

from common import ConfigurationError, endpoint_domain, require_environment, status_message


PROVIDER = "DeepSeek"
BASE_URL = "https://api.deepseek.com"
PROMPT = "Reply exactly with: CLOUD_API_OK"
EXPECTED_RESULT = "CLOUD_API_OK"


def load_configuration() -> tuple[str, str, str]:
    """Load required values before importing an SDK or opening a connection."""
    api_key = require_environment("DEEPSEEK_API_KEY")
    model = require_environment("DEEPSEEK_MODEL")
    domain = endpoint_domain(BASE_URL)
    return api_key, model, domain


def main() -> int:
    try:
        api_key, model, domain = load_configuration()
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

    client = OpenAI(
        api_key=api_key,
        base_url=BASE_URL,
        timeout=30.0,
        max_retries=0,
    )

    try:
        raw_response = client.chat.completions.with_raw_response.create(
            model=model,
            messages=[{"role": "user", "content": PROMPT}],
            max_tokens=16,
            stream=False,
            extra_body={"thinking": {"type": "disabled"}},
        )
        completion = raw_response.parse()
        result = (completion.choices[0].message.content or "").strip()
    except openai.APIConnectionError:
        print(
            "[NETWORK] Request could not reach the provider. "
            "Check DNS, TLS, proxy settings, connectivity, and the provider status page.",
            file=sys.stderr,
        )
        return 10
    except openai.APIStatusError as exc:
        category, message = status_message(exc.status_code)
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
