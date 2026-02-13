# Sellasist API (init + GET + request-buildery)

## Opis

Warstwa API przygotowujaca i obslugujaca glowny etap pobierania zamowien.

## Wejscia / konfiguracja

- `SELLASIST_API_ACCOUNT`
- `SELLASIST_API_KEY`
- `SELLASIST_API_BASE_URL` (opcjonalnie)
- `SELLASIST_API_MOCK_DIR` (opcjonalnie, testy offline)

## Zachowanie

- Rozwiazuje konto i bazowy URL (`https://{account}.sellasist.pl/api/v1`).
- Buduje naglowki (`accept`, opcjonalnie `apiKey`).
- Wykonuje `GET`:
  - `/statuses`
  - `/orders`
  - `/orders/{id}`
- Obsluguje mock payloady z plikow JSON.
- Udostepnia request-buildery dla krokow mutujacych (POST/PUT) do implementacji kolejnych etapow.

## Artefakty

- Logi Robot Framework w `artifacts/logs/`.
