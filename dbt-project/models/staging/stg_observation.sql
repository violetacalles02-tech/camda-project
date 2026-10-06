-- Plantilla vacía de OBSERVATION (OMOP CDM v5.4): CAMDA no tiene observaciones.
-- Mantiene las columnas y tipos para que cdm.observation (passthrough) y los
-- checks de DQD que la leen funcionen con 0 filas.
select
    null::INTEGER     as observation_id,
    null::INTEGER     as person_id,
    null::INTEGER     as observation_concept_id,
    null::DATE        as observation_date,
    null::TIMESTAMP   as observation_datetime,
    null::INTEGER     as observation_type_concept_id,
    null::NUMERIC     as value_as_number,
    null::TEXT        as value_as_string,
    null::INTEGER     as value_as_concept_id,
    null::INTEGER     as qualifier_concept_id,
    null::INTEGER     as unit_concept_id,
    null::INTEGER     as provider_id,
    null::INTEGER     as visit_occurrence_id,
    null::INTEGER     as visit_detail_id,
    null::TEXT        as observation_source_value,
    null::INTEGER     as observation_source_concept_id,
    null::TEXT        as unit_source_value,
    null::TEXT        as qualifier_source_value,
    null::TEXT        as value_source_value,
    null::INTEGER     as observation_event_id,
    null::INTEGER     as obs_event_field_concept_id
where false