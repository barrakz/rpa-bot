# Otwieranie WP w Safari

## Opis
Test automatycznie uruchamia Safari i przechodzi do `https://www.wp.pl`.

## Wejścia / konfiguracja
- `BASE_URL` w `config/variables.robot`
- `BROWSER` ustawiony na `safari`

## Zachowanie
- Otwiera przeglądarkę na `about:blank`.
- Nawiguje do `BASE_URL`.
- Sprawdza tytuł strony.

## Artefakty
- Logi w `artifacts/logs/`.
