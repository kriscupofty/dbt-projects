with daily_metrics as (
    select *
    from {{ ref('DAU_and_total_view_time')}}
),
rolling_28_day as (
    select 
        date, 
        country,
        sum(total_view_time) over 
            (order by date rows between 27 preceding and current row) as rolling_28_day_TVT,
        sum(DAU) over 
            (order by date rows between 27 preceding and current row) as rolling_28_day_MAU
    from daily_metrics
)
select * from rolling_28_day