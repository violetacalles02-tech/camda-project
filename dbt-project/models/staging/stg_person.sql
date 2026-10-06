-- Una fila por paciente. Fechas sintéticas: ver "Convención de fechas" en el README.
-- year_of_birth = 2022 - edad máxima registrada (ningún evento posterior a 2022).
-- Se agrega primero y se castea después, para no depender de cómo Postgres
-- empareja las expresiones del SELECT con el GROUP BY.
with per_patient as (
    select
        paciente_id,
        max(sexo)               as sexo,
        max(edad_diagnostico)   as max_edad
    from {{ source('base', 'camda_diagnoses') }}
    group by paciente_id
)

select
    paciente_id::INTEGER                                  as person_id,
    case sexo
        when 'Hombre' then 8507
        when 'Mujer'  then 8532
        else 0
    end::INTEGER                                          as gender_concept_id,
    (2022 - max_edad)::INTEGER                            as year_of_birth,
    null::INTEGER                                         as month_of_birth,
    null::INTEGER                                         as day_of_birth,
    null::TIMESTAMP                                       as birth_datetime,
    0::INTEGER                                            as race_concept_id,
    0::INTEGER                                            as ethnicity_concept_id,
    null::INTEGER                                         as location_id,
    null::INTEGER                                         as provider_id,
    null::INTEGER                                         as care_site_id,
    paciente_id::TEXT                                     as person_source_value,
    sexo::TEXT                                            as gender_source_value,
    0::INTEGER                                            as gender_source_concept_id,
    null::TEXT                                            as race_source_value,
    0::INTEGER                                            as race_source_concept_id,
    null::TEXT                                            as ethnicity_source_value,
    0::INTEGER                                            as ethnicity_source_concept_id
from per_patient