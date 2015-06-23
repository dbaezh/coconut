SELECT ifnull(UniqueParticipants,0), agency.field_agency_name_value, sub2.ProgramName, sub2.provider_id FROM
(SELECT
count(sub.uuid) as 'UniqueParticipants',
sub.ProgramName as 'ProgramName', 
sub.provider_id as 'provider_id',
sub.Provider as 'Provider'
FROM (
SELECT reg.SEXO, reg.DOB,reg.uuid as 'uuid',
pnamename.field_programname_name_value as 'ProgramName', 
pp.field_program_provider_target_id as 'provider_id',
provider.field_agency_name_value as 'Provider',
aprog.field_activity_program_target_id as 'Program_id'

FROM bitnami_drupal7.aj_registration reg
join bitnami_drupal7.aj_attendance atten on atten.uuid=reg.uuid
join bitnami_drupal7.field_data_field_agency_name provider on provider.entity_id=atten.provider_id
join bitnami_drupal7.field_data_field_activity_name aname on aname.entity_id=atten.activity_id
join bitnami_drupal7.field_data_field_activity_date adate on adate.entity_id=atten.activity_id
join bitnami_drupal7.field_data_field_activity_program aprog on aprog.entity_id=atten.activity_id
join bitnami_drupal7.field_data_field_program_provider pp on pp.entity_id=aprog.field_activity_program_target_id
join bitnami_drupal7.field_data_field_program_name pname on pname.entity_id=pp.entity_id
join bitnami_drupal7.field_data_field_programname_name pnamename on pnamename.entity_id=pname.field_program_name_target_id
where 1 = 1 
and reg.uuid in (select distinct(atten.uuid) from bitnami_drupal7.aj_attendance atten)




-- and pnamename.entity_id = 4
--IF=:program_name_id
and pnamename.entity_id = :program_name_id
--END

--SWITCH=:collateral
-- estecolateralparticipante can have 1 of 4 values: No, Si, No Sabe (which means Don't know), blank (which means no value, not set)
--CASE=collateral
and reg.Estecolateralparticipante = 'Sí'
--CASE=nonCollateral
and reg.Estecolateralparticipante != 'Sí'
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


group by reg.uuid, provider.entity_id) sub
group by sub.Provider

order by sub.Provider) sub2

RIGHT JOIN bitnami_drupal7.field_data_field_agency_name agency ON agency.entity_id = sub2.provider_id




order by agency.field_agency_name_value

