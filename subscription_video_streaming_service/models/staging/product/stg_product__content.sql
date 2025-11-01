
with source as (

    select * from {{ source('product', 'content') }}

),

renamed as (

    select
        id as content_id,
        locale,
        LEFT(locale, 2) as language,
        RIGHT(locale, 2) as country,
        content_type

    from source

)

select * from renamed

