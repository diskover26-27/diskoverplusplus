# Diskover++

UP Diliman map. Data (locations, descriptions, categories, tags, images)
lives in PostgreSQL and is served by the Django REST API in `backend/`.

## Prerequisites

- Docker Desktop
- Node 20+ and pnpm 9.12.3
- Python 3.10+

## Quick start

```sh
open -a Docker          # start Docker Desktop; wait until `docker info` works
pnpm dev                # DB + Django (:8000) + Vite (:5173)
```

`pnpm dev` copies `.env.example` → `.env`, seeds Postgres from
`backend/EndGame.sql` (first run only), builds `backend/.venv`, and starts both servers.

Then, create an admin login once:

```sh
pnpm createsuperuser
```

- App: http://127.0.0.1:5173
- API: http://127.0.0.1:8000/diskover_api/locations/
- Admin: http://127.0.0.1:8000/super/ (or app `/admin`)

## Manual / granular

```sh
pnpm db:up      # start Postgres only
pnpm db:seed    # wipe volume + load EndGame.sql (first run / reset)
pnpm db:down    # stop DB (keeps data)
pnpm db:logs    # tail Postgres logs
```

## Editing data

Descriptions live in `Location.description` (rendered in the detail pane).
Edit via Django admin `/super/` -> Location, or the app form at
`/admin/location/form/add`. Re-seed with `pnpm db:seed`.

## Environment

Commit-safe templates are `backend/.env.example` and `frontend/.env.example`;
copy to `.env` (git-ignored). Never commit `.env`, `.venv`, `db.sqlite3`,
`__pycache__/`, `static/`, or `templates/`.
