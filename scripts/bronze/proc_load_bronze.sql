
/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/


create or alter procedure bronze.load_bronze as 
begin
	declare @start_time datetime, @end_time datetime
	begin try
	-- 1 Load
	print '=============================================';
	print 'Loading Bronze Layer';
	print '=============================================';

	print '-------------------------------';
	print 'Loading CRM Table';
	print '-------------------------------';

	set @start_time = getdate();
	print '>> Truncating Table: bronze.crm_cust_info'
	truncate table bronze.crm_cust_info;

	print '>> Inserting Table: bronze.crm_cust_info'
	bulk insert bronze.crm_cust_info
	from 'C:\Users\ASUS\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	with (
		firstrow = 2,
		fieldterminator = ',',
		rowterminator = '\n',
		codepage = '65001',
		tablock
	);
	set @end_time = getdate();
	print '>> ---------------------------------------------------------'
	print '>> Load Completed '
	print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	print '>> ---------------------------------------------------------'

	-- 2 Load
	set @start_time = getdate();
	print '>> Truncating Table: bronze.crm_sales_details'
	truncate table bronze.crm_sales_details;

	print '>> Inserting Table: bronze.crm_sales_details'
	bulk insert bronze.crm_sales_details
	from 'C:\Users\ASUS\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	with (
		firstrow = 2,
		fieldterminator = ',',
		rowterminator = '\n',
		codepage = '65001',
		tablock
	);
	set @end_time = getdate();
	print '>> ---------------------------------------------------------'
	print '>> Load Completed '
	print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	print '>> ---------------------------------------------------------'

	-- 3 Load
	set @start_time = getdate();
	print '>> Truncating Table: bronze.crm_prd_info'
	truncate table bronze.crm_prd_info;

	print '>> Inserting Table: bronze.crm_prd_info'
	bulk insert bronze.crm_prd_info
	from 'C:\Users\ASUS\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	with (
		firstrow = 2,
		fieldterminator = ',',
		rowterminator = '\n',
		codepage = '65001',
		tablock
	);
	set @end_time = getdate();
	print '>> ---------------------------------------------------------'
	print '>> Load Completed '
	print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	print '>> ---------------------------------------------------------'


	print '-------------------------------';
	print 'Loading ERP Table';
	print '-------------------------------';
	-- 4 Load
	set @start_time = getdate();
	print '>> Truncating Table: bronze.erp_cust_az12'
	truncate table bronze.erp_cust_az12;

	print '>> Inserting Table: bronze.erp_cust_az12'
	bulk insert bronze.erp_cust_az12
	from 'C:\Users\ASUS\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	with (
		firstrow = 2,
		fieldterminator = ',',
		rowterminator = '\n',
		codepage = '65001',
		tablock
	);
	set @end_time = getdate();
	print '>> ---------------------------------------------------------'
	print '>> Load Completed '
	print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	print '>> ---------------------------------------------------------'


	-- 5 Load  (fixed: table name has no .csv, and the file is LOC_A101.csv)
	set @start_time = getdate();
	print '>> Truncating Table: bronze.erp_loc_a101'
	truncate table bronze.erp_loc_a101;

	print '>> Inserting Table: bronze.erp_loc_a101'
	bulk insert bronze.erp_loc_a101
	from 'C:\Users\ASUS\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	with (
		firstrow = 2,
		fieldterminator = ',',
		rowterminator = '\n',
		codepage = '65001',
		tablock
	);
	set @end_time = getdate();
	print '>> ---------------------------------------------------------'
	print '>> Load Completed '
	print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	print '>> ---------------------------------------------------------'


	-- 6 Load  (fixed: table name has no .csv, and the file is PX_CAT_G1V2.csv)
	set @start_time = getdate();
	print '>> Truncating Table: bronze.erp_px_cat_g1v2'
	truncate table bronze.erp_px_cat_g1v2;

	print '>> Inserting Table:bronze.erp_px_cat_g1v2'
	bulk insert bronze.erp_px_cat_g1v2
	from 'C:\Users\ASUS\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	with (
		firstrow = 2,
		fieldterminator = ',',
		rowterminator = '\n',
		codepage = '65001',
		tablock
	);

	set @end_time = getdate();
	print '>> ---------------------------------------------------------'
	print '>> Load Completed '
	print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	print '>> ---------------------------------------------------------'

	end try
	begin catch 
	print '=============================================';
	print 'ERROR OCCERED DURING LOADING BRONZE LATER';
	print 'ERROR Message' + ERROR_MESSAGE();
	print 'ERROR Message' + CAST (ERROR_NUMBER() as NVARCHAR);
	print 'ERROR Message' + CAST (ERROR_STATE() as NVARCHAR);
	print '=============================================';
	end catch
end 
