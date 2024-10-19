-- testing model with same name as module
with generated as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2021-01-03' as date)",
        end_date="cast('2021-10-01' as date)"
    ) }}
)

select * 
from generated
