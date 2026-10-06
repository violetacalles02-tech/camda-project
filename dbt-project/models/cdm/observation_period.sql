-- observation_period

{{
    config(
        materialized="table",
    )
}}


SELECT * 
FROM {{ ref('stg_observation_period') }}