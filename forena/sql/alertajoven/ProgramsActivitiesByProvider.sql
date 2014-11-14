

SELECT aname.field_activity_name_value as 'ServiceName', adate.field_activity_date_value as 'Service Date', pnamename.field_programname_name_value as 'Program', pp.field_program_provider_target_id as 'provider_id', aname.entity_id as 'activity_id'
FROM bitnami_drupal7.field_data_field_activity_name aname


join bitnami_drupal7.field_data_field_activity_program aprog on aname.entity_id=aprog.entity_id
join bitnami_drupal7.field_data_field_program_provider pp on pp.entity_id=aprog.field_activity_program_target_id
join bitnami_drupal7.field_data_field_program_name pname on pname.entity_id=pp.entity_id
join bitnami_drupal7.field_data_field_programname_name pnamename on pname.field_program_name_target_id=pnamename.entity_id
join bitnami_drupal7.field_data_field_activity_date adate on adate.entity_id=aname.entity_id




where 1 = 1 
-- don't really need the 1 = 1 but if the other where's go away, it IS needed.
-- 
-- IF=6
 and pp.field_program_provider_target_id = 6  
-- END


-- and aprog.field_activity_program_target_id = :program_id  
group by aname.entity_id











