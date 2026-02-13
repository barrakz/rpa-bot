# Status projektu

## Dzialajace funkcjonalnosci

- Glowny workflow API: `process/main_api_autostacja.robot`.
- Wykonanie `GET` do Sellasist API (`/statuses`, `/orders`, `/orders/{id}`) z obsluga `apiKey`.
- Tryb mock API przez `SELLASIST_API_MOCK_DIR`.
- Budowa payloadu handoff do AutoStacji (`document_type`, `payment_type`, `signature`, `qty`, `price`, `nip`).
- Desktop AutoStacja:
  - `DESKTOP_MODE=sim` - dziala lokalnie bez AutoStacji,
  - `DESKTOP_MODE=real` - szkielet pod Windows + `RPA.Windows`.
- Workflow pomocnicze:
  - `process/prepare_sellasist_api.robot`,
  - `process/hybrid_api_autostacja_skeleton.robot`.

## Znane ograniczenia

- Brak realnej implementacji selektorow AutoStacji w `autostacja_windows.robot`.
- W glownym flow nie sa jeszcze wykonywane mutacje API (POST/PUT) po etapie AutoStacji.
- Brak uruchomien e2e na maszynie z zainstalowana AutoStacja.

## Nastepne kroki

1. Podpiac kroki desktopowe AutoStacji w trybie `real`.
2. Dodac wykonanie `PUT /orders/{id}` dla `document_number` i zmiany statusu.
3. Dodac obsluge bledow biznesowych (braki magazynowe, fallback manualny).
