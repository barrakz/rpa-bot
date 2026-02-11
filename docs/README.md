# Dokumentacja projektu

Ten katalog służy do utrzymywania „stanu faktycznego” projektu: co działa, jakie testy istnieją, jakie były decyzje i co się zmieniło.

## Struktura

- `STATUS.md` – aktualny stan projektu (działające funkcjonalności, znane ograniczenia, co dalej).
- `CHANGELOG.md` – dziennik zmian w projekcie (krótko i rzeczowo).
- `TESTS.md` – lista testów i jak je uruchamiać.
- `ARCHITECTURE.md` – krótki opis architektury i struktury kodu.
- `features/` – opisy funkcjonalności (po jednym pliku na funkcjonalność).
- `tests/` – szczegóły testów (po jednym pliku na większy obszar testów, jeśli potrzebne).
- `decisions/` – decyzje projektowe (ADR).

## Konwencje

- Każda większa zmiana powinna mieć wpis w `CHANGELOG.md`.
- Gdy dodajesz nową funkcjonalność, dopisz plik w `features/`.
- Gdy zmieniasz architekturę lub strukturę projektu, zaktualizuj `ARCHITECTURE.md`.

## Testy vs Workflow

Projekt rozróżnia dwa sposoby uruchamiania:

- `tests/` – testy jednostkowe/smoke dla pojedynczych kroków.
- `process/` – scenariusze workflow (docelowy proces bota).

Aktualny kierunek procesu:
- SellAsist: API (warstwa przygotowana, bez endpointów biznesowych).
- AutoStacja: desktop RPA/UIA na Windows.
- Web SellAsist (Selenium): fallback i szybkie testy awaryjne.

Model wykonania:
- jeden proces robota (orkiestracja kroków),
- dwie warstwy wykonawcze: API client (SellAsist) i desktop RPA (AutoStacja).

Przykłady:

Uruchomienie pojedynczego testu:
```bash
robot --outputdir artifacts/logs tests/sellasist_login_page.robot
```

Uruchomienie wszystkich testów:
```bash
robot --outputdir artifacts/logs tests
```

Uruchomienie kroku workflow:
```bash
robot --outputdir artifacts/logs process/open_sellasist.robot
```

## Tryb wielo-środowiskowy (macOS/Windows)

Dobór przeglądarki jest automatyczny i zależny od:
1) jawnie podanego `BROWSER`,
2) zmiennej `BROWSER` w środowisku,
3) zmiennej `RPA_ENV` (mac/win),
4) wykrytego systemu.

Domyślne mapowanie:
- macOS → `safari`
- Windows → `chrome`

## Skrypty uruchomieniowe

- macOS (workflow demo):
```bash
scripts/run_mac.sh
```

- Windows (lokalny dev):
```bat
scripts\run_win.bat
```

## Bundle Windows (dla nietechnicznej osoby)

Gotowa paczka jest w:
- `bundle/windows/1.0/`
- `bundle/windows/rpa-bot-windows-1.0.zip`

Wystarczy uruchomić `run.bat` — powinien się otworzyć Chrome i strona logowania SellAsist.

Generator paczki:
```bash
scripts/build_windows_bundle.sh 1.0
```

## Sekrety i loginy (lokalnie)

Na macOS przechowuj dane dostępowe w pliku lokalnym:
`/.local/.env` (poza repo). Szablon: `.env.example`.

Przykład:
```env
SELLASIST_USER=twoj_login
SELLASIST_PASS=twoje_haslo
```
