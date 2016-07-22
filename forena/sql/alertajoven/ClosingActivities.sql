SELECT 
provider,
    program_name,
		sum(case when sexo = 'F' then 1 else 0 end) as Fem_Total,
		sum(case when sexo = 'M' then 1 else 0 end) as Mas_Total,
		SUM(case when Sexo != 'M' and Sexo != 'F' then 1 else 0 end) as Unk_Sex_Total,
		sum(case when age < 11 then 1 else 0 end) as Less_11_Total, 
		sum(case when age >= 11 and age <=17 then 1 else 0 end) as Bet_11_17_Total,
		sum(case when age >= 18 and age <= 24 then 1 else 0 end) as Bet_18_24_Total,
		sum(case when age > 24 then 1 else 0 end) as greater_24_Total,
		sum(case when age is null then 1 else 0 end) as unk_age_Total,
		sum(case when sexo = 'F' and age <11 then 1 else 0 end) as Fem_less_11_Total,
		sum(case when sexo = 'F' and age >=11 and age <=14 then 1 else 0 end) as Fem_11_14_Total,
		sum(case when sexo = 'F' and age > 14 then 1 else 0 end) as Fem_great_14_Total,
		sum(case when sexo = 'M' and age < 11 then 1 else 0 end) as Mas_less_11_Total,
		sum(case when sexo = 'M' and age >= 11 and age <= 14 then 1 else 0 end) as Mas_11_14_Total,
		sum(case when sexo = 'M' and age > 14 then 1 else 0 end) as Mas_great_14_Total,
		count(uuid) as Total
FROM
    (SELECT DISTINCT
        sexo,
            DATE_FORMAT(FROM_DAYS(DATEDIFF(DATE_FORMAT(NOW(), '%Y-%m-%d'), regs.dob)), '%Y') + 0 AS age,
            regs.uuid,
            program_name,
            provider
    FROM
        (SELECT 
        field_data_field_activity_name.entity_id AS activity_id,
            field_activity_name_value AS activity_name,
            field_agency_name_value AS provider,
            field_programname_name_value AS program_name
    FROM
        bitnami_drupal7.field_data_field_activity_name
	JOIN bitnami_drupal7.field_data_field_activity_date ON field_data_field_activity_date.entity_id = field_data_field_activity_name.entity_id
    JOIN bitnami_drupal7.field_data_field_activity_program ON field_data_field_activity_name.entity_id = field_data_field_activity_program.entity_id
    JOIN bitnami_drupal7.field_data_field_program_provider ON field_data_field_activity_program.field_activity_program_target_id = field_data_field_program_provider.entity_id
    JOIN bitnami_drupal7.field_data_field_agency_name ON field_data_field_agency_name.entity_id = field_data_field_program_provider.field_program_provider_target_id
    JOIN bitnami_drupal7.field_data_field_program_name ON field_data_field_activity_program.field_activity_program_target_id = field_data_field_program_name.entity_id
    JOIN bitnami_drupal7.field_data_field_programname_name ON field_data_field_programname_name.entity_id = field_data_field_program_name.field_program_name_target_id
    WHERE
        1 = 1
            AND field_activity_name_value REGEXP 
case 
when :exit_activity_name = 'all' then  '.*((Terminan capacitación técnica -)|(Obtienen documentación -)|(Graduados de EPC -)|(Reinsertados en la escuela -)).*'
when :exit_activity_name = 'Terminan capacitación técnica - ' then '.*Terminan capacitación técnica -.*' 
when :exit_activity_name = 'Obtienen documentación - ' then '.*Obtienen documentación -.*' 
when :exit_activity_name = 'Graduados de EPC - ' then '.*Graduados de EPC -.*'
when :exit_activity_name = 'Reinsertados en la escuela - ' then '.*Reinsertados en la escuela -.*'
end
		  
--IF=:from_date
and field_data_field_activity_date.field_activity_date_value >= :from_date
--END
--IF=:to_date
and field_data_field_activity_date.field_activity_date_value <= :to_date
--END

) AS allActivities
    JOIN bitnami_drupal7.aj_attendance atten ON atten.activity_id = allActivities.activity_id
    JOIN bitnami_drupal7.aj_registration regs ON regs.uuid = atten.uuid
    where
    1 = 1
    
--IF=:provider_id
and atten.provider_id in (:provider_id)

--SWITCH=:collateral
--CASE=collateral
and regs.Estecolateralparticipante = 'Sí'
--CASE=nonCollateral
and regs.Estecolateralparticipante != 'Sí'
--END

) allParticipants
GROUP BY provider, program_name
