-- ACCESS=access content
SELECT ifnull(services_count,0), agency.field_agency_name_value FROM
(SELECT
count(aprog.entity_id) as 'services_count',
pnamename.field_programname_name_value as 'program_name', 
pp.field_program_provider_target_id as 'provider_id',
provider.field_agency_name_value as 'provider',
aprog.field_activity_program_target_id as 'program_id'

FROM bitnami_drupal7.field_data_field_activity_program aprog
join bitnami_drupal7.field_data_field_program_provider pp on pp.entity_id=aprog.field_activity_program_target_id
join bitnami_drupal7.field_data_field_program_name pname on pname.entity_id=pp.entity_id
join bitnami_drupal7.field_data_field_programname_name pnamename on pnamename.entity_id=pname.field_program_name_target_id
join bitnami_drupal7.field_data_field_agency_name provider on provider.entity_id=pp.field_program_provider_target_id
join bitnami_drupal7.field_data_field_activity_date adate on adate.entity_id=aprog.entity_id

where 1 = 1 


--IF=:provider_id
and provider.entity_id = :provider_id
--END





--IF=:program_name_id
and pnamename.entity_id = :program_name_id
--END

--IF=:from_date
and adate.field_activity_date_value >= :from_date
--END

--IF=:to_date
and adate.field_activity_date_value <= :to_date
--END

group by provider.entity_id
order by provider.field_agency_name_value) sub



RIGHT JOIN bitnami_drupal7.field_data_field_agency_name agency ON agency.entity_id = sub.provider_id


order by agency.field_agency_name_value


