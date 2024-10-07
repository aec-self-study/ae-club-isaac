with stg_orders as (
  
  select * from {{ ref('stg_coffee_shop__orders') }}
  
), 

int_get_fist_purchase_by_customer as (

  select
    customer_id, 
    min(order_created_at) first_order_at
  from
    stg_orders
  group by 
    customer_id

)

select * from int_get_fist_purchase_by_customer