# SellAsist API skeleton (bez wywołań HTTP)

## Opis
Warstwa przygotowująca integrację API SellAsist bez wykonywania requestów. Celem jest ustandaryzowanie konfiguracji i budowy URL, aby kolejne endpointy można było dopinać bez zmian architektonicznych.

## Wejścia / konfiguracja
- `SELLASIST_API_ACCOUNT` (env) – subdomena konta, np. `ggautolublin`
- `SELLASIST_API_KEY` (env) – klucz API (nagłówek `apiKey`)
- `SELLASIST_API_BASE_URL` (env, opcjonalnie) – override bazowego URL (np. test routing)
- fallbacki z `config/variables.robot`

## Zachowanie
- Rozwiązuje konto API z env/fallback.
- Buduje bazowy URL API (`https://{account}.sellasist.pl/api/v1`) lub używa override.
- Buduje nagłówki requestu (`accept: application/json`, opcjonalnie `apiKey`).
- Buduje pełny URL endpointu (np. `/attributes`).
- Zwraca template requestu (metoda, URL, nagłówki), ale nie wysyła zapytania.
- Udostępnia bazę pod standardowe metody API zamówień (`src/keywords/sellasist_api_orders.robot`).

## Artefakty
- Logi Robot Framework w `artifacts/logs/`.
- Brak połączeń sieciowych wykonywanych przez tę warstwę.
