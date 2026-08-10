"""Offline checks for V0.2 teaching helpers. No provider request is allowed."""

from __future__ import annotations

import os
import subprocess
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CLOUD = ROOT / "examples" / "cloud"
sys.path.insert(0, str(CLOUD))

from common import (  # noqa: E402
    ConfigurationError,
    endpoint_domain,
    require_environment,
    status_message,
    validate_model_studio_base_url,
)


class CommonHelpersTest(unittest.TestCase):
    def test_endpoint_domain_returns_hostname_only(self) -> None:
        self.assertEqual(endpoint_domain("https://api.deepseek.com"), "api.deepseek.com")

    def test_endpoint_domain_rejects_non_https(self) -> None:
        with self.assertRaises(ConfigurationError):
            endpoint_domain("http://api.deepseek.com")

    def test_missing_environment_value_is_safe(self) -> None:
        name = "CLOUD_TEST_VALUE_THAT_MUST_NOT_EXIST"
        os.environ.pop(name, None)
        with self.assertRaisesRegex(ConfigurationError, f"^{name} is not set"):
            require_environment(name)

    def test_status_categories_are_distinct(self) -> None:
        self.assertEqual(status_message(401)[0], "AUTH")
        self.assertEqual(status_message(402)[0], "BILLING")
        self.assertEqual(status_message(422)[0], "PARAMETERS")
        self.assertEqual(status_message(429)[0], "RATE_LIMIT")
        self.assertEqual(status_message(503)[0], "PROVIDER")

    def test_model_studio_workspace_host_is_allowed(self) -> None:
        url = "https://WORKSPACE_ID.cn-beijing.maas.aliyuncs.com/compatible-mode/v1"
        self.assertEqual(
            validate_model_studio_base_url(url),
            "workspace_id.cn-beijing.maas.aliyuncs.com",
        )

    def test_model_studio_legacy_official_host_is_allowed(self) -> None:
        self.assertEqual(
            validate_model_studio_base_url(
                "https://dashscope.aliyuncs.com/compatible-mode/v1"
            ),
            "dashscope.aliyuncs.com",
        )

    def test_model_studio_rejects_third_party_host(self) -> None:
        with self.assertRaisesRegex(ConfigurationError, "official"):
            validate_model_studio_base_url(
                "https://example.invalid/compatible-mode/v1"
            )

    def test_model_studio_rejects_wrong_path(self) -> None:
        with self.assertRaisesRegex(ConfigurationError, "compatible-mode/v1"):
            validate_model_studio_base_url(
                "https://dashscope.aliyuncs.com/apps/anthropic"
            )


class DeepSeekPreflightTest(unittest.TestCase):
    def test_missing_key_exits_before_dependency_or_network(self) -> None:
        environment = os.environ.copy()
        environment.pop("DEEPSEEK_API_KEY", None)
        environment["DEEPSEEK_MODEL"] = "MODEL_ID_FOR_OFFLINE_TEST"
        completed = subprocess.run(
            [sys.executable, str(CLOUD / "deepseek_chat.py")],
            cwd=ROOT,
            env=environment,
            capture_output=True,
            text=True,
            timeout=10,
            check=False,
        )
        self.assertEqual(completed.returncode, 2)
        self.assertIn("DEEPSEEK_API_KEY is not set", completed.stderr)
        self.assertNotIn("Traceback", completed.stderr)
        self.assertEqual(completed.stdout, "")


class BailianPreflightTest(unittest.TestCase):
    def test_missing_key_exits_before_dependency_or_network(self) -> None:
        environment = os.environ.copy()
        environment.pop("DASHSCOPE_API_KEY", None)
        environment["DASHSCOPE_BASE_URL"] = (
            "https://WORKSPACE_ID.cn-beijing.maas.aliyuncs.com/compatible-mode/v1"
        )
        environment["DASHSCOPE_MODEL"] = "MODEL_ID_FOR_OFFLINE_TEST"
        completed = subprocess.run(
            [sys.executable, str(CLOUD / "bailian_chat.py")],
            cwd=ROOT,
            env=environment,
            capture_output=True,
            text=True,
            timeout=10,
            check=False,
        )
        self.assertEqual(completed.returncode, 2)
        self.assertIn("DASHSCOPE_API_KEY is not set", completed.stderr)
        self.assertNotIn("Traceback", completed.stderr)
        self.assertEqual(completed.stdout, "")

    def test_invalid_host_exits_before_dependency_or_network(self) -> None:
        environment = os.environ.copy()
        environment["DASHSCOPE_API_KEY"] = "KEY_FOR_OFFLINE_TEST"
        environment["DASHSCOPE_BASE_URL"] = (
            "https://example.invalid/compatible-mode/v1"
        )
        environment["DASHSCOPE_MODEL"] = "MODEL_ID_FOR_OFFLINE_TEST"
        completed = subprocess.run(
            [sys.executable, str(CLOUD / "bailian_chat.py")],
            cwd=ROOT,
            env=environment,
            capture_output=True,
            text=True,
            timeout=10,
            check=False,
        )
        self.assertEqual(completed.returncode, 2)
        self.assertIn("official", completed.stderr)
        self.assertNotIn("Traceback", completed.stderr)
        self.assertEqual(completed.stdout, "")


if __name__ == "__main__":
    unittest.main()
