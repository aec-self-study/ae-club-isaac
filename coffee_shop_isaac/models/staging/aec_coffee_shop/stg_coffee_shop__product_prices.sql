with source as(

    select * from {{ source('coffee_shop', 'product_prices') }}

),

renamed as(

select 
    id as product_prices_id, 
    product_id, 
    price, 
    created_at as product_or_price_created_at, 
    ended_at as product_or_price_ended_at
  from 
    source
    
)

select * from renamed