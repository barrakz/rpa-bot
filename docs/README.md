# Dokumentacja projektu

## Instrukcja uruchomienia (macOS)

1) Utwórz wirtualne środowisko i zainstaluj zależności:

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

2) Uruchom testy:

```bash
robot --outputdir artifacts/logs tests
```

Alternatywnie możesz użyć skryptu:

```bash
./scripts/run_tests.sh
```

## Opis struktury

### Foldery

- `docs/` – notatki i dokumentacja projektu.
- `src/keywords/` – własne keywordy Robot Framework używane w testach.
- `tests/` – testy `.robot`.
- `config/` – konfiguracje i zmienne (np. bazowe URL, przeglądarka, ścieżki do artefaktów).
- `artifacts/logs/` – logi z uruchomień (`log.html`, `report.html`, `output.xml`) i pliki pomocnicze (np. `smoke_ok.txt`).
- `artifacts/screenshots/` – miejsce na screenshoty (na razie puste).
- `scripts/` – proste skrypty pomocnicze do uruchamiania testów.

### Pliki

- `README.md` – krótkie wprowadzenie i instrukcje.
- `requirements.txt` – zależności Pythona (Robot Framework, SeleniumLibrary, opcjonalnie dotenv).
- `config/variables.robot` – zmienne projektu (BASE_URL, BROWSER, ścieżki do artefaktów).
- `tests/smoke.robot` – minimalny test smoke pokazujący strukturę i użycie keywordów.
- `src/keywords/common.robot` – wspólne keywordy (tworzenie katalogów, zapis markera).
- `.gitignore` – ignorowane pliki i katalogi (venv, artefakty, logi).
- `scripts/run_tests.sh` – uruchamianie testów z automatyczną aktywacją venv.
