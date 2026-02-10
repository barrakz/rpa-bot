# Changelog

## 2026-02-04

- Utworzono szkielet projektu Robot Framework (struktura katalogów, smoke test, keywordy, skrypty).
- Dodano test Selenium w Safari: `tests/open_wp.robot`.
- Dodano dokumentację uruchamiania Safari i strukturę `docs/`.
- Dodano test strony logowania SellAsist bez wpisywania danych.
- Dodano pierwszy krok workflow: `process/open_sellasist.robot`.

## 2026-02-05

- Dodano tryb wielo-środowiskowy (macOS/Windows) z automatycznym doborem przeglądarki.
- Dodano skrypty uruchomieniowe: `scripts/run_mac.sh` i `scripts/run_win.bat`.
- Dodano generator paczki Windows (bundle) i przygotowany bundle `bundle/windows/1.0`.

## 2026-02-06

- Dodano keywordy SellAsist i wpisywanie litery `a` w pole loginu.
- Zaktualizowano test oraz krok workflow o wpisywanie litery w login.
- Zaktualizowano dokumentację funkcjonalności i testów.
- Dodano testowe logowanie do SellAsist (login/hasło + kliknięcie „Zaloguj się”).
- Dodano desktopowy stub otwierający `~/Desktop/NOTEPAD` po logowaniu (macOS).
- Dodano test `tests/desktop_stub.robot` dla stubu desktopowego.
- Zmieniono logowanie SellAsist: po wpisaniu danych nie klikamy „Zaloguj się”.

## 2026-02-09

- Desktop stub działa też na Windows: otwieranie `Desktop\\NOTEPAD` przez `explorer.exe` (tworzy folder, jeśli nie istnieje).
- Login SellAsist może brać dane z `SELLASIST_USER`/`SELLASIST_PASS` (env override).
- Skrypty Windows (`scripts/run_win.bat` i bundle `run.bat`) zapisują logi do `artifacts\\logs\\<timestamp>` i przyjmują opcjonalnie `user/pass` jako argumenty.
