{% test us_zip_code(model, column_name) %}
    select
        {{ column_name }}
 
    from {{ model }}
 where not(regexp_contains(cast({{ column_name }} as string), r'^\d{5}(?:[-\s]\d{4})?$'))
 {% endtest %}



