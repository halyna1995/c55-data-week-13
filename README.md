# Week 13 Assignment — Big Data on Databricks

This repository contains Halyna's Week 13 assignment scaffold for:

1. PySpark exploration in a Databricks notebook.
2. A Week 10 dbt project ported to Databricks and Delta Lake.
3. A Git-backed Databricks Job with a paused schedule.

The complete Ukrainian translation of the assignment is in [`ASSIGNMENT_UA.md`](ASSIGNMENT_UA.md).
A file-by-file explanation is in [`CHANGES_UA.md`](CHANGES_UA.md).

## Repository structure

```text
c55-data-week-13/
├── task-1/
│   └── pyspark_exploration.py
├── task-2/
│   ├── dbt_project.yml
│   ├── packages.yml
│   ├── profiles.yml.example
│   ├── pyproject.toml
│   ├── models/
│   ├── tests/
│   └── WRITEUP.md
├── task-3/
│   ├── SCHEDULING.md
│   └── screenshots/
├── .env.example
├── AI_ASSIST.md
└── ASSIGNMENT_UA.md
```

## What still requires manual evidence

The code and templates are prepared, but these values cannot be invented and must be added after real Databricks runs:

- the output of Task 1;
- the full-refresh and incremental wall-clock times;
- the `DESCRIBE HISTORY` result or screenshot;
- the Databricks Job Run URL;
- screenshots of Job configuration, a successful run, and the paused schedule.

## Local dbt setup

Run these commands from `task-2/`:

```bash
cp profiles.yml.example profiles.yml
cp ../.env.example ../.env
```

Fill in `../.env` with your personal token and correct warehouse values, then load it in Git Bash:

```bash
set -a
source ../.env
set +a
```

Git Bash can convert `/sql/...` into a Windows path. Prevent that before running dbt:

```bash
export MSYS2_ENV_CONV_EXCL='DATABRICKS_HTTP_PATH'
```

Install and check dbt:

```bash
uv sync
uv run dbt deps
uv run dbt debug
```

First create the staging views once:

```bash
uv run dbt run --select +fct_trips
```

Then run the two commands required for the timing comparison:

```bash
uv run dbt build --select fct_trips --full-refresh
uv run dbt build --select fct_trips
```

## Databricks Job configuration

Use these values:

```text
Job name: dev_halyna_fct_trips
Git repository: https://github.com/halyna1995/c55-data-week-13.git
Branch: main
Project directory: task-2
Commands:
  dbt deps
  dbt build --select fct_trips
Warehouse: hyf-dbt-warehouse
Catalog: hyf
Schema: dev_halyna
```

After proving the Job works, add a schedule and leave the trigger **Paused**.
