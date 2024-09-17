select 
  products.category as category,
  count(distinct(products.name)) as n_products,
from 
  {{source('coffee_shop','products')}} products
group by 
  category
order by 
  n_products desc