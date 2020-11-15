--a)
CREATE FUNCTION HumanResources.DepartmentsCountFor(@GroupName nvarchar(50))
RETURNS int
BEGIN
	RETURN (
		SELECT COUNT(*) FROM HumanResources.Department
		WHERE Department.GroupName = @GroupName
	)
END;


--b)
CREATE FUNCTION HumanResources.GetOldestDepartmentEmployees(@DepartmentID int)
RETURNS TABLE AS
RETURN (
	SELECT TOP(3) empl.* FROM HumanResources.Employee empl
	INNER JOIN HumanResources.EmployeeDepartmentHistory hist ON empl.BusinessEntityID = hist.BusinessEntityID
	WHERE hist.DepartmentID = @DepartmentID AND hist.StartDate >= '2005' AND hist.EndDate IS NULL
	ORDER BY empl.BirthDate ASC
);


--c)
SELECT
	department.DepartmentID,
	employee.*
FROM HumanResources.Department department
CROSS APPLY HumanResources.GetOldestDepartmentEmployees(department.DepartmentID) employee;

SELECT
	department.DepartmentID,
	employee.*
FROM HumanResources.Department department
OUTER APPLY HumanResources.GetOldestDepartmentEmployees(department.DepartmentID) employee;

--d)
DROP FUNCTION HumanResources.GetOldestDepartmentEmployees;

CREATE FUNCTION HumanResources.GetOldestDepartmentEmployees(@DepartmentID int)
RETURNS @ResultTable TABLE(
	BusinessEntityID INT NOT NULL,
	BirthDate DATE NOT NULL,
	HireDate DATE NOT NULL,
	rowguid UNIQUEIDENTIFIER NOT NULL,
	ModifiedDate DATETIME NOT NULL
) AS BEGIN
	INSERT INTO @ResultTable
	SELECT TOP(3)
		empl.BusinessEntityID,
		empl.BirthDate,
		empl.HireDate,
		empl.rowguid,
		empl.ModifiedDate
	FROM HumanResources.Employee empl
	INNER JOIN HumanResources.EmployeeDepartmentHistory hist ON empl.BusinessEntityID = hist.BusinessEntityID
	WHERE hist.DepartmentID = @DepartmentID AND hist.StartDate >= '2005' AND hist.EndDate IS NULL
	ORDER BY empl.BirthDate ASC

	RETURN
END;
