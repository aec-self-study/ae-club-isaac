{{ config(
  materialized='table'
)}}

select 
  customers.id as customer_id,
  customers.name, 
  customers.email,
  orders.first_order_at,
  orders.number_of_orders
from 
  `analytics-engineers-club.coffee_shop.customers` customers
left join (
  select
    customer_id,
    min(created_at) first_order_at,
    count(id) number_of_orders
  from
    `analytics-engineers-club.coffee_shop.orders` 
  group by
    customer_id 
) orders on customers.id = orders.customer_id
order by 
  first_order_at 
limit 5