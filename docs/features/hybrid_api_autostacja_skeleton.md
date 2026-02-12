# Hybrydowy flow API + AutoStacja (skeleton)

## Opis
Szkielet docelowej architektury: jeden workflow robota, który łączy standardowe metody API Sellasist oraz kroki desktopowe AutoStacji.

## Wejścia / konfiguracja
- Sellasist API: `SELLASIST_API_ACCOUNT`, `SELLASIST_API_KEY`, opcjonalnie `SELLASIST_API_BASE_URL`
- AutoStacja desktop: `DESKTOP_MODE` (`sim`/`real`) oraz `AUTOSTACJA_EXE` dla `real`

## Zachowanie
- Buduje request templates API dla kroków:
  - pobranie statusów,
  - pobranie źródeł,
  - pobranie kolejki zamówień,
  - pobranie szczegółów zamówienia,
  - aktualizacja numeru dokumentu,
  - aktualizacja statusu,
  - dodanie notatki.
- Przetwarza zamówienie desktopowo w AutoStacji (na szkielecie `sim`/`real`).
- Łączy oba światy w jednym orchestration flow.

## Artefakty
- Logi Robot Framework w `artifacts/logs/`.
- W trybie `sim`: trace i przykładowe PDF z AutoStacji.
- Brak realnych wywołań HTTP w wersji skeleton.
