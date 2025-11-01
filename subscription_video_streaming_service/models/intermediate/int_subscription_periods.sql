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
-- Order events per account
ordered_events AS (
  SELECT
    account_id,
    month,
    event,
    ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY month, event) AS rn
  FROM monthly_events
),
-- Build subscription periods between subscribe and the next cancel
sub_periods AS (
  SELECT
    s.account_id,
    s.month AS start_month,
    MIN(c.month) AS end_month
  FROM ordered_events s
  LEFT JOIN ordered_events c
    ON s.account_id = c.account_id
    AND c.event = 'cancel'
    AND c.month > s.month
  WHERE s.event = 'subscribe'
  GROUP BY s.account_id, s.month
)
select * from sub_periods
