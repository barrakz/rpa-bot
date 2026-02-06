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
