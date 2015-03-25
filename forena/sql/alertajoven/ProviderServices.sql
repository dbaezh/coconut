SELECT 
ifnull(sub.services_count,0), agency.field_agency_name_value, ifnull(sub.program_name,'Doc') FROM
(SELECT
count(aprog.entity_id) AS 'services_count',
pnamename.field_programname_name_value as 'program_name', 
pp.field_program_provider_target_id as 'provider_id',
provider.field_agency_name_value as 'provider',
aprog.field_activity_program_target_id as 'program_id'

FROM bitnami_drupal7.field_data_field_activity_program aprog
join bitnami_drupal7.field_data_field_program_provider pp on pp.entity_id=aprog.field_activity_program_target_id
join bitnami_drupal7.field_data_field_program_name pname on pname.entity_id=pp.entity_id
join bitnami_drupal7.field_data_field_programname_name pnamename on pnamename.entity_id=pname.field_program_name_target_id
join bitnami_drupal7.field_data_field_agency_name provider on provider.entity_id=pp.field_program_provider_target_id
where 1 = 1 




-- and aprog.field_activity_program_target_id = 61
and pnamename.entity_id = 10




group by provider.entity_id
order by provider.field_agency_name_value) sub



RIGHT JOIN bitnami_drupal7.field_data_field_agency_name agency ON agency.entity_id = sub.provider_id
-- where sub.provider_id = sub2.provid

order by agency.field_agency_name_value


