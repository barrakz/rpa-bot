# Architektura i struktura

## Przegląd

Projekt oparty o Robot Framework z wydzielonymi keywordami i konfiguracją. Testy są uruchamiane lokalnie na macOS.
Docelowe środowisko wykonawcze to Windows z Chrome, przy zachowaniu wspólnej bazy kodu.

Aktualny kierunek integracyjny:
- Sellasist przez API (warstwa `sellasist_api`),
- AutoStacja przez desktop RPA/UIA na Windows (`autostacja_windows`),
- web Selenium dla Sellasist pozostaje jako fallback.

## Struktura kodu

- `tests/` – scenariusze testowe `.robot`.
- `process/` – kroki workflow (scenariusze procesu, składane w całość).
  - `prepare_sellasist_api.robot` – bootstrap warstwy API.
  - `hybrid_api_autostacja_skeleton.robot` – referencyjny przepływ API -> desktop -> API.
- `src/keywords/` – własne keywordy reużywalne w testach.
  - `sellasist.robot` – web fallback (Selenium).
  - `sellasist_api.robot` – szkielet warstwy API (bez wywołań HTTP).
  - `sellasist_api_orders.robot` – standardowe metody API (request builders) dla zamówień.
  - `autostacja.robot` / `autostacja_sim.robot` / `autostacja_windows.robot` – warstwa desktop AutoStacji.
- `config/` – zmienne i konfiguracja środowiska.
- `artifacts/` – logi i pliki generowane podczas uruchomień.
- `bundle/` – paczki uruchomieniowe (Windows) dla użytkowników nietechnicznych.

## Zależności

- `robotframework`
- `robotframework-seleniumlibrary`
- `python-dotenv` (opcjonalnie, na przyszłość)

## Dobór środowiska

Skrypt i keyword `Open Browser To Blank` wybierają przeglądarkę na podstawie:
- `BROWSER` (jawny wybór),
- `RPA_ENV` (mac/win),
- wykrytego systemu.

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
