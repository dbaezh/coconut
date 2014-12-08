--ACCESS=access content
SELECT 'both' AS 'code', 'All' AS 'name' 
UNION ALL 
SELECT 'collateral', 'Collateral only'
UNION ALL 
SELECT 'nonCollateral', 'Non-Collateral only'
