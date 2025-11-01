with events as (
    select event_name, properties
    from {{ ref('stg_product__app_events')}}
),
play_events as (
    select *
    from events
    where event_name = 'PlayProgress'
),
content as (
    select *
    from {{ ref("stg_product__content")}}
)
select 
    content_id, 
    language, 
    country, 
    content_type,
    count(event_name)*10 as minutes_watched
from play_events e
right join content c
on JSON_VALUE(properties, '$.content_id') = c.content_id
group by content_id, language, country, content_type