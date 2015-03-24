SELECT
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




-- and aprog.field_activity_program_target_id = 61
and pnamename.entity_id = 4




group by reg.uuid, provider.entity_id) sub
group by sub.Provider


