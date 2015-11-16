--ACCESS=access content
SELECT 
'HSH',
SUM(case when Sexo = 'M' then 1 else 0 end) as 'Male', 
SUM(case when Sexo = 'F' then 1 else 0 end) as 'Female',
SUM(case when Sexo = 'M' then 0 when Sexo = 'F' then 0 else 1 end) as 'Unknown',
SUM(case when (cast((datediff( NOW(), DOB) / 365) AS SIGNED) >= 11) and (cast((datediff( NOW(), DOB) / 365) AS SIGNED) <= 17) then 1 else 0 end) as 'age11to17',
SUM(case when (cast((datediff( NOW(), DOB) / 365) AS SIGNED) >= 18) and (cast((datediff( NOW(), DOB) / 365) AS SIGNED) <= 24) then 1 else 0 end) as 'age18to24',
SUM(case when (cast((datediff( NOW(), DOB) / 365) AS SIGNED) > 24)  then 1 else 0 end) as 'morethan24',
SUM(case when DOB = null then 1 else 0 end) as 'UnknownAge',
count(uuid) as 'Total', 
entity_id as 'provider_id',
field_agency_name_value as provider_name
from (
select distinct marp.uuid, sexo, dob, entity_id, field_agency_name_value
FROM bitnami_drupal7.aj_registration reg
join bitnami_drupal7.aj_marp marp on marp.uuid=reg.uuid
join bitnami_drupal7.field_data_field_agency_name provider on provider.entity_id=marp.provider_id
where 1 = 1 
--IF=:provider_id
	and provider.entity_id in (:provider_id)
--END
and  marp.Hombresquetienensexoconhombres = 'true'
) distinctHSH
group by provider_id

UNION 

SELECT 
'TRSX',
SUM(case when Sexo = 'M' then 1 else 0 end) as 'Male', 
SUM(case when Sexo = 'F' then 1 else 0 end) as 'Female',
SUM(case when Sexo = 'M' then 0 when Sexo = 'F' then 0 else 1 end) as 'Unknown',
SUM(case when (cast((datediff( NOW(), DOB) / 365) AS SIGNED) >= 11) and (cast((datediff( NOW(), DOB) / 365) AS SIGNED) <= 17) then 1 else 0 end) as 'age11to17',
SUM(case when (cast((datediff( NOW(), DOB) / 365) AS SIGNED) >= 18) and (cast((datediff( NOW(), DOB) / 365) AS SIGNED) <= 24) then 1 else 0 end) as 'age18to24',
SUM(case when (cast((datediff( NOW(), DOB) / 365) AS SIGNED) > 24)  then 1 else 0 end) as 'morethan24',
SUM(case when DOB = null then 1 else 0 end) as 'UnknownAge',
count(uuid) as 'Total', 
entity_id as 'provider_id',
field_agency_name_value as provider_name
from (
select distinct marp.uuid, sexo, dob, entity_id, field_agency_name_value
FROM bitnami_drupal7.aj_registration reg
join bitnami_drupal7.aj_marp marp on marp.uuid=reg.uuid
join bitnami_drupal7.field_data_field_agency_name provider on provider.entity_id=marp.provider_id
where 1 = 1 
--IF=:provider_id
	and provider.entity_id in (:provider_id)
--END
and  marp.Lostrabajadoresdelsexo = 'true'
) distinctTRSX
group by provider_id

UNION

SELECT 
'PWID',
SUM(case when Sexo = 'M' then 1 else 0 end) as 'Male', 
SUM(case when Sexo = 'F' then 1 else 0 end) as 'Female',
SUM(case when Sexo = 'M' then 0 when Sexo = 'F' then 0 else 1 end) as 'Unknown',
SUM(case when (cast((datediff( NOW(), DOB) / 365) AS SIGNED) >= 11) and (cast((datediff( NOW(), DOB) / 365) AS SIGNED) <= 17) then 1 else 0 end) as 'age11to17',
SUM(case when (cast((datediff( NOW(), DOB) / 365) AS SIGNED) >= 18) and (cast((datediff( NOW(), DOB) / 365) AS SIGNED) <= 24) then 1 else 0 end) as 'age18to24',
SUM(case when (cast((datediff( NOW(), DOB) / 365) AS SIGNED) > 24)  then 1 else 0 end) as 'morethan24',
SUM(case when DOB = null then 1 else 0 end) as 'UnknownAge',
count(uuid) as 'Total', 
entity_id as 'provider_id',
field_agency_name_value as provider_name
from (
select distinct marp.uuid, sexo, dob, entity_id, field_agency_name_value
FROM bitnami_drupal7.aj_registration reg
join bitnami_drupal7.aj_marp marp on marp.uuid=reg.uuid
join bitnami_drupal7.field_data_field_agency_name provider on provider.entity_id=marp.provider_id
where 1 = 1 
--IF=:provider_id
	and provider.entity_id in (:provider_id)
--END
and  marp.Usuariosdedrogasintravenosas = 'true'
) distinctPWID
group by provider_id