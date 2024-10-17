with cohort_assignments as(
  select 
    customer_week_id,
    customer_id, 
    revenue, 
    n_orders, 
    cumulative_revenue, 
    cumulative_orders, 
    week, 
    weeks_since_first_order,
    first_value(week ignore nulls) over(
      partition by customer_id
      order by weeks_since_first_order
      range between unbounded preceding and unbounded following
    ) as cohort_week
  from 
    `aec-students`.`dbt_isaac`.`customers_ltv`
), 

cohort_sizes as(
  select 
    cohort_week, 
    count(distinct(customer_id)) as cohort_size
  from 
    cohort_assignments
  group by 
    cohort_week 
)

select 
  cohort_assignments.cohort_week, 
  weeks_since_first_order, 
  sum(cumulative_revenue) as cumulative_revenue, 
  cohort_sizes.cohort_size, 
  sum(cumulative_revenue) / cohort_sizes.cohort_size as avg_cumulative_revenue 
from
  cohort_assignments left join
  cohort_sizes on cohort_assignments.cohort_week = cohort_sizes.cohort_week
group by 
  cohort_week, 
  weeks_since_first_order,
  cohort_size
order by 
  cohort_week, 
  weeks_since_first_order
;
