with subscription_events as (
    select account_id, event, timestamp
    from {{ ref('stg_product__subscription_events') }}
),
monthly_events AS (
  SELECT
    account_id,
    DATE_TRUNC(timestamp, MONTH) AS month,
    event
  FROM subscription_events
),
time_spine as (
    select cast(date_day as TIMESTAMP) as date
    from {{ ref('time_spine')}}
),
months AS (
  SELECT DISTINCT DATE_TRUNC(date, MONTH) AS month
  FROM time_spine
),
sub_periods as (
    select *
    from {{ ref('int_subscription_periods')}}
),
account_month_active as (
    select *
    from {{ ref('int_account_id_active_months')}}
),
active_counts AS (
  SELECT
    month,
    COUNT(DISTINCT account_id) AS active_subscribers
  FROM account_month_active
  GROUP BY month
),
-- Monthly new subscribers (start of a subscription period)
new_subs AS (
  SELECT
    start_month AS month,
    COUNT(DISTINCT account_id) AS new_subscribers
  FROM sub_periods
  GROUP BY start_month
),
-- Monthly churn (cancel events)
churns AS (
  SELECT
    month,
    COUNT(DISTINCT account_id) AS churned_subscribers
  FROM monthly_events
  WHERE event = 'cancel'
  GROUP BY month
),
-- Combine all metrics
metrics AS (
  SELECT
    m.month,
    COALESCE(n.new_subscribers, 0) AS new_subscribers,
    COALESCE(c.churned_subscribers, 0) AS churned_subscribers,
    COALESCE(a.active_subscribers, 0) AS active_subscribers
  FROM months m
  LEFT JOIN new_subs n ON m.month = n.month
  LEFT JOIN churns c ON m.month = c.month
  LEFT JOIN active_counts a ON m.month = a.month
)
-- Compute churn rate using previous month's active count
SELECT
  month,
  new_subscribers,
  churned_subscribers,
  active_subscribers,
  ROUND(SAFE_DIVIDE(churned_subscribers, LAG(active_subscribers) OVER (ORDER BY month)), 2) AS churn_rate
FROM metrics
ORDER BY month