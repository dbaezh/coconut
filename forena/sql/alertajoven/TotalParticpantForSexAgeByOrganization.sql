--ACCESS=access content
select provider_id,
		provider_name,
--IF=:program_id
 		(select group_concat(field_programname_name_value) from bitnami_drupal7.field_data_field_programname_name where entity_id in (:program_id)) as target_programs,
--ELSE
 		'All Programs' as target_programs,
--END
--IF=:activity_type_id
 		(select group_concat(field_activitytype_name_value) from bitnami_drupal7.field_data_field_activitytype_name where entity_id in (:activity_type_id)) as target_activities,
--ELSE
 		'All activities' as target_activities,
--END
		sum(case when sexo = 'F' then 1 else 0 end) as Fem_Total,
		sum(case when sexo = 'M' then 1 else 0 end) as Mas_Total,
		SUM(case when Sexo != 'M' and Sexo != 'F' then 1 else 0 end) as Unk_Total,
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
from
(
Select 	distinct provider_id, provider_name, uuid, sexo, age
from (
SELECT 
		reg.uuid,
		reg.Nombre,
		reg.Apellido,
		reg.sexo,
		reg.dob,
		DATE_FORMAT(FROM_DAYS(DATEDIFF(DATE_FORMAT(NOW(), '%Y-%m-%d'), reg.dob)), '%Y')+0 AS age,
		provider.entity_id as provider_id,
		provider.field_agency_name_value as provider_name,
		pname.entity_id as program_id,
		pname.field_program_name_target_id as program_name,
		pnamename.entity_id as program_type_id,
		pnamename.field_programname_name_value as program_type_name,
		atypename.entity_id as activity_type_id,
		atypename.field_activitytype_name_value as activity_type_name,
		aname.entity_id as activity_id,
		aname.field_activity_name_value as activity_name
FROM
	bitnami_drupal7.aj_attendance atten 
join bitnami_drupal7. aj_registration reg ON reg.uuid = atten.uuid
join bitnami_drupal7.field_data_field_agency_name provider on provider.entity_id=atten.provider_id
join bitnami_drupal7.field_data_field_activity_name aname on aname.entity_id=atten.activity_id
join bitnami_drupal7.field_data_field_activity_type atype on atten.activity_id=atype.entity_id
join bitnami_drupal7.field_data_field_activitytype_name atypename on atype.field_activity_type_target_id=atypename.entity_id
join bitnami_drupal7.field_data_field_activity_date adate on adate.entity_id=atten.activity_id
join bitnami_drupal7.field_data_field_activity_program aprog on aprog.entity_id=atten.activity_id
join bitnami_drupal7.field_data_field_program_provider pp on pp.entity_id=aprog.field_activity_program_target_id
join bitnami_drupal7.field_data_field_program_name pname on pname.entity_id=pp.entity_id
join bitnami_drupal7.field_data_field_programname_name pnamename on pnamename.entity_id=pname.field_program_name_target_id

where 1 = 1 
--SWITCH=:collateral
-- estecolateralparticipante can have 1 of 4 values: No, Si, No Sabe (which means Don't know), blank (which means no value, not set)
--CASE=collateral
and reg.Estecolateralparticipante = 'Sí'
--CASE=nonCollateral
and reg.Estecolateralparticipante != 'Sí'
--END
and atten.provider_id in (:provider_id)
--IF=:program_id
and pnamename.entity_id in (:program_id)
--END
--IF=:activity_type_id
 and atypename.entity_id in (:activity_type_id)
--END
--IF=:from_date
and adate.field_activity_date_value >= :from_date
--END
--IF=:to_date
and adate.field_activity_date_value <= :to_date
--END

order by provider_id) 
as ParticipantXProviderXProgramXActivityTemp)
 as NoDuplicateduuid
group by provider_id
order by provider_name;