# Architektura i struktura

## Przegląd

Projekt oparty o Robot Framework z wydzielonymi keywordami i konfiguracją. Testy są uruchamiane lokalnie na macOS.

## Struktura kodu

- `tests/` – scenariusze testowe `.robot`.
- `src/keywords/` – własne keywordy reużywalne w testach.
- `config/` – zmienne i konfiguracja środowiska.
- `artifacts/` – logi i pliki generowane podczas uruchomień.

## Zależności

- `robotframework`
- `robotframework-seleniumlibrary`
- `python-dotenv` (opcjonalnie, na przyszłość)
