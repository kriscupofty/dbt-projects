
with source as (

    select * from {{ source('product', 'sessions') }}

),

renamed as (

    select
        id as session_id,
        subaccount_id,
        started_at,
        ended_at,
        TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS duration_minutes

    from source

)

select * from renamed

