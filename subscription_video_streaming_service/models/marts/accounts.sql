with subscription_rev as (
    select *
    from {{ ref('subscriptions')}}
),
accounts as (
    select distinct account_id, cohort_month
    from {{ ref('stg_product__accounts')}}
),
accounts_revenue as (
    select 
        a.account_id, 
        coalesce(sum(USD_amount), 0) as LTV,
        cohort_month,
        APPROX_TOP_COUNT(currency, 1)[OFFSET(0)].value as main_currency
    from accounts a 
    left join subscription_rev r on a.account_id = r.account_id
    group by a.account_id, cohort_month
)
select
    account_id,
    LTV,
    cohort_month,
    case when main_currency='USD' then 'US'
        else 'Canada'
    end as country
from accounts_revenue