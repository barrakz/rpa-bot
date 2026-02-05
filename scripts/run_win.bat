@echo off
setlocal enabledelayedexpansion

set "ROOT=%~dp0.."
set "ROOT=%ROOT%\"

set "RPA_ENV=win"
set "BROWSER=chrome"

set "PYTHON=%ROOT%venv\Scripts\python.exe"
if not exist "%PYTHON%" (
  set "PYTHON=python"
  echo [INFO] Nie znaleziono venv. Uzywam Pythona z PATH.
)

set "OUTDIR=%ROOT%artifacts\logs"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"

"%PYTHON%" -m robot --outputdir "%OUTDIR%" ^
  --log log.html ^
  --report report.html ^
  --output output.xml ^
  process\open_sellasist.robot

endlocal
