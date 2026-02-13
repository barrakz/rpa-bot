# Testy

## Lista testow

- `tests/smoke.robot`
  - zapisuje marker `artifacts/logs/smoke_ok.txt`.

- `tests/sellasist_api_skeleton.robot`
  - waliduje inicjalizacje API i budowe requestu.

- `tests/sellasist_api_orders_skeleton.robot`
  - waliduje request-buildery dla operacji na zamowieniach.

- `tests/sellasist_api_main_flow.robot`
  - waliduje glowny etap API na fixture mock.

- `tests/main_api_autostacja_process_keywords.robot`
  - waliduje flow keywordow i warunek stop przed AutoStacja przy braku `AUTOSTACJA_EXE`.

- `tests/autostacja_sim.robot`
  - testuje zachowanie warstwy AutoStacji w trybie `sim`.

- `tests/autostacja_real_smoke.robot`
  - smoke pod tryb `real` (wymaga Windows + AutoStacja).

- `tests/desktop_stub.robot`
  - prosty test desktop stub.

## Procesy workflow

- `process/main_api_autostacja.robot`
- `process/prepare_sellasist_api.robot`
- `process/hybrid_api_autostacja_skeleton.robot`

## Uruchamianie

```bash
robot --outputdir artifacts/logs tests
robot --outputdir artifacts/logs process/main_api_autostacja.robot
```

Przyklady lokalne:

```bash
SELLASIST_API_ACCOUNT=ggautolublin robot --outputdir artifacts/logs tests/sellasist_api_main_flow.robot
SELLASIST_API_ACCOUNT=ggautolublin robot --outputdir artifacts/logs process/main_api_autostacja.robot
```
