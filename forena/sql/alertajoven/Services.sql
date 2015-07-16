-- ACCESS=access content
SELECT 
ifnull(field_activity_name_value, "Total") as 'ServiceName', 
DATE_FORMAT(field_activity_date_value,'%m-%d-%Y')  as 'ActivityDate',
SUM(case when Sexo = 'M' then 1 else 0 end) as 'Male', 
SUM(case when Sexo = 'F' then 1 else 0 end) as 'Female',
SUM(case when Sexo = 'M' then 0 when Sexo = 'F' then 0 else 1 end) as 'Unknown',
SUM(case when (cast((datediff( NOW(), DOB) / 365) AS SIGNED) < 11) and (cast((datediff( NOW(), DOB) / 365) AS SIGNED) <= 17) then 1 else 0 end) as 'lessthan11',
SUM(case when (cast((datediff( NOW(), DOB) / 365) AS SIGNED) >= 11) and (cast((datediff( NOW(), DOB) / 365) AS SIGNED) <= 17) then 1 else 0 end) as 'age11to17',
SUM(case when (cast((datediff( NOW(), DOB) / 365) AS SIGNED) >= 18) and (cast((datediff( NOW(), DOB) / 365) AS SIGNED) <= 24) then 1 else 0 end) as 'age18to24',
SUM(case when (cast((datediff( NOW(), DOB) / 365) AS SIGNED) > 24)  then 1 else 0 end) as 'morethan24',
SUM(case when (cast((datediff( NOW(), DOB) / 365) AS SIGNED) is null) then 1 else 0 end) as 'UnknownAge',
count(Sexo) as 'Gender', 
count(uuid) as 'TotalUUID',
field_programname_name_value as 'Program', 
field_program_provider_target_id as 'provider_id'
from
(select distinct
        aname.field_activity_name_value,
		adate.field_activity_date_value,
		reg.Sexo,
		reg.DOB,
		pnamename.field_programname_name_value,
		pp.field_program_provider_target_id,
		reg.uuid,
		activity_id
FROM bitnami_drupal7.aj_registration reg
join bitnami_drupal7.aj_attendance atten on atten.uuid=reg.uuid
join bitnami_drupal7.field_data_field_agency_name provider on provider.entity_id=atten.provider_id
join bitnami_drupal7.field_data_field_activity_name aname on aname.entity_id=atten.activity_id
join bitnami_drupal7.field_data_field_activity_date adate on adate.entity_id=aname.entity_id
join bitnami_drupal7.field_data_field_activity_program aprog on aname.entity_id=aprog.entity_id
join bitnami_drupal7.field_data_field_program_provider pp on pp.entity_id=aprog.field_activity_program_target_id
join bitnami_drupal7.field_data_field_program_name pname on pname.entity_id=pp.entity_id
join bitnami_drupal7.field_data_field_programname_name pnamename on pname.field_program_name_target_id=pnamename.entity_id


where 1 = 1 
-- don't really need the 1 = 1 but if the other where's go away, it IS needed.
-- 
--IF=:provider_id
and pp.field_program_provider_target_id = :provider_id  
--END

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

--group by aname.field_activity_name_value
--WITH ROLLUP
) distinctUUIDs
group by activity_id