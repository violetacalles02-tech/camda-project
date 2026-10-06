-- Desde el primer diagnóstico hasta el fin de la ventana del dataset (31-12-2022).
select
    (row_number() over (order by person_id))::INTEGER      as observation_period_id,
    person_id::INTEGER                                     as person_id,
    min(condition_start_date)::DATE                        as observation_period_start_date,
    '2022-12-31'::DATE                                     as observation_period_end_date,
    32817::INTEGER                                         as period_type_concept_id  -- EHR
from {{ ref('stg_condition_occurrence') }}
group by person_id