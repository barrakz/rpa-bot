#!/usr/bin/env bash
set -euo pipefail

if [ -d "venv" ]; then
  # shellcheck disable=SC1091
  source venv/bin/activate
else
  echo "venv nie znaleziono. Utwórz je poleceniem: python3 -m venv venv"
  echo "Następnie: source venv/bin/activate && pip install -r requirements.txt"
  exit 1
fi

ts="$(date +"%Y-%m-%d_%H-%M-%S")"
outdir="artifacts/logs/${ts}"
mkdir -p "${outdir}"

robot --outputdir "${outdir}" \
  --log log.html \
  --report report.html \
  --output output.xml \
  tests
