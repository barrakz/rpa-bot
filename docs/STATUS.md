# Status projektu

## Działające funkcjonalności

- Uruchamianie testów Robot Framework lokalnie na macOS.
- Test smoke zapisujący marker `smoke_ok.txt` do `artifacts/logs/`.
- Test web (Safari): otwarcie przeglądarki i nawigacja do `https://www.wp.pl`.
- Test web (Safari/Chrome): otwarcie strony logowania SellAsist i wypełnienie formularza danymi (bez submitu).
- Sellasist API skeleton (bez requestów): rozwiązywanie `account`, budowa URL API i nagłówków (`apiKey`), przygotowanie template requestu.
- Sellasist API standard methods (bez requestów) dla zamówień: kolejka, szczegóły, update numeru dokumentu, update statusu, notatki.
- Workflow: krok `open_sellasist` (otwarcie strony logowania + wypełnienie formularza bez submitu).
- Workflow: krok `prepare_sellasist_api` (przygotowanie kontekstu API bez wywołań HTTP).
- Workflow: `hybrid_api_autostacja_skeleton` (orkiestracja API -> AutoStacja -> API w trybie skeleton).
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

- Brak implementacji realnej automatyzacji UI AutoStacja na Windows (keywordy `real` są placeholderami).
- Selenium nie wpisuje adresu w pasek URL przeglądarki — używamy `Go To`.
- Brak realnych dostępów testowych (SellAsist/AutoStacja) i brak docelowej maszyny: testujemy tylko fundamenty (web + stub desktop).
- Brak wybranych endpointów biznesowych Sellasist API (warstwa API jest przygotowana, ale bez wywołań).

## Następne kroki (propozycje)

- Uzgodnić mapę procesu biznesowego na endpointy Sellasist API (krok -> endpoint -> payload).
- Wdrożyć endpointy Sellasist API dla pobierania/aktualizacji zamówień.
- Uzupełnić `autostacja_windows.robot` o realne selektory UIA i obsługę wyjątków.
