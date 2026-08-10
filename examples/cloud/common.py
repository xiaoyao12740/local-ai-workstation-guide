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
