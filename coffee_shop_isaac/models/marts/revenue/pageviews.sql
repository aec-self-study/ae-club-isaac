{{
  config(
    materialized = "table",
    partition_by={
      "field": "pageview_at",
      "data_type": "timestamp",
      "granularity": "day"
    },
    cluster_by = "customer_id"
  )
}}

with pageviews_with_session_ids as(
  
  select * from {{ ref('int_assign_session_ids') }}
  
),

pageviews_with_session_ids_ordered as(
  select 
    *
  from 
    pageviews_with_session_ids
  order by 
    pageview_at 
)

select * from pageviews_with_session_ids_ordered