--ACCESS=access content
SELECT 
    *
FROM
    (SELECT 
        provider_id, Fem_Total, Mas_Total, Unk_Total, Grand_Total
    FROM
        (SELECT 
        IFNULL(provider_id, 'ALL_PROVIDERS') AS provider_id,
            provider_name,
            SUM(CASE
                WHEN sexo = 'F' THEN 1
                ELSE 0
            END) AS Fem_Total,
            SUM(CASE
                WHEN sexo = 'M' THEN 1
                ELSE 0
            END) AS Mas_Total,
            SUM(CASE
                WHEN Sexo != 'M' AND Sexo != 'F' THEN 1
                ELSE 0
            END) AS Unk_Total,
            COUNT(uuid) AS Grand_Total
    FROM
        (SELECT DISTINCT
        reg.provider_id, reg.provider_name, reg.uuid, sexo
    FROM
        bitnami_drupal7.aj_survey sur
    JOIN bitnami_drupal7.aj_registration reg ON sur.uuid = reg.uuid
    WHERE
   1 = 1 
--SWITCH=:collateral
-- estecolateralparticipante can have 1 of 4 values: No, Si, No Sabe (which means Don't know), blank (which means no value, not set)
--CASE=collateral
and reg.Estecolateralparticipante = 'Sí'
--CASE=nonCollateral
and reg.Estecolateralparticipante != 'Sí'
--END

--IF=:from_date
and SUBSTRING(sur.createdAt, 1, 10) >= :from_date
--END
--IF=:to_date
and SUBSTRING(sur.createdAt, 1, 10) <= :to_date
--END

            AND (87BCondón = 'true'
            || 87CCondónfemenino = 'true'
            || 87DPíldoraanticonceptiva = 'true'
            || 87HDIUcomoMirenaoParagard = 'true'
            || 87IInyecci = 'true'
            || 87JImplant = 'true'
            || 87KEsterilizaciónfemenina = 'true'
            || 87LEsterilizaciónmasculina = 'true'
            || 87NOtro IN ('Anticonceptivo' , 'Aparatico ', 'Aparatico en el brazo ', 'APARATO AUTICONCEPTIVO', 'APARATO EN EL BRAZO', 'DIU', 'DOPLA', 'Emergencia', 'Estoy Preparada', 'EVITA', 'EVITAL', 'Implanon', 'INYECCION', 'INYECCION ANTICOMCEPTIVA', 'Inyección cada 3 Meses', 'Inyeccion de planificacion', 'LIGADAL', 'los tuvitos', 'Microtul', 'Noplan', 'OLANIFICACION', 'Operada para no tener hijos', 'PASTILLA', 'PASTILLA AFTHERDAY', 'PASTILLA AFTHERDAY', 'Pastilla anticonceptiva ', 'Pastilla de emergencia', 'pastilla de planificacion', 'pastilla emergencia', 'Pastilla Perla', 'pastillas', 'PASTILLAS DE EMERGENCIA', 'PASTILLAS DE PLANIFICACION', 'PASTILLAS PARA EVITAR EMBARAZO', 'planificacion', 'PLANIFICACION (PASTILLA)', 'PLANIFICACIÓN EN EL BRAZO', 'PLANIFICACION VIA ORAL', 'Planificación.', 'Planificada', 'Planificadora', 'PREPARADA', 'Tubito', 'Tuvitos', 'una pastilla', 'VACUNA'))) uniqueRecords
    GROUP BY provider_id WITH ROLLUP) rollUP) AS tb1
        RIGHT JOIN
    (SELECT 
        provider_id,
            CASE
                WHEN provider_id = 'ALL_PROVIDERS' THEN 'ALL_PROVIDERS'
                ELSE provider_name
            END AS provider_name,
            TotalUNIVERSE
    FROM
        (SELECT 
        IFNULL(provider_id, 'ALL_PROVIDERS') AS provider_id,
            provider_name,
            COUNT(uuid) AS TotalUNIVERSE
    FROM
        (SELECT DISTINCT
        reg.provider_id, reg.provider_name, reg.uuid, sexo
    FROM
        bitnami_drupal7.aj_survey sur
    JOIN bitnami_drupal7.aj_registration reg ON sur.uuid = reg.uuid
    WHERE
   1 = 1 
--SWITCH=:collateral
-- estecolateralparticipante can have 1 of 4 values: No, Si, No Sabe (which means Don't know), blank (which means no value, not set)
--CASE=collateral
and reg.Estecolateralparticipante = 'Sí'
--CASE=nonCollateral
and reg.Estecolateralparticipante != 'Sí'
--END

--IF=:from_date
and SUBSTRING(sur.createdAt, 1, 10) >= :from_date
--END
--IF=:to_date
and SUBSTRING(sur.createdAt, 1, 10) <= :to_date
--END
            AND 82Algunavezhastenidorelacionessexuales = 'Sí') uniqueRecords
    GROUP BY provider_id WITH ROLLUP) rollUP2) AS tb2 USING (provider_id)
