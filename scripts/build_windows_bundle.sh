#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-1.0}"
PY_VERSION="${PY_VERSION:-3.11.8}"
PY_TAG="${PY_TAG:-311}"

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bundle_root="${root_dir}/bundle/windows/${VERSION}"
cache_dir="${root_dir}/bundle/.cache"
python_zip="python-${PY_VERSION}-embed-amd64.zip"
python_url="https://www.python.org/ftp/python/${PY_VERSION}/${python_zip}"

if [ ! -d "${root_dir}/venv" ]; then
  echo "venv nie znaleziono. Utwórz je poleceniem: python3 -m venv venv"
  echo "Następnie: source venv/bin/activate && pip install -r requirements.txt"
  exit 1
fi

rm -rf "${bundle_root}"
mkdir -p "${bundle_root}/python" "${bundle_root}/app" "${cache_dir}"

echo "[1/5] Pobieranie Python embed (${PY_VERSION})..."
curl -L "${python_url}" -o "${cache_dir}/${python_zip}"

echo "[2/5] Rozpakowywanie Python embed..."
unzip -q "${cache_dir}/${python_zip}" -d "${bundle_root}/python"

pth_file="${bundle_root}/python/python${PY_TAG}._pth"
if [ ! -f "${pth_file}" ]; then
  pth_file="$(ls "${bundle_root}/python" | grep -E "^python[0-9]+\\._pth$" | head -n1)"
  pth_file="${bundle_root}/python/${pth_file}"
fi

echo "[3/5] Konfiguracja python._pth..."
cat > "${pth_file}" <<EOF
python${PY_TAG}.zip
.
Lib\\site-packages
import site
EOF

mkdir -p "${bundle_root}/python/Lib/site-packages"

echo "[4/5] Instalacja zaleznosci do bundle..."
"${root_dir}/venv/bin/python" -m pip install --quiet \
  --target "${bundle_root}/python/Lib/site-packages" \
  -r "${root_dir}/requirements.txt"

echo "[5/5] Kopiowanie aplikacji..."
rsync -a --delete \
  --exclude ".git" \
  --exclude "venv" \
  --exclude "bundle" \
  --exclude ".local" \
  --exclude "artifacts" \
  "${root_dir}/" "${bundle_root}/app/"

mkdir -p "${bundle_root}/app/artifacts/logs" "${bundle_root}/app/artifacts/screenshots"

cat > "${bundle_root}/run.bat" <<'EOF'
@echo off
setlocal

set "ROOT=%~dp0"
set "APP=%ROOT%app"
set "PYTHON=%ROOT%python\python.exe"

if not exist "%PYTHON%" (
  echo [ERROR] Brak Python embed w paczce.
  pause
  exit /b 1
)

cd /d "%APP%"
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set "TS=%%i"
set "OUTDIR=artifacts\logs\%TS%"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"

"%PYTHON%" -m robot --outputdir "%OUTDIR%" ^
  --log log.html ^
  --report report.html ^
  --output output.xml ^
  process\main_api_autostacja.robot

echo.
echo [OK] Logi: %APP%\%OUTDIR%\log.html
pause
endlocal
EOF

cat > "${bundle_root}/README.txt" <<EOF
RPA Bot - Windows bundle v${VERSION}

1) Uzupelnij dane API w app\\.env (na podstawie app\\.env.example).
2) Uruchom run.bat (podwojny klik).

Po uruchomieniu wykona sie etap API SellAsist i zapisze sie plik handoff dla AutoStacji.
Logi: app\\artifacts\\logs\\log.html
EOF

zip_path="${root_dir}/bundle/windows/rpa-bot-windows-${VERSION}.zip"
echo "[DONE] Bundle gotowy: ${bundle_root}"
echo "Tworzenie zip: ${zip_path}"
(cd "${bundle_root}/.." && zip -qr "${zip_path}" "${VERSION}")
echo "[OK] ZIP zapisany."
