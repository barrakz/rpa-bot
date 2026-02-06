# Testy

## Lista testów

- `tests/smoke.robot`
  - Cel: szybka weryfikacja, że projekt działa i zapisuje artefakt.
  - Wynik: zapisuje `artifacts/logs/smoke_ok.txt`.

- `tests/open_wp.robot`
  - Cel: uruchomienie Safari i nawigacja do `https://www.wp.pl`.
  - Asercja: tytuł strony.

- `tests/sellasist_login_page.robot`
  - Cel: otwarcie strony logowania SellAsist i próba logowania danymi testowymi.
  - Asercja: obecność pól login/hasło, poprawny URL oraz wysłanie formularza.

## Workflow

- `process/open_sellasist.robot`
  - Cel: krok workflow otwierający stronę logowania SellAsist i wykonujący testowe logowanie.
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

## Skrypty uruchomieniowe

- Workflow demo na macOS:

```bash
scripts/run_mac.sh
```

- Lokalny run na Windows (developer):

```bat
scripts\\run_win.bat
```

## Wybór przeglądarki i środowiska

Sterowanie odbywa się przez zmienne środowiskowe:
- `RPA_ENV` = `mac` | `win`
- `BROWSER` = `safari` | `chrome` | `firefox` | ...

Przykład (macOS):
```bash
RPA_ENV=mac BROWSER=safari robot --outputdir artifacts/logs process/open_sellasist.robot
```

Przykład (Windows):
```bat
set RPA_ENV=win
set BROWSER=chrome
robot --outputdir artifacts\\logs process\\open_sellasist.robot
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

### Zalecany tryb: logi z timestampem

Skrypt `scripts/run_tests.sh` zapisuje logi w podfolderze z timestampem, np.:
`artifacts/logs/2026-02-04_14-30-05/`

Dzięki temu logi nie są nadpisywane między uruchomieniami.

### Jak czytać `log.html`
1. Otwórz `artifacts/logs/log.html` w przeglądarce.
2. Po lewej wybierz suite/test.
3. Po prawej zobaczysz listę kroków (keywordów), czasy i ewentualne błędy.
