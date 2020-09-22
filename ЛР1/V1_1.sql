USE master;
GO

CREATE DATABASE Ilya_Matveev;
GO

USE Ilya_Matveev;
GO

CREATE SCHEMA sales;
GO

CREATE SCHEMA persons;
GO

CREATE TABLE sales.Orders (OrderNum INT NULL);
GO

BACKUP DATABASE Ilya_Matveev
	TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\Backup\Ilya_Matveev.bak';
GO

USE master;
GO

DROP DATABASE Ilya_Matveev;
GO

RESTORE DATABASE Ilya_Matveev	
	FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\Backup\Ilya_Matveev.bak';
GO