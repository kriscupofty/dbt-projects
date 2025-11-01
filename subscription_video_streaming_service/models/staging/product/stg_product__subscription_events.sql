
with source as (

    select * from {{ source('product', 'subscription_events') }}

),

renamed as (

    select
        event_id,
        account_id,
        timestamp,
        event,
        tier

    from source

)

select * from renamed

