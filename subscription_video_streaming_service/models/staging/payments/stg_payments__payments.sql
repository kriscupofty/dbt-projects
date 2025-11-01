
with source as (

    select * from {{ source('payments', 'payments') }}

),

renamed as (

    select
        id as payment_id,
        event_id,
        account_id,
        amount,
        currency,
        case when currency='CAD' then amount*0.71 
            else amount
        end as USD_amount,
        status,
        created_at

    from source

)

select * from renamed

