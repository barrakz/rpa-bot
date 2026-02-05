#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${root_dir}"

if [ -d "venv" ]; then
  # shellcheck disable=SC1091
  source venv/bin/activate
else
  echo "venv nie znaleziono. Utwórz je poleceniem: python3 -m venv venv"
  echo "Następnie: source venv/bin/activate && pip install -r requirements.txt"
  exit 1
fi

: "${RPA_ENV:=mac}"
export RPA_ENV

ts="$(date +"%Y-%m-%d_%H-%M-%S")"
outdir="artifacts/logs/${ts}"
mkdir -p "${outdir}"

robot --outputdir "${outdir}" \
  --log log.html \
  --report report.html \
  --output output.xml \
  process/open_sellasist.robot
