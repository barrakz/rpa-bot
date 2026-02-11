# Sciezka treningowa Postman (tymczasowa)

Cel: odizolowany sandbox do cwiczenia desktop automation w Postmanie.
Wszystkie pliki sa pod `labs/postman_autostacja`, dzieki czemu pozniej mozna je usunac jednym poleceniem.

## Co zawiera

- `keywords/postman_training.robot`
  - Keywordy tylko dla Postmana: otwarcie appki, wpisanie filtra w `Search collections`.
  - Przygotowany (ale opcjonalny) krok pod klik requestu `PROD UPDATE SLUG`.
- `process/open_postman_and_filter_collection.robot`
  - Aktualny flow: open Postman + wpisanie `LOCAL VECTOR` w search + klik `PROD UPDATE SLUG`.
- `tests/postman_training_smoke.robot`
  - Smoke test w trybie dry-run, bez realnego otwierania Postmana.
- `config/postman_locators_macos.robot`
  - Konfiguracja lokatorow/parametrow pod macOS.

## Uruchamianie

Smoke (bez GUI):

```bash
./venv/bin/robot --outputdir artifacts/logs labs/postman_autostacja/tests/postman_training_smoke.robot
```

Aktualny flow (uruchamia Postmana):

```bash
POSTMAN_SIM_DRY_RUN=0 ./venv/bin/robot --outputdir artifacts/logs_postman_single labs/postman_autostacja/process/open_postman_and_filter_collection.robot
```

## Wymagane uprawnienia macOS

Klikanie elementow UI przez `System Events` wymaga uprawnienia Dostepnosci.
W `System Settings -> Privacy & Security -> Accessibility` dodaj i wlacz aplikacje terminala,
z ktorej uruchamiasz test (np. Terminal / iTerm / Codex).

## Sprzatanie

Gdy sciezka treningowa nie bedzie juz potrzebna, usun caly katalog:

```bash
rm -rf labs/postman_autostacja
```
