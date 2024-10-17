with orders as (
  
  select * from {{ ref('stg_coffee_shop__orders') }}
  
), 

int_get_first_purchase_by_customer as (

  select
    customer_id, 
    min(order_created_at) first_order_at
  from
    orders
  group by 
    customer_id

)

select * from int_get_first_purchase_by_customer