--ACCESS=access content
SELECT 
    *
FROM
    (SELECT 
        provider_id, 
        Les_15_Total,
            Bet_15_24_Total,
            Gre_24_Total,
            Unk_Total,
            Grand_Total
    FROM
        (SELECT 
        IFNULL(provider_id, 'ALL_PROVIDERS') AS provider_id,
            provider_name,
            SUM(CASE
                WHEN age < 15 THEN 1
                ELSE 0
            END) AS Les_15_Total,
            SUM(CASE
                WHEN age >= 15 AND age <= 24 THEN 1
                ELSE 0
            END) AS Bet_15_24_Total,
            SUM(CASE
                WHEN age > 24 THEN 1
                ELSE 0
            END) AS Gre_24_Total,
			SUM(CASE
                WHEN age is null THEN 1
                ELSE 0
            END) AS Unk_Total,
            COUNT(uuid) AS Grand_Total
    FROM
        (SELECT DISTINCT
        reg.provider_id,
            reg.provider_name,
            reg.uuid,
            DATE_FORMAT(FROM_DAYS(DATEDIFF(DATE_FORMAT(NOW(), '%Y-%m-%d'), reg.dob)), '%Y') + 0 AS age
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
and reg.provider_id != ''
                
            AND 16Actualmenteestasasistiendoa = 'Ninguno'
            AND (26Durantel = 'No' || 26Durantel = '')) uniqueRecords
    GROUP BY provider_id WITH ROLLUP) rollUP) as tb1
        right JOIN
   (SELECT 
            provider_id,
            CASE
                WHEN provider_id = 'ALL_PROVIDERS' THEN 'ALL_PROVIDERS'
                ELSE provider_name
            END AS provider_name,
                Bet_15_24_Total_UNIVERSE,
                Total_UNIVERSE
        FROM
            (SELECT 
            IFNULL(provider_id, 'ALL_PROVIDERS') AS provider_id,
                provider_name,
                SUM(CASE
                    WHEN age >= 15 AND age <= 24 THEN 1
                    ELSE 0
                END) AS Bet_15_24_Total_UNIVERSE,
                COUNT( uuid) AS Total_UNIVERSE
        FROM
            (SELECT DISTINCT
            reg.provider_id,
                reg.provider_name,
                reg.uuid,
                DATE_FORMAT(FROM_DAYS(DATEDIFF(DATE_FORMAT(NOW(), '%Y-%m-%d'), reg.dob)), '%Y') + 0 AS age
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
and reg.provider_id != ''
                ) uniqueRecords
        GROUP BY provider_id WITH ROLLUP) rollup2) as tb2 
        using (provider_id)
