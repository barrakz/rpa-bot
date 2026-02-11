# Sciezka treningowa Postman (tymczasowa)

Cel: odizolowany sandbox do cwiczenia desktop automation w Postmanie.
Wszystkie pliki sa pod `labs/postman_autostacja`, dzieki czemu pozniej mozna je usunac jednym poleceniem.

## Co zawiera

- `keywords/postman_training.robot`
  - Keywordy tylko dla Postmana: otwarcie appki, wpisanie filtra w `Search collections`.
  - Przygotowany (ale opcjonalny) krok pod klik requestu `PROD UPDATE SLUG`.
- `process/open_postman_and_filter_collection.robot`
  - Aktualny flow: open Postman + wpisanie `LOCAL VECTOR` w search + klik `PROD UPDATE SLUG`.
- `tests/postman_training_smoke.robot`
  - Smoke test w trybie dry-run, bez realnego otwierania Postmana.
- `config/postman_locators_macos.robot`
  - Konfiguracja lokatorow/parametrow pod macOS.

## Uruchamianie

Smoke (bez GUI):

```bash
./venv/bin/robot --outputdir artifacts/logs labs/postman_autostacja/tests/postman_training_smoke.robot
```

Aktualny flow (uruchamia Postmana):

```bash
POSTMAN_SIM_DRY_RUN=0 ./venv/bin/robot --outputdir artifacts/logs_postman_single labs/postman_autostacja/process/open_postman_and_filter_collection.robot
```

## Alternatywa Playwright (Python + Electron CDP)

Scenariusz robi te same kroki:
1. otwarcie Postmana,
2. wpisanie `LOCAL VECTOR` w `Search collections`,
3. klik `PROD UPDATE SLUG` w lewym sidebarze.

Instalacja:

```bash
cd /Users/brakuzy/Code/work/rpa-bot
./venv/bin/pip install -r labs/postman_autostacja/playwright/requirements-python.txt
```

Uruchomienie:

```bash
cd /Users/brakuzy/Code/work/rpa-bot
./venv/bin/python labs/postman_autostacja/playwright/postman_flow.py
```

Wynik:
- JSON z czasami: `artifacts/logs_postman_playwright_py/playwright_flow_result.json`
- Zrzut ekranu po kliknieciu: `artifacts/logs_postman_playwright_py/playwright_flow_last.png`

Przydatne env:

```bash
POSTMAN_FILTER_TEXT="LOCAL VECTOR"
POSTMAN_REQUEST_TITLE="PROD UPDATE SLUG"
POSTMAN_SIDEBAR_MAX_X=520
POSTMAN_STEP_TIMEOUT_MS=12000
POSTMAN_LAUNCH_TIMEOUT_MS=30000
POSTMAN_CDP_PORT=9222
POSTMAN_APP_NAME="Postman"
POSTMAN_CLOSE_CDP_SESSION=1
```

## Wymagane uprawnienia macOS

Klikanie elementow UI przez `System Events` wymaga uprawnienia Dostepnosci.
W `System Settings -> Privacy & Security -> Accessibility` dodaj i wlacz aplikacje terminala,
z ktorej uruchamiasz test (np. Terminal / iTerm / Codex).

## Sprzatanie

Gdy sciezka treningowa nie bedzie juz potrzebna, usun caly katalog:

```bash
rm -rf labs/postman_autostacja
```
