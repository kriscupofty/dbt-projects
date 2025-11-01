with base_dates as (
    {{
        dbt.date_spine(
            'day',
            "DATE('2024-01-01')",
            "DATE('2025-06-30')"
        )
    }}
)
select
    cast(date_day as date) as date_day
from base_dates
