#!/usr/bin/env bash
# One-shot local dev bootstrap: env files, database, backend deps, then run both servers.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKEND="$ROOT/backend"
FRONTEND="$ROOT/frontend"
VENV="$BACKEND/.venv"

# 1) env files
if [ ! -f "$BACKEND/.env" ]; then
  cp "$BACKEND/.env.example" "$BACKEND/.env"
  echo ">> Created backend/.env"
fi
if [ ! -f "$FRONTEND/.env" ]; then
  cp "$FRONTEND/.env.example" "$FRONTEND/.env"
  echo ">> Created frontend/.env"
fi

# Load backend/.env so Compose uses the same DB_* values as Django.
set -a
# shellcheck disable=SC1090
. "$BACKEND/.env"
set +a
DB_USER="${DB_USER:-postgres}"

# 2) database (seed once, then just start the existing container)
DB_ID="$(cd "$ROOT" && docker compose ps -aq db 2>/dev/null || true)"
if [ -n "$DB_ID" ]; then
  echo ">> Starting existing database"
  (cd "$ROOT" && docker compose start db >/dev/null)
  until (cd "$ROOT" && docker compose exec -T db pg_isready -U "$DB_USER" >/dev/null 2>&1); do
    sleep 1
  done
else
  "$ROOT/scripts/seed-db.sh"
fi

# 3) backend deps
if [ ! -x "$VENV/bin/python" ]; then
  echo ">> Creating Python virtualenv"
  python3 -m venv "$VENV"
fi
if [ ! -f "$VENV/.installed" ]; then
  echo ">> Installing backend dependencies"
  "$VENV/bin/pip" install --upgrade pip >/dev/null
  # psycopg2 (source) has no wheel for newer Python; psycopg2-binary ships the same module.
  "$VENV/bin/pip" install -r <(grep -vE '^psycopg2([=<>]|$)' "$BACKEND/requirements.txt")
  touch "$VENV/.installed"
fi

# Static/template dirs referenced by settings (git-ignored, created at runtime).
mkdir -p "$BACKEND/static/images/markers" "$BACKEND/static/images/locations" "$BACKEND/templates"

# The snapshot already has the app tables; record the app migrations so Django stops nagging.
(cd "$BACKEND" && "$VENV/bin/python" manage.py migrate diskover_api --fake >/dev/null 2>&1 || true)

# 4) run both servers
echo ">> Backend: http://127.0.0.1:8000   Frontend: http://127.0.0.1:5173"
(cd "$BACKEND" && "$VENV/bin/python" manage.py runserver 0.0.0.0:8000) &
BACKEND_PID=$!
trap 'kill "$BACKEND_PID" 2>/dev/null || true' EXIT INT TERM

cd "$FRONTEND"
pnpm install
pnpm dev
