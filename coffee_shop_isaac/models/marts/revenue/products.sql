with product_revenue_by_order as(

select * from {{ ref('int_determine_product_revenue_at_order_time') }}

),

products as (

select * from {{ ref('stg_coffee_shop__products') }}

),

product_info_by_order as(
  select 
    product_revenue_by_order.order_product_id,
    product_revenue_by_order.order_id,
    product_revenue_by_order.product_id, 
    products.product_name,
    products.product_category,
    product_revenue_by_order.n_items_ordered, 
    product_revenue_by_order.price, 
    product_revenue_by_order.product_revenue, 
    product_revenue_by_order.order_created_at, 
  from 
    product_revenue_by_order inner join 
    products on product_revenue_by_order.product_id = products.product_id
  order by 
  order_created_at

)

select * from product_info_by_order