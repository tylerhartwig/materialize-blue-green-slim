{{ config(materialized='view') }}

SELECT 
    person_name,
    favorite_color,
    color_category,
    CASE 
        WHEN color_category = 'Cool' THEN 'Relaxing'
        WHEN color_category = 'Warm' THEN 'Energizing'
        ELSE 'Balanced'
    END as mood_type
FROM {{ ref('bar') }}
WHERE color_category != 'Neutral'