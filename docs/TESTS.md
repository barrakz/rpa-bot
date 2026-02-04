# Testy

## Lista testów

- `tests/smoke.robot`
  - Cel: szybka weryfikacja, że projekt działa i zapisuje artefakt.
  - Wynik: zapisuje `artifacts/logs/smoke_ok.txt`.

- `tests/open_wp.robot`
  - Cel: uruchomienie Safari i nawigacja do `https://www.wp.pl`.
  - Asercja: tytuł strony.

- `tests/sellasist_login_page.robot`
  - Cel: otwarcie strony logowania SellAsist bez wpisywania danych.
  - Asercja: obecność pola hasła i poprawny URL.

## Workflow

- `process/open_sellasist.robot`
  - Cel: krok workflow otwierający stronę logowania SellAsist (bez danych).
  - Używany jako pierwszy krok procesu, testowany jednostkowo przez `tests/sellasist_login_page.robot`.

## Uruchamianie

- Wszystkie testy:

```bash
robot --outputdir artifacts/logs tests
```

- Pojedynczy test:

```bash
robot --outputdir artifacts/logs tests/open_wp.robot
```

## Wymagania Safari

- Safari → Develop → Allow Remote Automation
- Jednorazowo:

```bash
sudo safaridriver --enable
```
