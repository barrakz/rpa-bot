# RPA Bot - Sellasist API + AutoStacja

Projekt Robot Framework dla procesu:
1. pobranie zamowienia z Sellasist przez API,
2. przygotowanie danych handoff dla AutoStacji,
3. dalszy etap desktopowy AutoStacji (obecnie skeleton `sim`/`real`).

## Szybki start

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Glowne procesy

- `process/main_api_autostacja.robot`
  - wykonuje etap API: `GET /statuses`, `GET /orders`, `GET /orders/{id}`,
  - buduje handoff i zapisuje plik `handoff_autostacja_order_<id>.json`,
  - zatrzymuje sie kontrolowanie, gdy brak `AUTOSTACJA_EXE`.

- `process/prepare_sellasist_api.robot`
  - przygotowuje kontekst API (base URL, naglowki, request template).

- `process/hybrid_api_autostacja_skeleton.robot`
  - pokazuje docelowa orkiestracje API -> AutoStacja -> API,
  - etap po AutoStacji pozostaje na request-builderach.

Uruchomienie:

```bash
robot --outputdir artifacts/logs process/main_api_autostacja.robot
```

## Konfiguracja (`.env`)

```env
SELLASIST_API_ACCOUNT=ggautolublin
SELLASIST_API_KEY=
SELLASIST_API_BASE_URL=
SELLASIST_QUEUE_LIMIT=50
DESKTOP_MODE=sim
AUTOSTACJA_EXE=
```

Dodatkowo do testow offline:

```env
SELLASIST_API_MOCK_DIR=/absolute/path/to/tests/fixtures/sellasist_api
```

## Testy

```bash
robot --outputdir artifacts/logs tests
```

## Dokumentacja

- `docs/STATUS.md`
- `docs/TESTS.md`
- `docs/ARCHITECTURE.md`
- `.local/specs/notes/Sellasist_API_kroki_endpointy.md`
