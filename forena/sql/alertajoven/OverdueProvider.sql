--ACCESS=access content
SELECT ifnull(entity.field_agency_name_value, "Total") as 'Provider',
SUM(case when reg.fecha >= DATE_SUB(CURDATE(),INTERVAL 30  DAY) then 1 else 0 end) as 'days1',
SUM(case when reg.fecha >= DATE_SUB(CURDATE(),INTERVAL 60  DAY) and reg.fecha <= DATE_SUB(CURDATE(),INTERVAL 31  DAY) then 1 else 0 end) as 'days2',
SUM(case when reg.fecha >= DATE_SUB(CURDATE(),INTERVAL 90  DAY) and reg.fecha <= DATE_SUB(CURDATE(),INTERVAL 61  DAY) then 1 else 0 end) as 'days3',
SUM(case when reg.fecha >= DATE_SUB(CURDATE(),INTERVAL 90  DAY) then 1 else 0 end) as 'days4'
FROM bitnami_drupal7.aj_registration reg
join bitnami_drupal7.field_data_field_agency_name entity on entity.entity_id=reg.provider_id

where 1 = 1
-- don't really need the 1 = 1 but if the other where's go away, it IS needed.
--
and reg.provider_id = :provider_id
and entity.entity_type = 'provider'
and entity.bundle = 'provider'
and reg.uuid not in (select uuid from bitnami_drupal7.aj_survey)
group by entity.field_agency_name_value
WITH ROLLUP