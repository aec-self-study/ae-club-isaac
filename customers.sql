select a.id as customer_id 
, name 
, email
, first_order_at 
, number_of_orders
from `analytics-engineers-club.coffee_shop.customers` a
left join (
  select customer_id 
  , min(created_at) first_order_at
  , count(id) number_of_orders
  from `analytics-engineers-club.coffee_shop.orders`
  group by 1
) b on a.id = b.customer_id
order by first_order_at 
limit 5
; 
