RESTORE FILELISTONLY 
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\Backup\AdventureWorksLT2022.bak';
GO

RESTORE DATABASE AdventureWorks2022
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\Backup\AdventureWorksLT2022.bak'
WITH MOVE N'AdventureWorksLT2022' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\AdventureWorksLT2022_Data.mdf',
     MOVE N'AdventureWorksLT2022_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\AdventureWorksLT2022_Log.ldf',
     REPLACE, RECOVERY, STATS = 10;
GO

RESTORE DATABASE AdventureWorksLT2022
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\Backup\AdventureWorksLT2022.bak'
WITH MOVE N'AdventureWorksLT2022_Data' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\AdventureWorksLT2022_Data.mdf',
     MOVE N'AdventureWorksLT2022_Log'  TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\AdventureWorksLT2022_Log.ldf',
     REPLACE, RECOVERY, STATS = 10;
GO


SELECT name, state_desc FROM sys.databases WHERE name='AdventureWorksLT2022';
GO
USE AdventureWorksLT2022;
SELECT TOP 5 * FROM SalesLT.SalesOrderHeader;
SELECT TOP 5 * FROM SalesLT.Product;