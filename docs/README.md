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
