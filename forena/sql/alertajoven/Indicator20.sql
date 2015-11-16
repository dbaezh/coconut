-- ACCESS=access content
select * from (select provider_id as provider_id, 
--	field_agency_name_value as provider_name,  
	count(distinct uuid) as totalUUID
from (
select 
	distinct marp.provider_id, 
	field_agency_name_value,  
	marp.uuid 
from bitnami_drupal7.aj_marp  marp 
	join bitnami_drupal7.`aj_attendance` atten on atten.uuid = marp.uuid
	join bitnami_drupal7.`field_data_field_agency_name` agencyName on marp.provider_id = agencyName.entity_id
	join bitnami_drupal7.`field_data_field_agency_active` agencyActive on marp.provider_id = agencyActive.entity_id
where
	field_agency_active_value = 1
	and marp.provider_id in (:provider_id)
order by field_agency_name_value
) distinctMarp
group by provider_id) as tb1

 RIGHT JOIN
 
 (select provider_id as provider_id, 
	field_agency_name_value as provider_name,  
	count(distinct uuid) as totalUniverse
from (
select 
	distinct marp.provider_id, 
	field_agency_name_value,  
	marp.uuid 
from bitnami_drupal7.aj_marp  marp 
	join bitnami_drupal7.`field_data_field_agency_name` agencyName on marp.provider_id = agencyName.entity_id
	join bitnami_drupal7.`field_data_field_agency_active` agencyActive on marp.provider_id = agencyActive.entity_id
where
	field_agency_active_value = 1
	and marp.provider_id in (:provider_id)
order by field_agency_name_value
) distinctMarp
group by provider_id)  AS tb2 USING (provider_id)