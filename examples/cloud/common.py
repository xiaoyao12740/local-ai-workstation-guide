"""Small, dependency-free helpers shared by cloud API teaching examples."""

from __future__ import annotations

import os
from urllib.parse import urlparse


class ConfigurationError(ValueError):
    """Raised before any provider SDK is imported or network request is made."""


def require_environment(name: str) -> str:
    """Return a non-empty environment variable without exposing its value."""
    value = os.environ.get(name, "").strip()
    if not value:
        raise ConfigurationError(
            f"{name} is not set. Set it in the current shell before running this example."
        )
    return value


def endpoint_domain(base_url: str) -> str:
    """Return only the hostname that is safe to place in validation output."""
    parsed = urlparse(base_url)
    if parsed.scheme != "https" or not parsed.hostname:
        raise ConfigurationError("Provider base URL must be a valid HTTPS URL.")
    return parsed.hostname


def validate_model_studio_base_url(base_url: str) -> str:
    """Validate current official Model Studio OpenAI-compatible host patterns.

    Last verified: 2026-08-10. This is a credential misdelivery guard, not a
    substitute for TLS validation or provider authentication.
    """
    parsed = urlparse(base_url)
    hostname = endpoint_domain(base_url)
    legacy_hosts = {
        "dashscope.aliyuncs.com",
        "dashscope-intl.aliyuncs.com",
        "dashscope-us.aliyuncs.com",
    }
    workspace_host = hostname.endswith(".maas.aliyuncs.com") and hostname != "maas.aliyuncs.com"
    if hostname not in legacy_hosts and not workspace_host:
        raise ConfigurationError(
            "DASHSCOPE_BASE_URL is not in the currently documented official Alibaba Cloud "
            "Model Studio domain family. Copy the API Host from your console."
        )
    try:
        port = parsed.port
    except ValueError as exc:
        raise ConfigurationError("DASHSCOPE_BASE_URL contains an invalid port.") from exc
    if port is not None or parsed.username or parsed.password or parsed.query or parsed.fragment:
        raise ConfigurationError("DASHSCOPE_BASE_URL must not contain credentials, a port, query, or fragment.")
    if parsed.path.rstrip("/") != "/compatible-mode/v1":
        raise ConfigurationError(
            "DASHSCOPE_BASE_URL must end with /compatible-mode/v1 for this OpenAI-compatible example."
        )
    return hostname


def status_message(status_code: int) -> tuple[str, str]:
    """Map provider HTTP status to a useful category without echoing response bodies."""
    messages = {
        400: ("FORMAT", "Invalid request format"),
        401: ("AUTH", "Authentication failed"),
        402: ("BILLING", "Insufficient API balance"),
        403: ("AUTHORIZATION", "Request is not permitted"),
        404: ("MODEL", "Endpoint or model was not found"),
        422: ("PARAMETERS", "Request parameters were rejected"),
        429: ("RATE_LIMIT", "Too many requests"),
        500: ("PROVIDER", "Provider server error"),
        503: ("PROVIDER", "Provider is overloaded or unavailable"),
    }
    if status_code in messages:
        return messages[status_code]
    if 400 <= status_code < 500:
        return "CLIENT", "Provider rejected the request"
    if status_code >= 500:
        return "PROVIDER", "Provider server error"
    return "HTTP", "Unexpected HTTP status"
