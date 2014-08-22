-- ACCESS=access content
SELECT r.BarrioComunidad, r.Municipio, r.Provincia,r.Apellido, r.Nombre, r.Fecha,  datediff( NOW(), r.Fecha) as daysactive,
STR_TO_DATE(CONCAT(r.Día,'-', r.Mes, '-', r.Año), '%d-%m-%Y') as dob,
cast((datediff( NOW(), STR_TO_DATE(CONCAT(r.Año,'-', r.Mes, '-', r.Día), '%Y-%m-%d')) / 365) AS SIGNED) as age,
r.Celular,r.Calleynumero
FROM bitnami_drupal7.aj_registration r
join bitnami_drupal7.aj_survey s on s.uuid=r.uuid
where s.createdAt is not null and r.provider_id = 6
-- END


