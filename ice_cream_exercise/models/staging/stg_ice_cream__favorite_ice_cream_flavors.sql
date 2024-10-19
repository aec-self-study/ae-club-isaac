with source as (
  
  select * from {{source('dbt_isaac_snapshots', 'favorite_ice_cream_flavors')}}  

),

renamed as(

select
  github_username as username, 
  favorite_ice_cream_flavor as favorite_flavor, 
  created_at, 
  cast(updated_at as date) as last_updated_at, 
  cast(dbt_valid_from as date) dbt_valid_from,
  cast(coalesce(dbt_valid_to, current_timestamp()) as date) dbt_valid_to, 
  coalesce(dbt_valid_to, current_timestamp()) dbt_valid_to_exact
from 
  source

)

select * from renamed 
