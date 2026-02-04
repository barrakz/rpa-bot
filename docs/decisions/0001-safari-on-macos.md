# ADR-0001: Safari jako pierwsza przeglądarka na macOS

## Status
Accepted

## Kontekst
Projekt startuje lokalnie na macOS. Safari jest natywną przeglądarką i posiada wbudowany `safaridriver`.

## Decyzja
Pierwszy test web jest realizowany na Safari, z użyciem SeleniumLibrary i wbudowanego `safaridriver`.

## Konsekwencje
- Brak potrzeby instalacji zewnętrznych driverów.
- Selenium nie steruje paskiem URL – używamy `Go To`.
- Na potrzeby Windows/GUI będzie potrzebne oddzielne podejście w przyszłości.
