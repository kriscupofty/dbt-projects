
with source as (

    select * from {{ source('product', 'app_events') }}

),

renamed as (

    select
        subaccount_id,
        timestamp,
        session_id,
        device_id,
        country,
        event_name,
        properties

    from source

)

select * from renamed

