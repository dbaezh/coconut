--ACCESS=access content
SELECT `labor`.`provider_id`,
    field_agency_name_value,
   if(NOW() - INTERVAL 3 MONTH < labor.`created` and`4_Actualmentetienesuntrabajoenel` = 'No' and `9_Enlosultimos12meseshashecho` = 'No', 'Editable', 'Finalizada') as EstatusDeEncuesta,
    labor.user_name,
    labor.uuid,
    nombre,
    apellido,
    sexo,
    DATE_FORMAT(FROM_DAYS(DATEDIFF(regs.fecha, regs.dob)), '%Y')+0 AS age,
    `labor`.`1_HasparticipadoenalguncursodelproyectoAlerta`,
    `labor`.`2_Hasparticipadoenalguntallerocursodelproyecto`,
    `labor`.`3_Hasparticipadoenalguntallerocursodelproyecto`,
    labor.4_3Cualcursorealizaste,
    labor.4_3Otrofavorespecificar,
    `labor`.`4_Actualmentetienesuntrabajoenel`,
    labor.4_4Nombredelaempresa,
    labor.4_5Telefonodelaempresa,
    `labor`.`4_1Quehacesenesetrabajo`,
    labor.4_1Otrofavorespecificar,
    labor.4_2Esestetuprimerempleo,
    `labor`.`5_Cuantotiempotienesenestetrabajo`,
    `labor`.`6_Estetrabajoes`,
    labor.6_2Entutrabajoactualtepaganelseguromedico,
    `labor`.`6_Otrofavorespecificar`,
    `labor`.`6_1Bajocualcondicion`,
    `labor`.`6_1Otrofavorespecificar`,
    `labor`.`7_Cuantoganasenunasemana`,
    `labor`.`8_Cuandoiniciasteelcursotecnicoyaestabas`,
    `labor`.`8_1Considerasquetutrabajoactual`,
    labor.8_2Porqueconsideraqueesunmejorempleo,
    `labor`.`9_Enlosultimos12meseshashecho`,
    `labor`.`9_1Quehaciasenesetrabajo`,
    labor.9_2Nombredelaempresa,
    labor.9_3Telefonodelaempresa,
    labor.9_1Otrofavorespecificar,
    `labor`.`10_Cuantotiempodurasteenestetrabajo`,
    `labor`.`11_Esetrabajoera`,
    `labor`.`11_Otrofavorespecificar`,
    `labor`.`11_1Bajocualcondicion`,
    `labor`.`11_1Otrofavorespecificar`,
    labor.11_2Entutrabajoanteriortepagabanseguro,
    `labor`.`12_Cuantoganabasenunasemana`,
    `labor`.`13_Hasrecibidounprestamoatravesdelproyecto`,
    labor.13_1Quemontorecibiste,
    labor.13_2Quemontogeneratunegociomensualmente,
    `labor`.`14_Tienesunnegociopropio`,
    labor.14_1Aquesededicatunegocio,
    `labor`.`created`
from `bitnami_drupal7`.`aj_labor` labor
join bitnami_drupal7.field_data_field_agency_name agency on agency.entity_id = provider_id
join (select uuid, nombre, apellido, sexo, dob,Fecha from bitnami_drupal7.aj_registration group by uuid) regs using(uuid)
where 1 = 1 

and labor.provider_id in (:provider_id)
--IF=:from_date
and labor.created >= :from_date
--END
--IF=:to_date
and labor.created <= :to_date
--END

--IF=:from_date_reg
and regs.Fecha >= :from_date_reg
--END
--IF=:to_date_reg
and regs.Fecha <= :to_date_reg
--END

order by provider_id