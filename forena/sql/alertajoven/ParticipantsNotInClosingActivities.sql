SELECT DISTINCT
    reg.uuid,
    nombre,
    apellido,
    sexo,
    DATE_FORMAT(FROM_DAYS(DATEDIFF(reg.fecha, reg.dob)), '%Y') + 0 AS age,
    9Dóndenaciste,
    field_agency_name_value AS provider,
    pnamename.field_programname_name_value AS programa
FROM
    bitnami_drupal7.aj_attendance atten 
JOIN bitnami_drupal7. aj_registration reg ON reg.uuid = atten.uuid
JOIN bitnami_drupal7.field_data_field_agency_name provider ON provider.entity_id=atten.provider_id
JOIN bitnami_drupal7.field_data_field_activity_name aname ON aname.entity_id=atten.activity_id
JOIN bitnami_drupal7.field_data_field_activity_date adate ON adate.entity_id=atten.activity_id
JOIN bitnami_drupal7.field_data_field_activity_program aprog ON aprog.entity_id=atten.activity_id
JOIN bitnami_drupal7.field_data_field_program_provider pp ON pp.entity_id=aprog.field_activity_program_target_id
JOIN bitnami_drupal7.field_data_field_program_name pname ON pname.entity_id=pp.entity_id
JOIN bitnami_drupal7.field_data_field_programname_name pnamename ON pnamename.entity_id=pname.field_program_name_target_id
JOIN bitnami_drupal7.aj_survey survey ON survey.uuid = reg.uuid
WHERE 1 = 1 

--IF=:provider_id
AND reg.provider_id IN (:provider_id)

--SWITCH=:collateral
--CASE=collateral
AND reg.Estecolateralparticipante = 'Sí'
--CASE=nonCollateral
AND reg.Estecolateralparticipante != 'Sí'
--END    

AND CASE 
WHEN :exit_activity_name = 'all' THEN pnamename.entity_id in (3,4,7,17)
WHEN :exit_activity_name = 'Terminan capacitación técnica - ' THEN pnamename.entity_id in (3)
WHEN :exit_activity_name = 'Obtienen documentación - ' THEN pnamename.entity_id in (4) 
WHEN :exit_activity_name = 'Graduados de EPC - ' THEN pnamename.entity_id in (7)
WHEN :exit_activity_name = 'Reinsertados en la escuela - ' THEN pnamename.entity_id in (17)
END

AND reg.uuid NOT IN (SELECT DISTINCT
    uuid
FROM
    (SELECT 
        field_data_field_activity_name.entity_id AS activity_id
    FROM
        bitnami_drupal7.field_data_field_activity_name
    JOIN bitnami_drupal7.field_data_field_activity_program ON field_data_field_activity_name.entity_id = field_data_field_activity_program.entity_id
    JOIN bitnami_drupal7.field_data_field_program_provider ON field_data_field_activity_program.field_activity_program_target_id = field_data_field_program_provider.entity_id
    JOIN bitnami_drupal7.field_data_field_agency_name ON field_data_field_agency_name.entity_id = field_data_field_program_provider.field_program_provider_target_id
    WHERE
     field_activity_name_value REGEXP
CASE 
WHEN :exit_activity_name = 'all' THEN  '.*((Terminan capacitación técnica -)|(Obtienen documentación -)|(Graduados de EPC -)|(Reinsertados en la escuela -)).*'
WHEN :exit_activity_name = 'Terminan capacitación técnica - ' THEN '.*Terminan capacitación técnica -.*' 
WHEN :exit_activity_name = 'Obtienen documentación - ' THEN '.*Obtienen documentación -.*' 
WHEN :exit_activity_name = 'Graduados de EPC - ' THEN '.*Graduados de EPC -.*'
WHEN :exit_activity_name = 'Reinsertados en la escuela - ' THEN '.*Reinsertados en la escuela -.*'
END

--IF=:provider_id
AND field_data_field_agency_name.entity_id IN  (:provider_id)

) AS allActivities
    JOIN bitnami_drupal7.aj_attendance atten ON atten.activity_id = allActivities.activity_id
)
GROUP BY atten.uuid