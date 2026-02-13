# Hybrydowy flow API + AutoStacja (skeleton)

## Opis

Szkielet docelowego procesu: Sellasist API -> AutoStacja -> Sellasist API.

## Wejscia / konfiguracja

- `SELLASIST_API_ACCOUNT`, `SELLASIST_API_KEY`, `SELLASIST_API_BASE_URL`.
- `DESKTOP_MODE` (`sim`/`real`) oraz `AUTOSTACJA_EXE` dla `real`.

## Zachowanie

- Pobiera dane z Sellasist API.
- Przekazuje dane do etapu desktop AutoStacji.
- Przygotowuje operacje API po wykonaniu etapu AutoStacji
  (`document_number`, zmiana statusu, notatka).

## Artefakty

- Logi Robot Framework.
- W `sim`: trace i testowe artefakty PDF.
