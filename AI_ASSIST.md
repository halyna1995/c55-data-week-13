# AI assistance log

## Where I used an LLM

I used ChatGPT while debugging the local dbt-to-Databricks setup and while
organising the assignment repository. The main issues discussed were:

- the Databricks adapter and `dbt_utils` package were missing;
- Git Bash converted `/sql/1.0/warehouses/...` into a Windows path;
- the source schema was incorrectly set to `public` instead of `nyc_yellow`;
- dbt initially authenticated with another user's token;
- the assignment repository contained only empty placeholder files.

## How I checked the advice

I did not accept the suggestions blindly. I checked them with `dbt --version`,
`dbt deps`, `dbt debug`, `session_user()`, compiled SQL, and the Databricks error
messages. I also kept all real tokens outside Git and left real timings,
Job URLs, and screenshots as manual evidence rather than inventing results.
