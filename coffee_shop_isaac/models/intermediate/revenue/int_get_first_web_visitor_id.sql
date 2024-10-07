with staging as (
  
  select * from {{ ref('stg_web_tracking__pageviews') }}

), 

calculate_visit_numbers_by_customer as(
   select
    distinct
    customer_id,
    visitor_id, 
    row_number() over(partition by customer_id order by pageview_at) visit_number
  from 
    staging
  where
    customer_id is not null
  order by
    customer_id, 
    visit_number
),

get_first_visitor_id as(
  select 
    md5(customer_id || visitor_id) as customer_visitor_id,
    * 
  from 
    calculate_visit_numbers_by_customer
  where 
    visit_number = 1
)

select * from get_first_visitor_id