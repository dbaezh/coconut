-- ACCESS=access content
SELECT aname.entity_id, aname.field_activity_name_value 
FROM bitnami_drupal7.field_data_field_activity_name aname
JOIN bitnami_drupal7.field_data_field_activity_program ap on aname.entity_id=ap.entity_id
WHERE 1=1
and ap.field_activity_program_target_id = 13