# Task 3 — Git-backed Databricks Job

## Job configuration

- Job name: `dev_halyna_fct_trips`
- Task name: `dbt_fct_trips`
- Source: Git provider
- Repository: `https://github.com/halyna1995/c55-data-week-13.git`
- Branch: `main`
- Project directory: `task-2`
- SQL warehouse: `hyf-dbt-warehouse`
- Catalog: `hyf`
- Schema: `dev_halyna`
- Commands:

```text
dbt deps
dbt build --select fct_trips
```

## Job Run URL

https://adb-7405619530719547.7.azuredatabricks.net/jobs/872113922216601?o=7405619530719547

The Job completed successfully. The incremental fct_trips model was created,
and all three dbt data tests passed. The final output showed:
PASS=4 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=4

## Required screenshots

- [ ] [`screenshots/job_config.png`](screenshots/job_config.png)
- [ ] [`screenshots/job_success.png`](screenshots/job_success.png)
- [ ] [`screenshots/paused_schedule.png`](screenshots/paused_schedule.png)


## Databricks Jobs versus Airflow

I would use a Databricks Job when the workflow is Databricks-native, for example
a dbt task, SQL task, or notebook that reads and writes Unity Catalog tables.
I would use Airflow when one pipeline must coordinate several external systems,
for example an API, Azure Storage, Postgres, Databricks, and notifications.

## Schedule safety

A daily schedule was added and immediately paused. This demonstrates that the
Job can run automatically while preventing unnecessary use of the shared class
compute budget.
