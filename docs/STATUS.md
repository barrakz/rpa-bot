# Status projektu

## Działające funkcjonalności

- Uruchamianie testów Robot Framework lokalnie na macOS.
- Test smoke zapisujący marker `smoke_ok.txt` do `artifacts/logs/`.
- Test web (Safari): otwarcie przeglądarki i nawigacja do `https://www.wp.pl`.
- Test web (Safari): otwarcie strony logowania SellAsist (bez wpisywania danych).
- Workflow: krok `open_sellasist` (otwarcie strony logowania).

## Środowisko

- macOS + Python venv
- Robot Framework + SeleniumLibrary
- Safari z `safaridriver` (wbudowany w macOS)

## Znane ograniczenia

- Brak automatyzacji UI Windows (planowane docelowo na inny etap).
- Selenium nie wpisuje adresu w pasek URL przeglądarki — używamy `Go To`.

## Następne kroki (propozycje)

- Ustalić standard asercji dla stron (mniej kruche niż pełny tytuł).
- Rozszerzyć testy o proste interakcje na stronie (kliknięcie, sprawdzenie elementu).
- Dodać bazowy model logowania/test tags.
