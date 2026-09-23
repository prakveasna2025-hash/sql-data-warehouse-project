# Data Catalog — Silver Layer

The silver layer holds the cleaned and standardized version of the CRM and
ERP source data. Each table mirrors its bronze counterpart, with the values
cleansed and, where noted, restructured by `silver.load_silver`.

---

## silver.crm_cust_info

One row per customer, deduplicated to the most recent record.

| Column | Type | Description |
|---|---|---|
| cst_id | INT | Customer ID from the CRM system. Deduplicated: if a customer appears more than once in the source, only the row with the latest `cst_create_date` is kept. Rows with no `cst_id` are dropped. |
| cst_key | NVARCHAR(50) | Customer's tracking key, used to join to the ERP tables. |
| cst_firstname | NVARCHAR(50) | First name, leading/trailing spaces removed. |
| cst_lastname | NVARCHAR(50) | Last name, leading/trailing spaces removed. |
| cst_marital_status | NVARCHAR(50) | Standardized to `Single`, `Married`, or `n/a`. |
| cst_gndr | NVARCHAR(50) | Standardized to `Female`, `Male`, or `n/a`. |
| cst_create_date | DATE | Date the customer record was created in the CRM source system. |
| dwh_create_date | DATETIME2 | Timestamp this row was loaded into the silver layer. |

---

## silver.crm_prd_info

One row per product version. `prd_key` from bronze is split into a
category ID and a shorter product key.

| Column | Type | Description |
|---|---|---|
| prd_id | INT | Product ID from the CRM system. |
| cat_id | NVARCHAR(50) | Category ID, taken from the first part of the bronze `prd_key` (e.g. `CO-RF` becomes `CO_RF`). Joins to `erp_px_cat_g1v2.id`. |
| prd_key | NVARCHAR(50) | Product key, taken from the remainder of the bronze `prd_key` (e.g. `FR-R92B-58`). Joins to `crm_sales_details.sls_prd_key`. |
| prd_nm | NVARCHAR(50) | Product name. |
| prd_cost | INT | Base cost. Blank values in the source become `0`. |
| prd_line | NVARCHAR(50) | Standardized to `Mountain`, `Road`, `Other Sales`, `Touring`, or `n/a`. |
| prd_start_dt | DATE | Date this product version became active. |
| prd_end_dt | DATE | Date this product version stopped being active, calculated as one day before the next version's start date. `NULL` for the current version. |
| dwh_create_date | DATETIME2 | Timestamp this row was loaded into the silver layer. |

---

## silver.crm_sales_details

One row per sales order line.

| Column | Type | Description |
|---|---|---|
| sls_ord_num | NVARCHAR(50) | Sales order number. |
| sls_prd_key | NVARCHAR(50) | Product key, joins to `crm_prd_info.prd_key`. |
| sls_cust_id | INT | Customer ID, joins to `crm_cust_info.cst_id`. |
| sls_order_dt | DATE | Date the order was placed. `NULL` if the source value was `0` or not a valid 8-digit date. |
| sls_ship_dt | DATE | Date the order was shipped. Same validation as `sls_order_dt`. |
| sls_due_dt | DATE | Date payment was due. Same validation as `sls_order_dt`. |
| sls_sales | INT | Total line value. Recalculated as `quantity × \|price\|` whenever the source value was missing, zero or negative, or didn't match that formula. |
| sls_quantity | INT | Number of units ordered. |
| sls_price | INT | Price per unit. Derived as `sales ÷ quantity` whenever the source value was missing, zero, or negative. |
| dwh_create_date | DATETIME2 | Timestamp this row was loaded into the silver layer. |

---

## silver.erp_cust_az12

One row per customer, from the ERP system. Supplements `crm_cust_info`.

| Column | Type | Description |
|---|---|---|
| cid | NVARCHAR(50) | Customer key. The `NAS` prefix present on some source values is removed so it matches `crm_cust_info.cst_key`. |
| bdate | DATE | Date of birth. Future dates in the source are set to `NULL`. |
| gen | NVARCHAR(50) | Standardized to `Female`, `Male`, or `n/a`. |
| dwh_create_date | DATETIME2 | Timestamp this row was loaded into the silver layer. |

---

## silver.erp_loc_a101

One row per customer location.

| Column | Type | Description |
|---|---|---|
| cid | NVARCHAR(50) | Customer key. Hyphens present in the source are removed so it matches `crm_cust_info.cst_key`. |
| cntry | NVARCHAR(50) | Standardized country name (e.g. `US`/`USA` become `United States`, `DE` becomes `Germany`). Blank or missing values become `n/a`. |
| dwh_create_date | DATETIME2 | Timestamp this row was loaded into the silver layer. |

---

## silver.erp_px_cat_g1v2

One row per product category. Passed through from bronze unchanged, since
the source was already clean.

| Column | Type | Description |
|---|---|---|
| id | NVARCHAR(50) | Category ID. Joins to `crm_prd_info.cat_id`. |
| cat | NVARCHAR(50) | High-level category, e.g. `Bikes`, `Components`. |
| subcat | NVARCHAR(50) | More detailed classification within the category. |
| maintenance | NVARCHAR(50) | Whether products in this category require maintenance (`Yes`/`No`). |
| dwh_create_date | DATETIME2 | Timestamp this row was loaded into the silver layer. |

---

## How the tables connect

```
crm_cust_info ----cst_key = cid----> erp_cust_az12
      |                                  (birthdate, gender)
      |
      +-----cst_key = cid------------> erp_loc_a101
      |                                  (country)
      |
      | cst_id = sls_cust_id
      v
crm_sales_details <--sls_prd_key = prd_key-- crm_prd_info --cat_id = id--> erp_px_cat_g1v2
```
