-- This took 12 seconds without optimizations
-- billed 528 MB

-- with optimizations it took 3 sec
-- and billed 312 MB 

select
  state, 
  date_trunc(customers.order_created_at, day) dt, 
  count(distinct(customers.customer_id)) n_customers, 
  count(order_id) n_orders,
  sum(order_revenue) total_revenue,
  count(pageview_id) n_pvs
from
  `aec-students`.dbt_isaac.customers customers left join 
  `aec-students`.dbt_isaac.pageviews pageviews on customers.customer_id = pageviews.customer_id and 
  date_trunc(customers.order_created_at, day) = date_trunc(pageviews.pageview_at, day)
group by
  dt, 
  state 
order by 
  n_orders
;
