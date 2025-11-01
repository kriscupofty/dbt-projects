with acount_cohorts as (
    select distinct account_id, cohort_month
    from {{ ref('stg_product__accounts')}}
),
sub_rev as (
    select account_id, timestamp, USD_amount
    from {{ ref('subscriptions')}}
),
cohort_monthly_rev as (
    select 
        cohort_month,
        date_trunc(date(timestamp), month) as revenue_month,
        sum(USD_amount) as revenue
    from sub_rev r 
    join acount_cohorts c on r.account_id = c.account_id
    group by cohort_month, date_trunc(date(timestamp), month)
),
cohort_final as (
    select 
        cohort_month, 
        revenue_month,
        revenue,
        date_diff(revenue_month, cohort_month, month) as month_number
    from cohort_monthly_rev
)
select 
    cohort_month,
    coalesce(sum(case when month_number = 0 then revenue end), 0) as month_0,
    coalesce(sum(case when month_number = 1 then revenue end), 0) as month_1,
    coalesce(sum(case when month_number = 2 then revenue end), 0) as month_2,
    coalesce(sum(case when month_number = 3 then revenue end), 0) as month_3,
    coalesce(sum(case when month_number = 4 then revenue end), 0) as month_4,
    coalesce(sum(case when month_number = 5 then revenue end), 0) as month_5,
    coalesce(sum(case when month_number = 6 then revenue end), 0) as month_6
from cohort_final
group by cohort_month
order by cohort_month