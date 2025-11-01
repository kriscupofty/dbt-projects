with subscription_events as (

    select * 
    from {{ ref('stg_product__subscription_events') }}
    where event in ('subscribe', 'renew', 'upgrade')
  
),
payments as (

    select * 
    from {{ ref('stg_payments__payments') }}
    where status='success'
  
)
select e.account_id, 
    timestamp,
    e.event_id, 
    tier,
    coalesce(sum(USD_amount), 0) as USD_amount,
    currency
from subscription_events e 
left join payments p on e.event_id = p.event_id
group by e.account_id, timestamp, event_id, tier, currency