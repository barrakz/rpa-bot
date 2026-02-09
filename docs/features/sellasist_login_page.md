# Strona logowania SellAsist (testowe logowanie)

## Opis
Test otwiera stronę logowania SellAsist i weryfikuje, że formularz logowania jest widoczny. Następnie wpisuje testowy login i hasło, ale nie wysyła formularza.

## Wejścia / konfiguracja
- `SELLASIST_URL` w `config/variables.robot`
- `SELLASIST_LOGIN_INPUT` w `config/variables.robot`
- `SELLASIST_PASSWORD_INPUT` w `config/variables.robot`
- `SELLASIST_LOGIN_BUTTON` w `config/variables.robot`
- `SELLASIST_TEST_USER` i `SELLASIST_TEST_PASS` w `config/variables.robot` (tymczasowe)
- `BROWSER` ustawiany automatycznie (lub ręcznie przez `BROWSER`/`RPA_ENV`)

## Zachowanie
- Otwiera przeglądarkę na `about:blank`.
- Nawiguje do `SELLASIST_URL`.
- Sprawdza, czy URL zawiera domenę SellAsist.
- Sprawdza, czy na stronie istnieje pole loginu i hasła.
- Wpisuje testowe dane logowania.
- Nie klika „Zaloguj się” (brak submitu).

## Artefakty
- Logi w `artifacts/logs/`.
