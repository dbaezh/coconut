-- ACCESS=access content
SELECT 
	distinct(pnamename.entity_id), 
	pnamename.field_programname_name_value 
FROM bitnami_drupal7.field_data_field_programname_name pnamename
JOIN bitnami_drupal7.field_data_field_program_name pname on pname.field_program_name_target_id=pnamename.entity_id
JOIN bitnami_drupal7.field_data_field_program_provider pp on pname.entity_id=pp.entity_id

WHERE 1=1
order by pnamename.field_programname_name_value