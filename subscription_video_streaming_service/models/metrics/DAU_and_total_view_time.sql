with time_spine as (
    select cast(date_day as TIMESTAMP) as date
    from {{ ref('time_spine')}}
),
events as (
    select subaccount_id,
        timestamp,
        country,
        event_name
    from {{ ref('stg_product__app_events')}}
),
engaged_events as (
    select *
    from events
    where event_name not in ('Log-in', 'Log-out')
),
engaged_days_user_metrics as (
    select 
        date_trunc(timestamp, day) as date,
        country,
        count(distinct subaccount_id) as DAU,
        SUM(case when event_name='PlayProgress' then 10 else 0 end) as total_view_time
    from engaged_events 
    group by date_trunc(timestamp, day), country
)
select 
    s.date, 
    country,
    coalesce(total_view_time, 0) as total_view_time, 
    coalesce(DAU, 0) as DAU 
from engaged_days_user_metrics m 
right join time_spine s on m.date = s.date
