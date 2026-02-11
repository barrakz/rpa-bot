#!/usr/bin/env python3
from __future__ import annotations

import json
import os
import subprocess
import time
import traceback
import urllib.error
import urllib.request
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

from playwright.sync_api import Browser, Locator, Page, sync_playwright


HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent.parent.parent


def env_int(name: str, fallback: int) -> int:
    raw = os.getenv(name)
    if raw is None:
        return fallback
    try:
        value = int(raw)
        return value if value > 0 else fallback
    except ValueError:
        return fallback


def env_bool(name: str, fallback: bool) -> bool:
    raw = os.getenv(name)
    if raw is None:
        return fallback
    value = raw.strip().lower()
    if value in {"1", "true", "yes", "y"}:
        return True
    if value in {"0", "false", "no", "n"}:
        return False
    return fallback


CFG: Dict[str, Any] = {
    "app_name": os.getenv("POSTMAN_APP_NAME", "Postman"),
    "cdp_port": env_int("POSTMAN_CDP_PORT", 9222),
    "filter_text": os.getenv("POSTMAN_FILTER_TEXT", "LOCAL VECTOR"),
    "request_title": os.getenv("POSTMAN_REQUEST_TITLE", "PROD UPDATE SLUG"),
    "sidebar_max_x": env_int("POSTMAN_SIDEBAR_MAX_X", 520),
    "launch_timeout_ms": env_int("POSTMAN_LAUNCH_TIMEOUT_MS", 30000),
    "step_timeout_ms": env_int("POSTMAN_STEP_TIMEOUT_MS", 12000),
    "output_dir": os.getenv(
        "POSTMAN_PLAYWRIGHT_OUTPUT",
        str(REPO_ROOT / "artifacts" / "logs_postman_playwright_py"),
    ),
    "close_cdp_session": env_bool("POSTMAN_CLOSE_CDP_SESSION", True),
}


TIMELINE: List[Dict[str, Any]] = []
FLOW_START = time.time()


def mark(step: str, started: float) -> None:
    elapsed_ms = int((time.time() - started) * 1000)
    TIMELINE.append({"step": step, "elapsedMs": elapsed_ms})
    print(f"[PW-POSTMAN-PY] {step}: {elapsed_ms}ms")


def open_postman_with_cdp(app_name: str, port: int) -> None:
    subprocess.run(
        [
            "open",
            "-a",
            app_name,
            "--args",
            f"--remote-debugging-port={port}",
        ],
        check=True,
    )


def wait_for_cdp(port: int, timeout_ms: int) -> Dict[str, Any]:
    deadline = time.time() + timeout_ms / 1000.0
    url = f"http://127.0.0.1:{port}/json/version"
    while time.time() < deadline:
        try:
            with urllib.request.urlopen(url, timeout=2.0) as response:
                if response.status == 200:
                    return json.loads(response.read().decode("utf-8"))
        except (urllib.error.URLError, TimeoutError, OSError):
            pass
        time.sleep(0.15)
    raise RuntimeError(f"CDP endpoint was not reachable on port {port}.")


def pick_postman_page(browser: Browser) -> Optional[Page]:
    for context in browser.contexts:
        for page in context.pages:
            url = page.url or ""
            if (
                "desktop.postman.com" in url
                or "postman://" in url
                or url == "about:blank"
            ):
                return page
    if browser.contexts and browser.contexts[0].pages:
        return browser.contexts[0].pages[0]
    return None


def find_search_field(page: Page, timeout_ms: int) -> Locator:
    started = time.time()
    while (time.time() - started) * 1000 < timeout_ms:
        candidates = [
            page.get_by_placeholder("Search collections").first,
            page.locator('input[placeholder*="Search collections" i]').first,
            page.locator('input[aria-label*="Search collections" i]').first,
            page.get_by_role("searchbox", name="search").first,
            page.get_by_role("textbox", name="search").first,
        ]
        for candidate in candidates:
            try:
                if candidate.is_visible(timeout=250):
                    return candidate
            except Exception:
                continue
        page.wait_for_timeout(100)
    raise RuntimeError("Search collections input was not found in time.")


def click_sidebar_text(
    page: Page, title: str, sidebar_max_x: int, timeout_ms: int
) -> Dict[str, Any]:
    started = time.time()
    while (time.time() - started) * 1000 < timeout_ms:
        candidates = page.get_by_text(title, exact=True)
        count = candidates.count()
        for idx in range(count):
            element = candidates.nth(idx)
            visible = False
            try:
                visible = element.is_visible(timeout=250)
            except Exception:
                visible = False
            if not visible:
                continue
            box = element.bounding_box()
            if not box:
                continue
            if box["x"] > sidebar_max_x:
                continue
            element.click(timeout=1000, force=True)
            return {
                "clickX": box["x"],
                "clickY": box["y"],
                "matchedIndex": idx,
            }
        page.wait_for_timeout(100)
    raise RuntimeError(f"Sidebar request not found: {title}")


def run() -> int:
    output_dir = Path(CFG["output_dir"]).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)
    result_path = output_dir / "playwright_flow_result.json"
    screenshot_path = output_dir / "playwright_flow_last.png"

    browser: Optional[Browser] = None
    try:
        open_started = time.time()
        open_postman_with_cdp(CFG["app_name"], CFG["cdp_port"])
        wait_for_cdp(CFG["cdp_port"], CFG["launch_timeout_ms"])

        with sync_playwright() as playwright:
            browser = playwright.chromium.connect_over_cdp(
                f"http://127.0.0.1:{CFG['cdp_port']}"
            )
            page = pick_postman_page(browser)
            if page is None:
                raise RuntimeError("No Postman page found via CDP.")

            page.bring_to_front()
            mark("open_postman", open_started)

            search_started = time.time()
            search_field = find_search_field(page, CFG["step_timeout_ms"])
            search_field.click(timeout=1000)
            search_field.fill("")
            search_field.fill(CFG["filter_text"])
            mark("type_search_filter", search_started)

            click_started = time.time()
            click_meta = click_sidebar_text(
                page,
                CFG["request_title"],
                CFG["sidebar_max_x"],
                CFG["step_timeout_ms"],
            )
            mark("click_request", click_started)

            page.screenshot(path=str(screenshot_path))

            total_ms = int((time.time() - FLOW_START) * 1000)
            payload = {
                "status": "PASS",
                "totalMs": total_ms,
                "config": CFG,
                "timeline": TIMELINE,
                "clickMeta": click_meta,
                "screenshot": str(screenshot_path),
                "finishedAt": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
            }
            result_path.write_text(f"{json.dumps(payload, indent=2)}\n", encoding="utf-8")
            print(f"[PW-POSTMAN-PY] total: {total_ms}ms")
            print(f"[PW-POSTMAN-PY] result: {result_path}")

            if CFG["close_cdp_session"]:
                browser.close()
                browser = None

        return 0
    except Exception:
        total_ms = int((time.time() - FLOW_START) * 1000)
        payload = {
            "status": "FAIL",
            "totalMs": total_ms,
            "config": CFG,
            "timeline": TIMELINE,
            "error": traceback.format_exc(),
            "finishedAt": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        }
        result_path.write_text(f"{json.dumps(payload, indent=2)}\n", encoding="utf-8")
        print("[PW-POSTMAN-PY] FAIL")
        print(payload["error"])
        print(f"[PW-POSTMAN-PY] result: {result_path}")
        if browser is not None:
            try:
                browser.close()
            except Exception:
                pass
        return 1


if __name__ == "__main__":
    raise SystemExit(run())
