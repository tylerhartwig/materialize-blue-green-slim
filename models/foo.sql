{{ config(materialized='view') }}

SELECT 
    'Alice' as person_name,
    'blue' as favorite_color

UNION ALL

SELECT 
    'Bob' as person_name,
    'green' as favorite_color

UNION ALL

SELECT 
    'Carol' as person_name,
    'red' as favorite_color