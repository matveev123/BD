--1
SELECT BusinessEntityId
	,JobTitle
	,Gender
	,HireDate
FROM HumanResources.Employee
WHERE (JobTitle LIKE 'Accounts Manager')
	OR (JobTitle LIKE 'Benefits Specialist')
	OR (JobTitle LIKE 'Engineering Manager')
	OR (JobTitle LIKE 'Finance Manager')
	OR (JobTitle LIKE 'Maintenance Supervisor')
	OR (JobTitle LIKE 'Network Manager')
	OR (JobTitle LIKE 'Master Scheduler')

--2
SELECT COUNT(HireDate) 'EmpCount'
FROM HumanResources.Employee
WHERE HireDate >= '2004-01-01'

--3
SELECT TOP 5 BusinessEntityId
	,JobTitle
	,MaritalStatus
	,Gender
	,BirthDate
	,HireDate
FROM HumanResources.Employee
WHERE MaritalStatus = 'M'
	AND HireDate >= '2004-01-01'
	AND HireDate <= '2004-12-31'
ORDER BY BirthDate DESC
