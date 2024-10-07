with stg_coffee_shop__pageviews as (

    select * from {{ ref('stg_web_tracking__pageviews') }}
), 

get_first_visitor_id as(

    select * from {{ ref('int_get_first_web_visitor_id') }}

),

set_first_visit_id_as_id as(
  select 
    stg_coffee_shop__pageviews.pageview_id,
    get_first_visitor_id.visitor_id, 
    stg_coffee_shop__pageviews.customer_id,
    stg_coffee_shop__pageviews.device_type, 
    stg_coffee_shop__pageviews.pageview_at, 
    stg_coffee_shop__pageviews.page 
  from 
    stg_coffee_shop__pageviews left join
    get_first_visitor_id using(customer_id)
)

select * from set_first_visit_id_as_id