"""Call Bailian or DeepSeek through their OpenAI-compatible endpoints.

No key is hard-coded. Set PROVIDER and the matching environment variable.
"""

import os
from openai import OpenAI


PROVIDERS = {
    "qwen": {
        "base_url": "https://dashscope.aliyuncs.com/compatible-mode/v1",
        "key_env": "DASHSCOPE_API_KEY",
        "model": "qwen-plus",
        "label": "Alibaba Cloud Model Studio (Bailian) / Qwen",
    },
    "deepseek": {
        "base_url": "https://api.deepseek.com",
        "key_env": "DEEPSEEK_API_KEY",
        "model": "deepseek-chat",
        "label": "DeepSeek API / DeepSeek",
    },
    "openai": {
        "base_url": "https://api.openai.com/v1",
        "key_env": "OPENAI_API_KEY",
        "model": None,
        "label": "OpenAI Platform / GPT",
    },
}


def main() -> None:
    provider_name = os.getenv("PROVIDER", "deepseek").lower()
    if provider_name not in PROVIDERS:
        raise SystemExit(f"Unknown PROVIDER={provider_name!r}; choose {list(PROVIDERS)}")

    provider = PROVIDERS[provider_name]
    api_key = os.getenv(provider["key_env"])
    if not api_key:
        raise SystemExit(f"Set {provider['key_env']} in your shell; never paste it into this file.")

    client = OpenAI(api_key=api_key, base_url=provider["base_url"])
    model = os.getenv("MODEL") or provider["model"]
    if not model:
        raise SystemExit(
            "Set MODEL to a model currently available to your OpenAI project. "
            "The tutorial intentionally does not freeze a fast-changing default."
        )

    print(f"Provider: {provider['label']}\nModel: {model}")
    response = client.chat.completions.create(
        model=model,
        messages=[
            {"role": "system", "content": "You are a concise workstation verification assistant."},
            {"role": "user", "content": "Reply with: API connection successful."},
        ],
        temperature=0,
    )
    print(response.choices[0].message.content)


if __name__ == "__main__":
    main()
