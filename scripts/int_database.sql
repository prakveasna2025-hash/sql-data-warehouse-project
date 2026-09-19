/*
=============================================================
Create Database and Schemas
=============================================================
Creates the 'DataWarehouse' database (dropping it first if it exists)
and three schemas: bronze, silver, gold.

WARNING: Running this script deletes the existing 'DataWarehouse'
database and all of its data. Use it only in development.
*/

USE master;
GO

-- Drop and recreate the database if it already exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
