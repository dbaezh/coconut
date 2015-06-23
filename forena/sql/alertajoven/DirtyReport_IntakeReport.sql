--ACCESS=access content
SELECT ifnull(reg.provider_id, "Grand Total") as 'Provider', 
SUM(case when reg.Sexo = 'M' then 1 else 0 end) as Male, 
SUM(case when reg.Sexo = 'F' then 1 else 0 end) as Female,
SUM(case when reg.Sexo = 'M' then 0 when reg.Sexo = 'F' then 0 else 1 end) as 'Not Set',
count(reg.Sexo) as Gender
FROM bitnami_drupal7.aj_registration reg
join aj_survey survey on survey.uuid=reg.uuid
where 1 = 1 
-- don't really need the 1 = 1 but if the other where's go away, it IS needed.
-- 
and survey.createdAt is not null
--IF=:reportStartDate
and survey.createdAt >= :reportStartDate
--END

group by reg.provider_id
WITH ROLLUP
