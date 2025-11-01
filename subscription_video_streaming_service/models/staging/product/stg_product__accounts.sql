with source as (
    select * from {{ source('product', 'accounts') }}
),
renamed as (

    select
        account_id,
        subaccount_id,
        creation_ts as created_at
    from source
),
min_creation_ts as (
    select 
        *,
        min(created_at) over (partition by account_id) as min_creation_at
    from renamed
),
account_cohort as (
    select 
        account_id,
        subaccount_id,
        created_at,
        date_trunc(date(min_creation_at), month) as cohort_month
    from min_creation_ts
)
select * from account_cohort