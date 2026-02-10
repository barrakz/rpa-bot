# Status projektu

## Działające funkcjonalności

- Uruchamianie testów Robot Framework lokalnie na macOS.
- Test smoke zapisujący marker `smoke_ok.txt` do `artifacts/logs/`.
- Test web (Safari): otwarcie przeglądarki i nawigacja do `https://www.wp.pl`.
- Test web (Safari/Chrome): otwarcie strony logowania SellAsist i wypełnienie formularza danymi (bez submitu).
- Workflow: krok `open_sellasist` (otwarcie strony logowania + wypełnienie formularza bez submitu).
- Desktop stub (macOS): otwarcie folderu `~/Desktop/NOTEPAD` po logowaniu.
- Desktop stub (Windows): otwarcie folderu `Desktop\\NOTEPAD` (tworzy folder, jeśli nie istnieje).
- Desktop automation skeleton dla AutoStacja:
  - tryb `DESKTOP_MODE=sim` (działa bez AutoStacji, zapisuje trace),
  - tryb `DESKTOP_MODE=real` (Windows + RPA.Windows) — placeholdery, do podpięcia selectorów.
- Tryb wielo-środowiskowy (macOS/Windows) z automatycznym doborem przeglądarki.
- Bundle Windows v1.0 (Chrome) do demonstracji „otwórz login SellAsist”.
- Bundle Windows v1.1 (Chrome) do demonstracji: otwórz login SellAsist + wpisz login/hasło + otwórz `Desktop\\NOTEPAD`.

## Środowisko

- macOS + Python venv
- Robot Framework + SeleniumLibrary
- Safari z `safaridriver` (wbudowany w macOS)
- Windows (docelowo) z Chrome (bundle + skrypt run.bat)

## Znane ograniczenia

- Brak automatyzacji UI Windows (planowane docelowo na inny etap).
- Selenium nie wpisuje adresu w pasek URL przeglądarki — używamy `Go To`.
- Brak realnych dostępów testowych (SellAsist/AutoStacja) i brak docelowej maszyny: testujemy tylko fundamenty (web + stub desktop).

## Następne kroki (propozycje)

- Ustalić standard asercji dla stron (mniej kruche niż pełny tytuł).
- Dodać bazowy model logowania/test tags.
- Dodać lokalną bazę procesową (np. SQLite) na komputerze docelowym do zapisu przebiegu, błędów i kroków.
