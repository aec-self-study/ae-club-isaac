with stg_orders as (
  
  select * from {{ ref('stg_coffee_shop__orders') }}
  
), 

int_volume_per_order as (
  
  select * from {{ ref('int_calculate_product_volume_per_order') }}
  
), 

stg_product_prices as (

  select * from {{ ref('stg_coffee_shop__product_prices') }}

),

product_price_at_order as (
  select 
    stg_orders.order_id as order_id,
    stg_product_prices.product_prices_id as product_prices_id, 
    int_volume_per_order.product_id as product_id, 
    int_volume_per_order.n_items_ordered as n_items_ordered,
    stg_product_prices.price as price, 
    n_items_ordered * price as product_revenue,
    stg_product_prices.product_or_price_created_at as product_or_price_created_at, 
    stg_product_prices.product_or_price_ended_at as product_or_price_ended_at, 
    stg_orders.order_created_at as order_created_at, 
    case 
      when order_created_at between product_or_price_created_at and product_or_price_ended_at then TRUE 
      ELSE FALSE
    end as is_product_price_at_order
  from 
    stg_orders inner join 
    int_volume_per_order on stg_orders.order_id = int_volume_per_order.order_id inner join 
    stg_product_prices on int_volume_per_order.product_id = stg_product_prices.product_id  
), 

product_revenue_by_order as(
  select 
    md5(order_id || product_id) as order_product_id,
    order_id,
    product_id, 
    n_items_ordered,
    price, 
    product_revenue,
    product_or_price_created_at, 
    product_or_price_ended_at, 
    order_created_at, 
  from
    product_price_at_order
  where
    is_product_price_at_order is TRUE
)

select * from product_revenue_by_order
