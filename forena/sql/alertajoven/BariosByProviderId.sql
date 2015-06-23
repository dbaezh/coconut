-- ACCESS=access content
SELECT  BarrioComunidad, BarrioComunidad FROM bitnami_drupal7.aj_registration 
-- IF=:entity_id
WHERE provider_id = :entity_id 
-- ELSE
WHERE provider_id is null
-- END
order by BarrioComunidad

