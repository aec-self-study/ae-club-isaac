{{
  config(
    materialized = "table",
    partition_by={
      "field": "week",
      "data_type": "date",
      "granularity": "day"
    },
    cluster_by = "customer_id"
  )
}}

with customer_revenue_history as (
  
  select * from {{ ref('int_build_weekly_customer_revenue_history') }}

)

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
  customer_revenue_history
where 
    weeks_since_first_order >= 0 
