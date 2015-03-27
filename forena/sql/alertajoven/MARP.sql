SELECT 
'HSH',
SUM(case when reg.Sexo = 'M' then 1 else 0 end) as 'Male', 
SUM(case when reg.Sexo = 'F' then 1 else 0 end) as 'Female',
SUM(case when reg.Sexo = 'M' then 0 when reg.Sexo = 'F' then 0 else 1 end) as 'Unknown',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 11) and (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) <= 17) then 1 else 0 end) as 'age11to17',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 18) and (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) <= 24) then 1 else 0 end) as 'age18to24',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) > 24)  then 1 else 0 end) as 'morethan24',
SUM(case when reg.DOB = null then 1 else 0 end) as 'UnknownAge',
count(reg.Sexo) as 'Total', provider.entity_id as 'provider_id'
FROM bitnami_drupal7.aj_registration reg
join bitnami_drupal7.aj_marp marp on marp.uuid=reg.uuid
join bitnami_drupal7.field_data_field_agency_name provider on provider.entity_id=marp.provider_id




where 1 = 1 
-- don't really need the 1 = 1 but if the other where's go away, it IS needed.
-- 

--IF=:provider_id
and provider.entity_id = :provider_id
--END



and  marp.Hombresquetienensexoconhombres = 'true'

UNION 
-- ACCESS=access content
SELECT 
'TRSX',
SUM(case when reg.Sexo = 'M' then 1 else 0 end) as 'Male', 
SUM(case when reg.Sexo = 'F' then 1 else 0 end) as 'Female',
SUM(case when reg.Sexo = 'M' then 0 when reg.Sexo = 'F' then 0 else 1 end) as 'Unknown',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 11) and (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) <= 17) then 1 else 0 end) as 'age11to17',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 18) and (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) <= 24) then 1 else 0 end) as 'age18to24',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) > 24)  then 1 else 0 end) as 'morethan24',
SUM(case when reg.DOB = null then 1 else 0 end) as 'UnknownAge',
count(reg.Sexo) as 'Total', provider.entity_id as 'provider_id'
FROM bitnami_drupal7.aj_registration reg
join bitnami_drupal7.aj_marp marp on marp.uuid=reg.uuid
join bitnami_drupal7.field_data_field_agency_name provider on provider.entity_id=marp.provider_id




where 1 = 1 
-- don't really need the 1 = 1 but if the other where's go away, it IS needed.
-- 

--IF=:provider_id
and provider.entity_id = :provider_id
--END



and  marp.Lostrabajadoresdelsexo = 'true'

UNION

SELECT 
'PWID',
SUM(case when reg.Sexo = 'M' then 1 else 0 end) as 'Male', 
SUM(case when reg.Sexo = 'F' then 1 else 0 end) as 'Female',
SUM(case when reg.Sexo = 'M' then 0 when reg.Sexo = 'F' then 0 else 1 end) as 'Unknown',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 11) and (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) <= 17) then 1 else 0 end) as 'age11to17',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) >= 18) and (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) <= 24) then 1 else 0 end) as 'age18to24',
SUM(case when (cast((datediff( NOW(), reg.DOB) / 365) AS SIGNED) > 24)  then 1 else 0 end) as 'morethan24',
SUM(case when reg.DOB = null then 1 else 0 end) as 'UnknownAge',
count(reg.Sexo) as 'Total', provider.entity_id as 'provider_id'
FROM bitnami_drupal7.aj_registration reg
join bitnami_drupal7.aj_marp marp on marp.uuid=reg.uuid
join bitnami_drupal7.field_data_field_agency_name provider on provider.entity_id=marp.provider_id




where 1 = 1 
-- don't really need the 1 = 1 but if the other where's go away, it IS needed.
-- 

--IF=:provider_id
and provider.entity_id = :provider_id
--END



and  marp.Usuariosdedrogasintravenosas = 'true'