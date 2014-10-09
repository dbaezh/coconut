-- ACCESS=access content
SELECT ifnull(aname.field_activity_name_value, "Total") as 'ServiceName',
SUM(case when reg.Sexo = 'M' then 1 else 0 end) as 'Male', 
SUM(case when reg.Sexo = 'F' then 1 else 0 end) as 'Female',
SUM(case when reg.Sexo = 'M' then 0 when reg.Sexo = 'F' then 0 else 1 end) as 'Unknown',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 11) and (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) <= 17) then 1 else 0 end) as 'age11to17',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 18) and (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) <= 24) then 1 else 0 end) as 'age18to24',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) > 24)  then 1 else 0 end) as 'morethan24',
SUM(case when reg.DOB = null then 1 else 0 end) as 'UnknownAge',
count(reg.Sexo) as 'Gender', pnamename.field_programname_name_value as 'Program', pp.field_program_provider_target_id as 'provider_id'
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
and pp.entity_id = :provider_id  
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

group by aname.field_activity_name_value
WITH ROLLUP