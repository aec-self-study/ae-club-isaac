{% snapshot favorite_ice_cream_flavors %}
 
{{ config(
      target_schema='dbt_isaac_snapshots',
      unique_key='github_username',
      strategy='timestamp',
      updated_at='updated_at',
 ) }}
 
select * from {{source('advanced_dbt_examples', 'favorite_ice_cream_flavors')}}
 
{% endsnapshot %}