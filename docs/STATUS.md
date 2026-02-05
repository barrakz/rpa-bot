# Status projektu

## Działające funkcjonalności

- Uruchamianie testów Robot Framework lokalnie na macOS.
- Test smoke zapisujący marker `smoke_ok.txt` do `artifacts/logs/`.
- Test web (Safari): otwarcie przeglądarki i nawigacja do `https://www.wp.pl`.
- Test web (Safari): otwarcie strony logowania SellAsist (bez wpisywania danych).
- Workflow: krok `open_sellasist` (otwarcie strony logowania).
- Tryb wielo-środowiskowy (macOS/Windows) z automatycznym doborem przeglądarki.
- Bundle Windows v1.0 (Chrome) do demonstracji „otwórz login SellAsist”.

## Środowisko

- macOS + Python venv
- Robot Framework + SeleniumLibrary
- Safari z `safaridriver` (wbudowany w macOS)
- Windows (docelowo) z Chrome (bundle + skrypt run.bat)

## Znane ograniczenia

- Brak automatyzacji UI Windows (planowane docelowo na inny etap).
- Selenium nie wpisuje adresu w pasek URL przeglądarki — używamy `Go To`.

## Następne kroki (propozycje)

- Ustalić standard asercji dla stron (mniej kruche niż pełny tytuł).
- Rozszerzyć testy o proste interakcje na stronie (kliknięcie, sprawdzenie elementu).
- Dodać bazowy model logowania/test tags.
- Dodać lokalną bazę procesową (np. SQLite) na komputerze docelowym do zapisu przebiegu, błędów i kroków.
