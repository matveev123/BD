--a)
CREATE VIEW Production.CategoryView (
	ProductCategoryID,
	CategoryName,
	CategoryRowguid,
	CategoryModifiedDate,
	ProductSubcategoryID,
	SubcategoryName,
	SubcategoryRowguid,
	SubcategoryModifiedDate
)
WITH ENCRYPTION, SCHEMABINDING AS
	SELECT
		category.ProductCategoryID,
		category.Name,
		category.rowguid,
		category.ModifiedDate,
		sub.ProductSubcategoryID,
		sub.Name,
		sub.rowguid,
		sub.ModifiedDate
	FROM Production.ProductCategory category
	INNER JOIN Production.ProductSubcategory sub ON category.ProductCategoryID = sub.ProductCategoryID;
GO

CREATE UNIQUE CLUSTERED INDEX CategoryID_Index ON Production.CategoryView (ProductCategoryID, ProductSubCategoryID);
GO

--b)
CREATE TRIGGER Production.CategoryViewInsert ON Production.CategoryView
INSTEAD OF INSERT AS
BEGIN
	DECLARE @category TABLE (ProductCategoryID int, rowguid uniqueidentifier);

	INSERT INTO Production.ProductCategory (Name, rowguid, ModifiedDate)
	OUTPUT INSERTED.ProductCategoryID, INSERTED.rowguid INTO @category
	SELECT DISTINCT CategoryName, CategoryRowguid, CategoryModifiedDate
	FROM INSERTED;

	INSERT INTO Production.ProductSubcategory (ProductCategoryID, Name, rowguid, ModifiedDate)
	SELECT category.ProductCategoryID, SubcategoryName, SubcategoryRowguid, SubcategoryModifiedDate
	FROM INSERTED
	INNER JOIN @category category ON category.rowguid = INSERTED.CategoryRowguid;
END;
GO

CREATE TRIGGER Production.CategoryViewUpdate ON Production.CategoryView
INSTEAD OF UPDATE AS
BEGIN
	UPDATE Production.ProductCategory
	SET
		Name = INSERTED.CategoryName,
		rowguid = INSERTED.CategoryRowguid,
		ModifiedDate = INSERTED.CategoryModifiedDate
	FROM INSERTED
	WHERE INSERTED.ProductCategoryID = ProductCategory.ProductCategoryID;

	UPDATE Production.ProductSubcategory
	SET
		Name = INSERTED.SubcategoryName,
		rowguid = INSERTED.SubcategoryRowguid,
		ModifiedDate = INSERTED.SubcategoryModifiedDate
	FROM INSERTED
	WHERE INSERTED.ProductSubCategoryID = ProductSubcategory.ProductSubcategoryID;
END;
GO

CREATE TRIGGER Production.CategoryViewDelete ON Production.CategoryView
INSTEAD OF DELETE AS
BEGIN
	DELETE sub
	FROM Production.ProductSubcategory sub
	INNER JOIN DELETED ON DELETED.ProductSubcategoryID = sub.ProductSubcategoryID;

	DELETE category
	FROM Production.ProductCategory category
	INNER JOIN DELETED ON DELETED.ProductCategoryID = category.ProductCategoryID;
END;
GO

--c)
INSERT INTO Production.CategoryView (
	CategoryName,
	CategoryRowguid,
	CategoryModifiedDate,
	SubcategoryName,
	SubcategoryRowguid,
	SubcategoryModifiedDate
)
VALUES ('newCategory', NEWID(), CURRENT_TIMESTAMP,'newSubCategory', NEWID(), CURRENT_TIMESTAMP);

UPDATE Production.CategoryView
SET
	CategoryName = 'newName',
	SubCategoryRowguid = NEWID()
WHERE CategoryName = 'newCategory';

DELETE Production.CategoryView WHERE CategoryName = 'newName';