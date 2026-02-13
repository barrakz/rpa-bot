# Changelog

## 2026-02-04

- Utworzono szkielet projektu Robot Framework (struktura katalogów, smoke test, keywordy, skrypty).

## 2026-02-05

- Dodano tryb wielo-środowiskowy (macOS/Windows) z automatycznym doborem przeglądarki.
- Dodano skrypty uruchomieniowe: `scripts/run_mac.sh` i `scripts/run_win.bat`.
- Dodano generator paczki Windows (bundle) i przygotowany bundle `bundle/windows/1.0`.

## 2026-02-06

- Dodano desktopowy stub otwierający `~/Desktop/NOTEPAD` po logowaniu (macOS).
- Dodano test `tests/desktop_stub.robot` dla stubu desktopowego.

## 2026-02-09

- Desktop stub działa też na Windows: otwieranie `Desktop\\NOTEPAD` przez `explorer.exe` (tworzy folder, jeśli nie istnieje).
- Skrypty Windows zapisują logi do `artifacts\\logs\\<timestamp>`.

## 2026-02-11

- Dodano szkielet warstwy SellAsist API: konfiguracja `account`, budowa bazowego URL API i nagłówków (`apiKey`) bez wykonywania requestów.
- Dodano workflow `process/prepare_sellasist_api.robot` i test `tests/sellasist_api_skeleton.robot`.
- Dodano standardowe metody API (request builders) dla zamówień: `src/keywords/sellasist_api_orders.robot`.
- Dodano test `tests/sellasist_api_orders_skeleton.robot` oraz hybrydowy workflow `process/hybrid_api_autostacja_skeleton.robot`.
- Zaktualizowano `.env.example` o `SELLASIST_API_ACCOUNT`, `SELLASIST_API_KEY`, `SELLASIST_API_BASE_URL`.
- Zaktualizowano dokumentację: kierunek integracji to SellAsist API + AutoStacja desktop RPA; web SellAsist zostaje jako fallback.
- Dodano `labs/` do `.gitignore` (materiały laboratoryjne lokalne, poza repo).

## 2026-02-12

- Dodano główny proces `process/main_api_autostacja.robot`: pobranie statusów i kolejki NO-LU_AutohausOtto, pobranie szczegółów zamówienia, zapis handoff dla AutoStacji.
- Dodano wykonanie GET dla SellAsist API w `src/keywords/sellasist_api.robot` (w tym tryb mock przez `SELLASIST_API_MOCK_DIR`).
- Dodano testy offline pod główny etap API: `tests/sellasist_api_main_flow.robot` i `tests/main_api_autostacja_process_keywords.robot` oraz fixture JSON.
- Proces główny zatrzymuje się kontrolowanie przed desktopowymi krokami AutoStacji, jeśli `AUTOSTACJA_EXE` nie jest ustawione.
- Dopracowano normalizację payloadów API (`list`/`dict`) dla statusów, kolejki i szczegółów zamówienia, aby flow był odporny na warianty odpowiedzi.
- Ujednolicono dokumentację pod aktualny stan: GET-y działają w głównym flow, a mutacje POST/PUT pozostają na etapie request-builderów.
- Usunięto przeglądarkowy fallback SellAsist (procesy, keywordy i testy Selenium) oraz powiązaną dokumentację.
- Skrypty uruchomieniowe (`run_mac.sh`, `run_win.bat`, bundle `run.bat`) przełączono na `process/main_api_autostacja.robot`.
