with order_items as (
  
  select * from {{ ref('stg_coffee_shop__order_items') }}

), 

aggregated as(

select 
    md5(order_id || product_id) order_product_id,
    order_id,
    product_id, 
    count(*) n_items_ordered
from
    order_items 
group by 
    order_product_id,
    order_id, 
    product_id
    
)

select * from aggregated
