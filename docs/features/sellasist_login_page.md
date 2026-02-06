# Strona logowania SellAsist (bez danych)

## Opis
Test otwiera stronę logowania SellAsist i weryfikuje, że formularz logowania jest widoczny. Nie wpisuje żadnych danych.

## Wejścia / konfiguracja
- `SELLASIST_URL` w `config/variables.robot`
- `BROWSER` ustawiany automatycznie (lub ręcznie przez `BROWSER`/`RPA_ENV`)

## Zachowanie
- Otwiera przeglądarkę na `about:blank`.
- Nawiguje do `SELLASIST_URL`.
- Sprawdza, czy URL zawiera domenę SellAsist.
- Sprawdza, czy na stronie istnieje pole hasła.

## Artefakty
- Logi w `artifacts/logs/`.
