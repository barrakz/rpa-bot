@echo off
setlocal enabledelayedexpansion

set "ROOT=%~dp0.."
set "ROOT=%ROOT%\"

set "PYTHON=%ROOT%venv\Scripts\python.exe"
if not exist "%PYTHON%" (
  set "PYTHON=python"
  echo [INFO] Nie znaleziono venv. Uzywam Pythona z PATH.
)

for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set "TS=%%i"
set "OUTDIR=%ROOT%artifacts\logs\%TS%"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"

"%PYTHON%" -m robot --outputdir "%OUTDIR%" ^
  --log log.html ^
  --report report.html ^
  --output output.xml ^
  process\main_api_autostacja.robot

endlocal
