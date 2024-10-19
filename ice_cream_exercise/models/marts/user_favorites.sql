with ice_cream_favorites as (

select * from {{ref('stg_ice_cream__favorite_ice_cream_flavors')}}

), 

date_spine as(

{{ dbt_utils.date_spine(
    datepart="day",
    start_date="(select min(date_trunc(cast(created_at as date), day)) from" + ref('stg_ice_cream__favorite_ice_cream_flavors') | string + ")",
    end_date="(select current_date() + 1)"
   )
}}

), 

spread_across_dates as (
  select 
    date_day as dt, 
    username, 
    favorite_flavor, 
    dbt_valid_to_exact, 
    last_updated_at
  from
    date_spine cross join 
    ice_cream_favorites where date_spine.date_day between ice_cream_favorites.dbt_valid_from and ice_cream_favorites.dbt_valid_to
), 

deduped as (

  select
    *, 
    row_number() over(partition by dt, username order by dbt_valid_to_exact desc) as dedupe_priority_within_day
  from
    spread_across_dates 

)

select 
  md5(dt || username) as user_date_id, 
  * except(dbt_valid_to_exact, dedupe_priority_within_day)
from
    deduped
where
    dedupe_priority_within_day = 1
order by
    dt desc, username

    