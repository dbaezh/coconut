-- ACCESS=access content
SELECT ifnull(aname.field_activity_name_value, "Total") as 'Service Name',
SUM(case when reg.Sexo = 'M' then 1 else 0 end) as 'Male', 
SUM(case when reg.Sexo = 'F' then 1 else 0 end) as 'Female',
SUM(case when reg.Sexo = 'M' then 0 when reg.Sexo = 'F' then 0 else 1 end) as 'Unknown',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 11) and (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) <= 17) then 1 else 0 end) as '11-17',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 18) and (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) <= 24) then 1 else 0 end) as '18-24',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) > 24)  then 1 else 0 end) as '> 24',
SUM(case when reg.DOB = null then 1 else 0 end) as 'Unknown Age',
count(reg.Sexo) as 'Gender', pnamename.field_programname_name_value as Program, pp.field_program_provider_target_id as provider_id
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

-- and entity.entity_type = 'provider' 
-- and entity.bundle = 'provider'
-- and aprog.field_activity_program_target_id = 19
and aprog.field_activity_program_target_id = :program_id  
 
-- IF=:startdate
-- and adate.field_activity_date_value >= STR_TO_DATE('2000-01-01', '%Y-%m-%d')
-- and adate.field_activity_date_value <= STR_TO_DATE('2014-10-01', '%Y-%m-%d')

and adate.field_activity_date_value >= :from_date
and adate.field_activity_date_value <= :to_date

-- END
group by field_activity_name_value
WITH ROLLUP