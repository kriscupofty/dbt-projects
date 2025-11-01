with sub_periods as (
    select *
    from {{ ref('int_subscription_periods')}}    
),
time_spine as (
    select cast(date_day as TIMESTAMP) as date
    from {{ ref('time_spine')}}
),
months AS (
  SELECT DISTINCT DATE_TRUNC(date, MONTH) AS month
  FROM time_spine
),
-- Determine which accounts are active in each month
account_month_active AS (
  SELECT
    m.month,
    sp.account_id
  FROM months m
  JOIN sub_periods sp
    ON m.month >= sp.start_month
   AND (sp.end_month IS NULL OR m.month < sp.end_month)
)
select * from account_month_active