with base_dates as (
    {{
        dbt.date_spine(
            'day',
            "DATE('2000-01-01')",
            "DATE('2030-01-01')"
        )
    }}
),
final as (
    select
        cast(date_day as date) as date_day
    from base_dates
)
select *
from final
where date_day > date_sub(current_date(), interval 5 year)  -- Keep recent dates only
  and date_day < date_add(current_date(), interval 30 day)