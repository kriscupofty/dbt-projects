# Jaffle Shop dbt Project
## Set-up
Create a profiles.yml file to connect to BigQuery

## Workflows
- Production Job (Monday-Saturday at midnight)
    - dbt deps
    - dbt source freshness
    - dbt build
- Production Sunday Job (Sunday at midnight)
    - dbt deps
    - dbt source freshness
    - dbt build or dbt build --full-refresh
    - dbt docs generate

## Query the Semantic Layer
See https://docs.getdbt.com/docs/build/metricflow-commands#query-metrics
Example:
```
export DBT_PROFILES_DIR=/Users/kristys/.dbt

mf query --metrics amount --group-by order_id__order_date
```
Output:
```
order_id__order_date__day      amount
---------------------------  --------
2018-03-08T00:00:00                 0
2018-01-15T00:00:00                 1
...
```