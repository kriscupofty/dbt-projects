with sub_rev as (
    select *
    from {{ ref('subscriptions') }}
),
monthly_sub_rev as (
    select date_trunc(timestamp, month) as month, sum(USD_amount) as total_rev
    from sub_rev
    group by date_trunc(timestamp, month)
),
subscribers as (
    select *
    from {{ ref('monthly_new_and_churned_subscribers') }}   
),
monthly_rev_joined_with_subscribers as (
    select r.month, coalesce(total_rev, 0) as total_rev, active_subscribers
    from monthly_sub_rev r
    right join subscribers s on r.month = s.month
),
prev_subscribers as (
    select *, lag(active_subscribers) over (order by month) as prev_active_subscribers
    from monthly_rev_joined_with_subscribers
),
monthly_avg_subscribers as (
    select month, total_rev, abs((active_subscribers-prev_active_subscribers)/2.0) as avg_subscribers
    from prev_subscribers
)
select 
    month, 
    ROUND(COALESCE(SAFE_DIVIDE(total_rev, avg_subscribers), 0.00), 2) AS average_revenue_per_user
from monthly_avg_subscribers