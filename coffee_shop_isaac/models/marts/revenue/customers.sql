with orders_with_lifetime_order_number as(

select * from {{ ref('int_calculate_lifetime_order_number') }}

),

customers as (

select * from {{ ref('stg_coffee_shop__customers') }}

), 

first_purchase_at as (

select * from {{ ref('int_get_first_purchase_at_by_customer') }}

)

select 
    orders_with_lifetime_order_number.order_customer_id,
    orders_with_lifetime_order_number.order_id, 
    orders_with_lifetime_order_number.customer_id, 
    customers.name, 
    customers.email,
    orders_with_lifetime_order_number.address, 
    orders_with_lifetime_order_number.state, 
    orders_with_lifetime_order_number.zip, 
    orders_with_lifetime_order_number.order_revenue,
    case 
        when lifetime_order_number > 1 then 'Returning Customer'
        else 'New Customer'
    end as is_returning_customer,
    first_purchase_at.first_order_at as first_order_at, 
    orders_with_lifetime_order_number.order_created_at
from 
  orders_with_lifetime_order_number inner join 
  customers on orders_with_lifetime_order_number.customer_id = customers.customer_id inner join 
  first_purchase_at on orders_with_lifetime_order_number.customer_id = first_purchase_at.customer_id
order by 
    order_customer_id
 

