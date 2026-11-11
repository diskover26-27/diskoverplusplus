#!/usr/bin/env bash
# Seed a local PostgreSQL with the Diskover data snapshot (backend/EndGame.sql).
# The snapshot already contains ~890 UP Diliman locations with descriptions,
# categories, tags and image references, so this is the fastest way to get data.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DUMP="$ROOT/backend/EndGame.sql"
ENV_FILE="$ROOT/backend/.env"

# Load backend/.env so Compose (and psql) use the same DB_* values as Django.
if [ -f "$ENV_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  . "$ENV_FILE"
  set +a
fi

DB_NAME="${DB_NAME:-diskover}"
DB_USER="${DB_USER:-postgres}"
DB_PORT="${DB_PORT:-5432}"

die() { echo "error: $*" >&2; exit 1; }

[ -f "$DUMP" ] || die "snapshot not found: $DUMP"
command -v docker >/dev/null 2>&1 || die "docker is required (https://docs.docker.com/get-docker/)"
docker info >/dev/null 2>&1 || die "Docker daemon is not running. Start Docker Desktop and retry."

echo ">> Recreating the database with a fresh volume"
(cd "$ROOT" && docker compose down -v --remove-orphans >/dev/null 2>&1 || true)
(cd "$ROOT" && docker compose up -d db)

echo ">> Waiting for PostgreSQL to accept connections..."
until (cd "$ROOT" && docker compose exec -T db pg_isready -U "$DB_USER" -d "$DB_NAME" >/dev/null 2>&1); do
  sleep 1
done

echo ">> Loading snapshot (locations, descriptions, categories, tags, images)..."
# Drop statements tied to the dump's original PostgreSQL version/owner so it
# restores cleanly on PostgreSQL 12+ under any role.
sed -e '/OWNER TO/d' -e '/default_with_oids/d' "$DUMP" \
  | (cd "$ROOT" && docker compose exec -T db psql -v ON_ERROR_STOP=1 -q -U "$DB_USER" -d "$DB_NAME" >/dev/null)

echo ">> Done. PostgreSQL is running on 127.0.0.1:${DB_PORT}"
echo "   DB_NAME=${DB_NAME} DB_USER=${DB_USER} DB_PORT=${DB_PORT}"
