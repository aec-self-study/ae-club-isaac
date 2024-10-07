with assign_session_ids as(
  
  select * from {{ ref('int_assign_session_ids') }}
  
),

session_meta as(

    select 
        session_id,
        min(pageview_at) as session_started_at, 
        max(pageview_at) as session_ended_at, 
        timestamp_diff(max(pageview_at), min(pageview_at), second) as session_duration, 
        count(distinct(page)) as pages_visited, 
        if(sum(if(page = 'order-confirmation',1,0)) >= 1, 'had_purchase', 'no_purchase') as had_purchase
    from 
        assign_session_ids
    where
        session_id is not null
    group by
        session_id
    order by
        session_started_at 

)

select * from session_meta