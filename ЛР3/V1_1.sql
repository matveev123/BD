

--a)
ALTER TABLE dbo.Person
ADD FullName nvarchar(100);
GO

--b)
DECLARE @Person TABLE (
	BusinessEntityID INT,
	PersonType nchar(2),
	NameStyle NameStyle NULL,
	Title nvarchar(8),
	FirstName Name,
	MiddleName Name,
	LastName Name,
	Suffix nvarchar(5),
	EmailPromotion INT,
	ModifiedDate datetime,
	ID bigint,
	FullName nvarchar(100)
);

INSERT INTO @Person (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	ID,
	FullName
)
SELECT
	person.BusinessEntityID,
	person.PersonType,
	person.NameStyle,
	CASE employee.Gender
		WHEN 'M' THEN 'Mr.'
		WHEN 'F' THEN 'Ms.'
		ELSE NULL
	END as Title,
	person.FirstName,
	person.MiddleName,
	person.LastName,
	person.Suffix,
	person.EmailPromotion,
	person.ModifiedDate,
	person.ID,
	person.FullName
FROM dbo.Person person
LEFT JOIN HumanResources.Employee employee ON employee.BusinessEntityID = person.BusinessEntityID;

--c)
MERGE INTO dbo.Person person
USING @Person person2 ON person.ID = person2.ID
WHEN MATCHED THEN
   UPDATE SET person.FullName = CONCAT(person2.Title, ' ', person2.FirstName, ' ', person2.LastName);

--d)
DELETE FROM dbo.Person WHERE LEN(FullName) > 20;

--e)
ALTER TABLE dbo.Person
DROP CONSTRAINT PK__Person__3214EC27FF04D095, CHK_Title, DF_Suffix;

ALTER TABLE dbo.Person
DROP COLUMN ID;

--f)
DROP TABLE dbo.Person;
