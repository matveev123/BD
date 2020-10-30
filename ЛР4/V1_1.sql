--a)
CREATE TABLE Production.ProductCategoryHst (
	ID bigint PRIMARY KEY IDENTITY(1, 1),
	Action nchar(6) NOT NULL CHECK (Action IN('INSERT', 'UPDATE', 'DELETE')),
	ModifiedDate datetime NOT NULL,
	SourceID int NOT NULL,
	UserName nvarchar(30) NOT NULL
);

--b)
CREATE TRIGGER Production.ProductCategoryActionTrigger ON Production.ProductCategory
AFTER INSERT, UPDATE, DELETE AS
	DECLARE @datetime DATETIME;
	SET @datetime = CURRENT_TIMESTAMP;

	INSERT INTO Production.ProductCategoryHst (
		Action,
		ModifiedDate,
		SourceID,
		UserName
	)
	SELECT
		'UPDATE',
		@datetime,
		INSERTED.ProductCategoryID,
		CURRENT_USER
	FROM INSERTED
	INNER JOIN DELETED ON INSERTED.ProductCategoryID = DELETED.ProductCategoryID
	UNION ALL
		SELECT
			'INSERT',
			@datetime,
			INSERTED.ProductCategoryID,
			CURRENT_USER
		FROM INSERTED
		LEFT JOIN DELETED ON INSERTED.ProductCategoryID = DELETED.ProductCategoryID
		WHERE DELETED.ProductCategoryID IS NULL
	UNION ALL
		SELECT
			'DELETE',
			@datetime,
			DELETED.ProductCategoryID,
			CURRENT_USER
		FROM DELETED
		LEFT JOIN INSERTED ON INSERTED.ProductCategoryID = DELETED.ProductCategoryID
		WHERE INSERTED.ProductCategoryID IS NULL;

--c)
CREATE VIEW Production.ProductCategoryView AS
	SELECT * FROM Production.ProductCategory;

--d)
INSERT INTO Production.ProductCategoryView (Name)
VALUES ('newCategory');

UPDATE Production.ProductCategoryView SET Name = 'newName' WHERE Name = 'newCategory';

DELETE Production.ProductCategoryView WHERE Name = 'newName';

SELECT * FROM Production.ProductCategoryHst;