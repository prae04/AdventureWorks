SELECT --TOP 100 
org.OrganizationName
, porg.OrganizationName as ParentOrgName
, dep.DepartmentGroupName
, scn.ScenarioName
, acct.AccountDescription
, fin.FinanceKey
, fin.[Date]
, fin.Amount
, ForecastAmount = ISNULL(finbud.Amount,0)
, BudgetResult = fin.Amount - ISNULL(finbud.Amount,0)

-- , fin.*
FROM FactFinance fin
JOIN DimOrganization org on org.OrganizationKey = fin.OrganizationKey
JOIN DimScenario scn on scn.ScenarioKey = fin.ScenarioKey
JOIN DimAccount acct on acct.AccountKey = fin.AccountKey

LEFT JOIN DimDepartmentGroup dep on dep.DepartmentGroupKey = fin.DepartmentGroupKey
LEFT JOIN DimOrganization porg on porg.OrganizationKey = org.ParentOrganizationKey

--Budget
LEFT JOIN FactFinance finbud on finbud.OrganizationKey = fin.OrganizationKey and finbud.DepartmentGroupKey = fin.DepartmentGroupKey and fin.AccountKey = finbud.AccountKey AND finbud.datekey = fin.datekey and finbud.ScenarioKey = 2

WHERE 1=1
AND fin.ScenarioKey = 1 --actual, 2:Budget
AND org.OrganizationName = 'Northeast Division'
AND acct.AccountDescription = 'Salaries'
AND dep.DepartmentGroupName = 'Corporate'
-- AND org.OrganizationKey = 14
ORDER BY fin.[Date] desc
--max 20131228

-- SELECT TOP 100 *
-- FROM DimScenario
-- WHERE 1=1