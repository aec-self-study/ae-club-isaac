{% set products = ['coffee beans','merch','brewing supplies'] %}

select
  date_trunc(order_created_at, month) as date_month,
  {% for product in products%}
    sum(case when product_category = {{"\'" + product + "\'"}} then product_revenue end) as {{product|replace(" ", "_")}}_revenue,
  {% endfor %}
-- you may have to `ref` a different model here, depending on what you've built previously
from {{ ref('products') }}
group by 1