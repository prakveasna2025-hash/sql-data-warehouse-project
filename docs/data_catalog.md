# Data Catalog — Gold Layer

The gold layer is the business-ready layer of the warehouse. It exposes three
views built from the silver layer: two dimensions and one fact table.

---

## gold.dim_customers

One row per customer.

| Column | Type | Description |
|---|---|---|
| customer_key | INT | Surrogate key, generated for this view. Primary key of this dimension. |
| customer_id | INT | Original customer ID from the CRM system (`cst_id`). |
| customer_number | NVARCHAR(50) | Customer's tracking key used to join to other systems (`cst_key`). |
| first_name | NVARCHAR(50) | Customer's first name. |
| last_name | NVARCHAR(50) | Customer's last name (family name). |
| country | NVARCHAR(50) | Country of residence, e.g. `Germany`, `United States`. `n/a` if unknown. |
| marital_status | NVARCHAR(50) | `Single`, `Married`, or `n/a` if unknown. |
| gender | NVARCHAR(50) | `Female`, `Male`, or `n/a` if unknown. CRM is the primary source; the ERP value fills in only when CRM has none. |
| birthdate | DATE | Date of birth. `NULL` if missing or if the source value was clearly invalid (e.g. a future date). |
| create_date | DATE | Date the customer record was created in the CRM source system. |

---

## gold.dim_products

One row per currently active product. Discontinued or historical product
versions are excluded, since this project's scope does not require
historization.

| Column | Type | Description |
|---|---|---|
| product_key | INT | Surrogate key, generated for this view. Primary key of this dimension. |
| product_id | INT | Original product ID from the CRM system (`prd_id`). |
| product_number | NVARCHAR(50) | Alphanumeric product code, used to join to `gold.fact_sales`. |
| product_name | NVARCHAR(50) | Descriptive product name, including key details such as type, color, and size. |
| category_id | NVARCHAR(50) | ID that links this product to its category in the ERP system. |
| category | NVARCHAR(50) | High-level product category, e.g. `Bikes`, `Components`. `NULL` if the category ID has no match in the ERP source. |
| subcategory | NVARCHAR(50) | More detailed product classification within the category. |
| maintenance | NVARCHAR(50) | Whether the product requires maintenance (`Yes`/`No`). |
| cost | INT | Base price of the product, in whole currency units. |
| product_line | NVARCHAR(50) | Product line: `Mountain`, `Road`, `Other Sales`, `Touring`, or `n/a`. |
| start_date | DATE | Date the product became available for sale. |

**Known gap:** 7 of 397 products carry a category ID (`CO_PE`) that has no
match in the ERP category file, so `category`, `subcategory`, and
`maintenance` are `NULL` for those rows.

---

## gold.fact_sales

One row per sales order line. Links to `gold.dim_customers` through
`customer_key` and to `gold.dim_products` through `product_key`.

| Column | Type | Description |
|---|---|---|
| order_number | NVARCHAR(50) | Unique identifier for the sales order, e.g. `SO54496`. |
| product_key | INT | Foreign key to `gold.dim_products.product_key`. |
| customer_key | INT | Foreign key to `gold.dim_customers.customer_key`. |
| order_date | DATE | Date the order was placed. `NULL` if the source value was missing or invalid. |
| shipping_date | DATE | Date the order was shipped to the customer. |
| due_date | DATE | Date payment for the order was due. |
| sales_amount | INT | Total value of the line item, in whole currency units. |
| quantity | INT | Number of units ordered for this line item. |
| price | INT | Price per unit, in whole currency units. |

---

## Star Schema

```
        gold.dim_customers
                |
                | customer_key
                v
        gold.fact_sales  ------->  gold.dim_products
                              product_key
```

`fact_sales` sits at the center, with one row per order line. Each row
points to exactly one customer and one product, which is the standard
star-schema shape for reporting: aggregate `fact_sales`, then group or
filter by any column in `dim_customers` or `dim_products`.
