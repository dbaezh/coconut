--ACCESS=access content
	SELECT 
    provider_id,
    CASE
        WHEN provider_id = 'ALL_PROVIDERS' THEN 'ALL_PROVIDERS'
        ELSE provider_name
    END AS provider_name,
    Fem_Total,
    Mas_Total,
    Unk_Total,
    Grand_Total
FROM
    (select
	IFNULL(provider_id, 'ALL_PROVIDERS') AS provider_id,
    provider_name,
    sum(case when sexo = 'F' then 1 else 0 end) as Fem_Total,
	sum(case when sexo = 'M' then 1 else 0 end) as Mas_Total,
	SUM(case when Sexo != 'M' and Sexo != 'F' then 1 else 0 end) as Unk_Total,
    count(distinct uuid) as Grand_Total
    from
(
SELECT distinct
    reg.uuid,
    reg.sexo,
    reg.dob,
    reg.provider_id,
    field_agency_name_value as provider_name
FROM
    bitnami_drupal7.aj_survey sur JOIN bitnami_drupal7.aj_registration reg ON sur.uuid = reg.uuid
    join bitnami_drupal7.field_data_field_agency_name agencyName on reg.provider_id = agencyName.entity_id
WHERE
  1 = 1 
--SWITCH=:collateral
-- estecolateralparticipante can have 1 of 4 values: No, Si, No Sabe (which means Don't know), blank (which means no value, not set)
--CASE=collateral
and reg.Estecolateralparticipante = 'Sí'
--CASE=nonCollateral
and reg.Estecolateralparticipante != 'Sí'
--END

--IF=:from_date
and reg.Fecha >= :from_date
--END
--IF=:to_date
and reg.Fecha <= :to_date
--END

and reg.provider_id in (:provider_id) 

AND 10Tienesunactadenacimientodominicana = 'No'
	) uniqueRecords
group by provider_id WITH ROLLUP) rollUP