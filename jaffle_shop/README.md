# jaffle_shop

## Workflows:
- Production Job (Monday-Saturday at midnight)
    - dbt deps
    - dbt source freshness
    - dbt build
- Production Sunday Job (Sunday at midnight)
    - dbt deps
    - dbt source freshness
    - dbt build or dbt build --full-refresh
    - dbt docs generate
