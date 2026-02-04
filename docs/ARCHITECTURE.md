# Architektura i struktura

## Przegląd

Projekt oparty o Robot Framework z wydzielonymi keywordami i konfiguracją. Testy są uruchamiane lokalnie na macOS.

## Struktura kodu

- `tests/` – scenariusze testowe `.robot`.
- `process/` – kroki workflow (scenariusze procesu, składane w całość).
- `src/keywords/` – własne keywordy reużywalne w testach.
- `config/` – zmienne i konfiguracja środowiska.
- `artifacts/` – logi i pliki generowane podczas uruchomień.

## Zależności

- `robotframework`
- `robotframework-seleniumlibrary`
- `python-dotenv` (opcjonalnie, na przyszłość)

## Planowane (przyszłość): baza danych procesowych

Cel: zapisywanie metadanych przebiegu procesu (audyt, raporty, restart po błędach).

### Proponowany minimalny model danych

**Tabela `process_runs`**
- `run_id` (uuid)
- `bot_id` (np. „bot-01”)
- `started_at`, `ended_at`
- `status` (PASS/FAIL)
- `error_message` (opcjonalnie)

**Tabela `orders`**
- `order_id` (ID zamówienia w SellAsist)
- `document_type` (paragon/faktura)
- `document_number` (nr paragonu/faktury)
- `payment_type` (PayU/Pobranie)
- `status` (np. processed/failed)

**Tabela `events` (opcjonalnie)**
- `event_id`
- `run_id`
- `order_id`
- `step`
- `message`
- `timestamp`

### Gdzie to przechowywać

Na start: `SQLite` (lokalnie).  
Docelowo: wspólna baza na serwerze (jeśli potrzeba skalowania i raportów).
