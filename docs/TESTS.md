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

## Logi i raporty (Robot Framework)

Po każdym uruchomieniu `robot` generowane są pliki w `artifacts/logs/`:

- `log.html` – szczegółowy log krok po kroku (najlepszy do debugowania).
- `report.html` – podsumowanie wyników testów (PASS/FAIL, statystyki).
- `output.xml` – surowe dane przebiegu testów (do integracji/analizy).

### Jak czytać `log.html`
1. Otwórz `artifacts/logs/log.html` w przeglądarce.
2. Po lewej wybierz suite/test.
3. Po prawej zobaczysz listę kroków (keywordów), czasy i ewentualne błędy.
