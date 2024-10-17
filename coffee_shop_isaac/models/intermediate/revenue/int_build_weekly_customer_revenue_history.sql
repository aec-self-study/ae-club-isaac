with customers as (
  
  select * from {{ ref('customers') }}
  
), 

calc_weekly_customer_revenue as (

select
    customer_id, 
    date(date_trunc(order_created_at, week)) order_week, 
    date(date_trunc(first_order_at, week)) first_order_week, 
    sum(order_revenue) as revenue,
    count(distinct(order_id)) as n_orders
from
    customers
group by
    customer_id, 
    order_week,
    first_order_week

),

date_spine as(

  select
    *
  from 
    unnest(generate_date_array(
      date((select min(first_order_week) from calc_weekly_customer_revenue)),
      date((select max(order_week) from calc_weekly_customer_revenue)),
      interval 1 week)) as week

), 

add_customers_to_spine as(

  select 
    distinct
    calc_weekly_customer_revenue.customer_id, 
    first_order_week, 
    date_spine.week
  from
    date_spine 
    left join calc_weekly_customer_revenue on true

), 

add_sales_to_spine as(

  select
    add_customers_to_spine.customer_id, 
    calc_weekly_customer_revenue.revenue, 
    calc_weekly_customer_revenue.n_orders, 
    calc_weekly_customer_revenue.order_week, 
    add_customers_to_spine.first_order_week,
    add_customers_to_spine.week 
  from 
    add_customers_to_spine
    left join calc_weekly_customer_revenue on
      add_customers_to_spine.customer_id = calc_weekly_customer_revenue.customer_id and 
      add_customers_to_spine.week = calc_weekly_customer_revenue.order_week

),

fill_revenue_along_spine as(

    select
        md5(customer_id || week) as customer_week_id,
        customer_id,
        if(order_week = week, revenue, 0) revenue,
        if(order_week = week, n_orders, 0) n_orders,
        first_order_week,
        order_week,
        week,
        date_diff(week, first_order_week, week) weeks_since_first_order
    from
        add_sales_to_spine
    order by
        week

)

select * from fill_revenue_along_spine