-- ACCESS=access content
SELECT
-- ifnull(pnamename.field_programname_name_value, "Total") as 'Program',
SUM(case when reg.Sexo = 'M' then 1 else 0 end) as 'Male', 
SUM(case when reg.Sexo = 'F' then 1 else 0 end) as 'Female',
SUM(case when reg.Sexo = 'M' then 0 when reg.Sexo = 'F' then 0 else 1 end) as 'UnknownGender',
SUM(case when reg.Sexo = 'M' then 1 else 0 end)  +
SUM(case when reg.Sexo = 'F' then 1 else 0 end) +
SUM(case when reg.Sexo = 'M' then 0 when reg.Sexo = 'F' then 0 else 1 end) as 'TotalGender',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) < 11) then 1 else 0 end) as 'lessThan11',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 11) and (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) < 18) then 1 else 0 end) as 'age11to17',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 18) and (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) < 25) then 1 else 0 end) as 'age18to24',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 25)  then 1 else 0 end) as 'moreThan24',
SUM(case when reg.DOB is null then 1 else 0 end) as 'UnknownAge',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) < 11) then 1 else 0 end) +
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 11) and (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) < 18) then 1 else 0 end) +
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 18) and (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) < 25) then 1 else 0 end) +
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 25)  then 1 else 0 end) +
SUM(case when reg.DOB is null then 1 else 0 end) as 'TotalAge',
pnamename.field_programname_name_value as 'ProgramName', 
pp.field_program_provider_target_id as 'provider_id',
provider.field_agency_name_value as 'Provider'
FROM bitnami_drupal7.aj_registration reg
join bitnami_drupal7.aj_attendance atten on atten.uuid=reg.uuid
join bitnami_drupal7.field_data_field_agency_name provider on provider.entity_id=atten.provider_id
join bitnami_drupal7.field_data_field_activity_name aname on aname.entity_id=atten.activity_id
join bitnami_drupal7.field_data_field_activity_date adate on adate.entity_id=atten.activity_id
join bitnami_drupal7.field_data_field_activity_program aprog on aprog.entity_id=atten.activity_id
join bitnami_drupal7.field_data_field_program_provider pp on pp.entity_id=aprog.field_activity_program_target_id
join bitnami_drupal7.field_data_field_program_name pname on pname.entity_id=pp.entity_id
join bitnami_drupal7.field_data_field_programname_name pnamename on pnamename.entity_id=pname.field_program_name_target_id





-- don't really need the 1 = 1 but if the other where's go away, it IS needed.
where 1 = 1 
 
and atten.provider_id = :provider_id

--SWITCH=:collateral
-- estecolateralparticipante can have 1 of 4 values: No, Si, No Sabe (which means Don't know), blank (which means no value, not set)
--CASE=collateral
and reg.Estecolateralparticipante = 'Sí'
--CASE=nonCollateral
and reg.Estecolateralparticipante != 'Sí'
--END



--IF=:program_id
and aprog.field_activity_program_target_id = :program_id  
--END
--IF=:from_date
and adate.field_activity_date_value >= :from_date
--END
--IF=:to_date
and adate.field_activity_date_value <= :to_date
--END

group by pnamename.field_programname_name_value
-- WITH ROLLUP