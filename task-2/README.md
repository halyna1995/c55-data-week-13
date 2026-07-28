# Task 2 — dbt on Databricks

## 1. Create local secret files

```bash
cp profiles.yml.example profiles.yml
cp ../.env.example ../.env
```

Fill `../.env` with your own values. Never commit `.env`, `profiles.yml`, or a token.

## 2. Load the environment in Git Bash

```bash
export MSYS2_ENV_CONV_EXCL='DATABRICKS_HTTP_PATH'
set -a
source ../.env
set +a
```

## 3. Install and verify

```bash
uv sync
uv run dbt deps
uv run dbt debug
uv run dbt show --inline "select session_user() as dbt_identity"
```

The identity must be your own Databricks user, not the teacher's account.

## 4. Create dependencies once

```bash
uv run dbt run --select +fct_trips
```

## 5. Required timed runs

```bash
uv run dbt build --select fct_trips --full-refresh
uv run dbt build --select fct_trips
```

Copy the real times to `WRITEUP.md`.

## 6. Verify Delta history

```sql
DESCRIBE HISTORY hyf.dev_halyna.fct_trips;
```

Save the result or screenshot and reference it in `WRITEUP.md`.
