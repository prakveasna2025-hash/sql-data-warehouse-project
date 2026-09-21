/*
=============================================================
DDL Script: Create Bronze Tables
=============================================================
Creates the bronze-layer tables for the CRM and ERP source files:
  CRM
  - cust_info.csv     -> bronze.crm_cust_info
  - prd_info.csv      -> bronze.crm_prd_info
  - sales_details.csv -> bronze.crm_sales_details
  ERP
  - CUST_AZ12.csv     -> bronze.erp_cust_az12
  - LOC_A101.csv      -> bronze.erp_loc_a101
  - PX_CAT_G1V2.csv   -> bronze.erp_px_cat_g1v2

Bronze keeps the data as it arrives, so there are no primary keys
and no NOT NULL constraints. Cleansing happens in the silver layer.

WARNING: Each table is dropped and recreated if it already exists.
*/

USE DataWarehouse;
GO

-- ---------------------------------------------------------
-- bronze.crm_cust_info  (cust_info.csv)
-- ---------------------------------------------------------
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE
);
GO

-- ---------------------------------------------------------
-- bronze.crm_prd_info  (prd_info.csv)
-- ---------------------------------------------------------
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     INT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt   DATE
);
GO

-- ---------------------------------------------------------
-- bronze.crm_sales_details  (sales_details.csv)
-- Date columns are INT (YYYYMMDD) because sls_order_dt contains
-- values that are not valid 8-digit dates; they are converted
-- to DATE in the silver layer.
-- ---------------------------------------------------------
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);
GO

-- =========================================================
-- ERP tables
-- =========================================================

-- ---------------------------------------------------------
-- bronze.erp_cust_az12  (CUST_AZ12.csv)
-- CID carries a 'NAS' prefix in 11,042 rows (e.g. NASAW00011000).
-- GEN holds mixed values (Male, Female, M, F, blanks).
-- ---------------------------------------------------------
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
    cid   NVARCHAR(50),
    bdate DATE,
    gen   NVARCHAR(50)
);
GO

-- ---------------------------------------------------------
-- bronze.erp_loc_a101  (LOC_A101.csv)
-- CID uses a hyphen (AW-00011000); the CRM key does not.
-- ---------------------------------------------------------
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid   NVARCHAR(50),
    cntry NVARCHAR(50)
);
GO

-- ---------------------------------------------------------
-- bronze.erp_px_cat_g1v2  (PX_CAT_G1V2.csv)
-- ---------------------------------------------------------
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id          NVARCHAR(50),
    cat         NVARCHAR(50),
    subcat      NVARCHAR(50),
    maintenance NVARCHAR(50)
);
GO
