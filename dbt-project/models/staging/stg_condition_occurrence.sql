-- Fecha sintética: 1 de enero del año (year_of_birth + edad al diagnóstico).
-- Desempate entre diagnósticos de la misma edad: orden del fichero (row_id)
-- sumado en segundos a condition_start_datetime.
with dx as (
    select
        row_id,
        paciente_id::INTEGER                                              as person_id,
        edad_diagnostico::INTEGER                                         as age_at_dx,
        lpad(codigo_enfermedad::TEXT, 4, '0')                             as source_code,
        (row_number() over (partition by paciente_id order by row_id) - 1) as dx_order
    from {{ source('base', 'camda_diagnoses') }}
),

mapping as (
    select
        lpad(source_code::TEXT, 4, '0')   as source_code,
        source_concept_id,
        target_concept_id
    from {{ ref('condition_mapping') }}
)

select
    dx.row_id::INTEGER                                                    as condition_occurrence_id,
    dx.person_id                                                          as person_id,
    coalesce(m.target_concept_id, 0)::INTEGER                             as condition_concept_id,
    make_date(p.year_of_birth + dx.age_at_dx, 1, 1)::DATE                 as condition_start_date,
    (make_date(p.year_of_birth + dx.age_at_dx, 1, 1)::TIMESTAMP
        + dx.dx_order * interval '1 second')::TIMESTAMP                   as condition_start_datetime,
    null::DATE                                                            as condition_end_date,
    null::TIMESTAMP                                                       as condition_end_datetime,
    32817::INTEGER                                                        as condition_type_concept_id,  -- EHR
    null::INTEGER                                                         as condition_status_concept_id,
    null::TEXT                                                            as stop_reason,
    null::INTEGER                                                         as provider_id,
    null::INTEGER                                                         as visit_occurrence_id,
    null::INTEGER                                                         as visit_detail_id,
    dx.source_code::TEXT                                                  as condition_source_value,
    coalesce(m.source_concept_id, 0)::INTEGER                             as condition_source_concept_id,
    null::TEXT                                                            as condition_status_source_value
from dx
join {{ ref('stg_person') }} p on p.person_id = dx.person_id
left join mapping m on m.source_code = dx.source_code