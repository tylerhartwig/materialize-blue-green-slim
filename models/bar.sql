{{ config(materialized='view') }}

SELECT 
    person_name,
    favorite_color,
    CASE 
        WHEN favorite_color = 'blue' THEN 'Cool'
        WHEN favorite_color = 'red' THEN 'Warm'
        WHEN favorite_color = 'green' THEN 'Nature'
        ELSE 'Neutral'
    END as color_category
FROM {{ ref('foo') }}