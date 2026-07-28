# Task 2 — dbt on Databricks and incremental models

## Connection check

- Target catalog: `hyf`
- Target schema: `dev_halyna`
- SQL warehouse: `hyf-dbt-warehouse`
- `dbt debug`: PASS

## Build timings

| Run | Command | Real wall-clock time |
|---|---|---:|
| Initial full build | `dbt build --select fct_trips --full-refresh` | 2m8.436s |
| Incremental rerun | `dbt build --select fct_trips` | 1m54.189s |

The incremental rerun was modestly faster because `is_incremental()` returned
true after the target Delta table already existed. The filter using `{{ this }}`
read the maximum existing `pickup_datetime` from the current `fct_trips` table
and processed only rows with a strictly newer timestamp instead of rebuilding
the complete trip history.

The incremental boundary uses `>` rather than `>=`. This prevents rows at the
existing maximum timestamp from being processed repeatedly and avoids duplicate
boundary records.

The measured difference was relatively small because the total wall-clock time
also includes dbt startup, SQL warehouse execution, Delta `MERGE`, and data
tests. However, the Delta table history confirms that the second run used the
incremental `MERGE` strategy rather than performing another full table rebuild.

## Delta history proof

 The following command was executed in Databricks SQL Editor:

```sql
DESCRIBE HISTORY hyf.dev_halyna.fct_trips;
```

The Delta history shows:

CREATE OR REPLACE TABLE AS SELECT for the full-refresh builds;
MERGE for the incremental reruns.

Evidence:

- Suggested screenshot path: `screenshots/delta_history.png`.
