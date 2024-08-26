select
  REGEXP_EXTRACT(email, r'@(.+)') AS domain,
  sum(number_of_orders) n_orders,
  count(distinct(customer_id)) as n_customers
from 
  {{ ref('customers') }}
group by
  domain