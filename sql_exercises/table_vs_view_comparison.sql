-- Table vs. View Comparisons

-- Querying from table took 4 seconds 
select * 
from `aec-students`.dbt_isaac.customers_ltv
where weeks_since_first_order = 0
;

create or replace view `aec-students`.dbt_isaac.customers_ltv_view as 
select
  customer_week_id,
  customer_id, 
  revenue, 
  n_orders, 
  sum(revenue) over(partition by customer_id order by week) as cumulative_revenue, 
  sum(n_orders) over(partition by customer_id order by week) as cumulative_orders,
  week,
  weeks_since_first_order 
from
  `aec-students`.dbt_isaac.int_build_weekly_customer_revenue_history
where 
    weeks_since_first_order >= 0 
order by
  customer_id, 
  week
;

-- Querying from the view that is just select * took 2 seconds
select * 
from `aec-students`.dbt_isaac.customers_ltv_view
where weeks_since_first_order = 0 
;

-- Querying from the view that requires some build took 13 seconds 
select * 
from `aec-students`.dbt_isaac.customers_ltv_view
where weeks_since_first_order = 0 
;
