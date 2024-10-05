with stg_orders as (
  
  select * from {{ ref('stg_coffee_shop__orders') }}
  
), 

int_calculate_lifetime_order_number as (

  select
    md5(order_id || customer_id) as order_customer_id,
    order_id, 
    customer_id, 
    order_revenue,
    address, 
    state, 
    zip, 
    row_number() over(partition by customer_id order by order_created_at desc) lifetime_order_number, 
    order_created_at
  from
    stg_orders

)

select * from int_calculate_lifetime_order_number