with pageviews as (

    select * from {{ ref('stg_web_tracking__pageviews') }}

), 

first_visitor_id as(

    select * from {{ ref('int_get_first_web_visitor_id') }}

),

set_first_visit_id_as_id as(

    select 
        pageviews.pageview_id,
        first_visitor_id.visitor_id, 
        pageviews.customer_id,
        pageviews.device_type, 
        pageviews.pageview_at, 
        pageviews.page 
    from 
        pageviews left join
        first_visitor_id using(customer_id)
        
), 

calc_seconds_since_last_pageview as(

    select
        *,
        if(  
            timestamp_diff(pageview_at, lag(pageview_at) over (partition by customer_id order by pageview_at), second)/(60*60) >= 30 or
            lag(pageview_at) over(partition by customer_id order by pageview_at) is null, -- if previous timestamp per customer is null, then it's the first pv of a session, otherwise, if it's been more than 30 min, its the first hit of a session
        1,0) is_session_start
    from 
        set_first_visit_id_as_id
    where 
        customer_id is not null
    order by 
        customer_id, pageview_at

),

calc_session_numbers as(

    select 
        *,
        sum(is_session_start) over (partition by customer_id order by pageview_at) session_number
    from
        calc_seconds_since_last_pageview
    order by
        customer_id, pageview_at

), 

assign_session_id as(

    select 
        *,
        md5(customer_id || session_number) as session_id,
    from
        calc_session_numbers
    order by
        customer_id, pageview_at

), 

append_session_id as(

    select
        set_first_visit_id_as_id.pageview_id,
        set_first_visit_id_as_id.visitor_id, 
        set_first_visit_id_as_id.customer_id,
        assign_session_id.session_id, 
        set_first_visit_id_as_id.device_type, 
        set_first_visit_id_as_id.pageview_at, 
        set_first_visit_id_as_id.page 
    from 
        set_first_visit_id_as_id left join 
        assign_session_id using(pageview_id)

)

select * from append_session_id




