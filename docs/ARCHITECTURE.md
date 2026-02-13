# Architektura

## Przeglad

Projekt oparty o Robot Framework.
Docelowy proces: Sellasist API -> AutoStacja desktop -> Sellasist API.

## Struktura kodu

- `process/`
  - `main_api_autostacja.robot` - glowny etap API + handoff.
  - `prepare_sellasist_api.robot` - bootstrap warstwy API.
  - `hybrid_api_autostacja_skeleton.robot` - referencyjny przeplyw end-to-end (skeleton).

- `src/keywords/`
  - `sellasist_api.robot` - konfiguracja API + wykonanie GET + mock mode.
  - `sellasist_api_orders.robot` - operacje domenowe zamowien i mapowanie handoff.
  - `autostacja.robot` - fasada warstwy desktop.
  - `autostacja_sim.robot` - symulacja desktop.
  - `autostacja_windows.robot` - placeholder real UIA na Windows.
  - `common.robot` - wspolne keywordy techniczne (artefakty, smoke marker).
  - `desktop_stub.robot` - prosty lokalny stub desktop.

- `config/`
  - `variables.robot` - stale konfiguracyjne.
  - `autostacja_locators.robot` - miejsce na selektory UIA.

- `tests/`
  - testy keywordow API i desktop.

## Zaleznosci

- `robotframework`
- `rpaframework`
- `python-dotenv`

## Dane i artefakty

- `artifacts/logs/` - logi uruchomien.
- `tests/fixtures/sellasist_api/` - fixture JSON do testow offline.
