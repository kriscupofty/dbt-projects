# Subscription Video Streaming Service dbt Project

## Data and Business Context
The generated data simulates product and payment data from a fictional subscription-based video streaming service operating in North America.
Each subscription is linked to an account. Each account has one or more subaccounts (represents an actual user/profile). 
There are currently three tiers of subscription plans with different monthly fees in different countries/currencies: 
Tier1 allows one subaccount, Tier2 two subaccounts, and Tier3 three subaccounts.

## Metrics Implemented/Supported

### Engagement & Consumption Metrics
- Daily/Weekly/Rolling 28-day Active Users (DAU/WAU/28-day MAU)
    - active: has viewed at least 10 min of content
- Total View Time per day/week/ect
- Sessions and Average Session Duration

### Content Metrics
- Content Popularity – top titles by hours viewed, by content type/language/country
- Catalog Utilization – % of the catalog being consumed (vs. concentrated on a few shows)

### Subscription & Business Metrics
- New Subscribers Count
- Churn Count and Churn Rate
- Active Subscriber Count

- Monthly Subscription Revenue by Region/Plan Tier
- Average Lifetime Value (LTV) of a subscriber

- ARPU (Average Revenue per User) – subscription revenue in a given period ÷ avg number of subscribers ((end - beginning)/2)

- Subscription Retention Cohort Analysis – how long subscribers keep renewing after sign-up
