with source as(

    select * from {{ source('coffee_shop', 'orders') }}

),

renamed as(

select 
    id order_id, 
    customer_id, 
    total as order_revenue, 
    address, 
    state, 
    zip, 
    created_at as order_created_at
from
    source

)

select * from renamed