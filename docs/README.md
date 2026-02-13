# Dokumentacja projektu

Ten katalog opisuje aktualny stan bota, ktory dziala w modelu:
- Sellasist przez API,
- AutoStacja przez desktop RPA (skeleton `sim`/`real`).

## Struktura

- `STATUS.md` - co dziala i ograniczenia.
- `CHANGELOG.md` - historia zmian.
- `TESTS.md` - lista testow i uruchamianie.
- `ARCHITECTURE.md` - architektura i podzial modulow.
- `features/` - opisy funkcjonalnosci procesu.
- `tests/` - miejsce na rozszerzone opisy testow.

## Testy vs procesy

- `tests/` - testy jednostkowe i integracyjne keywordow.
- `process/` - scenariusze workflow robota.

Podstawowe uruchomienia:

```bash
robot --outputdir artifacts/logs tests
robot --outputdir artifacts/logs process/main_api_autostacja.robot
```
