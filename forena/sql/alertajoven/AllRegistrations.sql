-- ACCESS=access content
SELECT 
    aj_registration.provider_id,
    aj_registration.provider_name,
    aj_registration.uuid,
    aj_registration.Fecha,
    aj_registration.Nombre,
    aj_registration.Apellido,
    aj_registration.Apodo,
    aj_registration.Calleynumero,
    aj_registration.BarrioComunidad,
    aj_registration.Municipio,
    aj_registration.Provincia,
    aj_registration.DOB,
    aj_registration.Año,
    aj_registration.Mes,
    aj_registration.Día,
    aj_registration.Sexo,
    aj_registration.Tieneunnumerocelular,
    aj_registration.Celular,
    aj_registration.Tieneunnumerodetelefonoenlacasa,
    aj_registration.Casa,
    aj_registration.Tieneunadireccióndecorreoelectrónico,
    aj_registration.Direccióndecorreoelectrónico,
    aj_registration.TieneunnombredeusuariodeFacebook,
    aj_registration.NombredeusuariodeFacebook,
    aj_registration.Nombredepersonadecontacto,
    aj_registration.Parentescoopersonarelacionada,
    aj_registration.Teléfono,
    aj_registration.Estecolateralparticipante,
 --   aj_registration.Completado,
-- 	aj_registration.id,
 --    aj_registration._id,
 --    aj_registration._rev,
    aj_registration.createdAt,
    aj_registration.lastModifiedAt,
--     aj_registration.question,
    aj_registration.user_name
 --    aj_registration.created,
  --   aj_registration.changed
FROM bitnami_drupal7.aj_registration
where 
1 =1
and provider_id in (15)

