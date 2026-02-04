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

## Sekrety i loginy (lokalnie)

Na macOS przechowuj dane dostępowe w pliku lokalnym:
`/.local/.env` (poza repo). Szablon: `.env.example`.

Przykład:
```env
SELLASIST_USER=twoj_login
SELLASIST_PASS=twoje_haslo
```
