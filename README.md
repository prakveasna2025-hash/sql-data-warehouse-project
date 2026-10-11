# SQL Server Data Warehouse Project

A hands-on Data Engineering project that builds a SQL Server data warehouse by integrating raw CRM and ERP data into a clean, structured model for analytical reporting.

## 📌 Project Overview

This project demonstrates an end-to-end data warehousing workflow, from loading raw CSV files to transforming and integrating data into a dimensional model.

The goal is to create a reliable foundation for analyzing customer behavior, product performance, and sales trends using SQL.

## 🏗️ Architecture

The project follows a **Medallion Architecture** with three layers:

- **Bronze Layer:** Stores raw data loaded from CRM and ERP CSV files.
- **Silver Layer:** Cleans, standardizes, and validates the source data.
- **Gold Layer:** Organizes business-ready data into a dimensional model for analytics.

```
Data Flow: docs(/Architecture.png)
```

## 🛠️ Technologies Used

- **Microsoft SQL Server** — Relational database and warehouse.
- **SQL Server Management Studio (SSMS)** — Database development and administration.
- **T-SQL** — Data loading, cleansing, transformation, and modeling.
- **Stored Procedures** — Reusable and organized ETL execution.
- **BULK INSERT** — Loading source CSV files into SQL Server.
- **Git and GitHub** — Version control and project documentation.

## 🔄 Data Engineering Workflow

### 1. Data Ingestion

- Load CRM and ERP CSV files into the Bronze layer.
- Use SQL Server `BULK INSERT` for bulk data loading.
- Structure raw data in source-specific tables.

### 2. Data Transformation and Quality

- Clean and standardize source data.
- Handle duplicates and inconsistent values.
- Apply SQL functions and window functions where appropriate.
- Validate and integrate data from multiple source systems.

### 3. Data Modeling

- Organize transformed data into the Gold layer.
- Apply dimensional modeling principles.
- Use fact and dimension tables to support analytical queries.
- Structure the model around business entities and sales analysis.

### 4. ETL Orchestration and Logging

- Use stored procedures to organize the loading process.
- Apply `TRY...CATCH` for error handling.
- Track execution start times, end times, and durations.
- Display execution messages to make the loading process easier to monitor.

## 📊 Analytical Use Cases

The resulting data model supports questions such as:

- **Customer Analysis:** Who are the customers, and how can their purchasing behavior be analyzed?
- **Product Analysis:** Which products perform well?
- **Sales Analysis:** How do sales vary across products and customers?
- **Business Reporting:** How can integrated CRM and ERP data support consistent reporting?

## 📁 Repository Structure

```text
sql-data-warehouse-project/
├── datasets/    # Source datasets
├── docs/        # Project documentation
├── scripts/     # SQL scripts for warehouse development
├── Test/        # Testing-related files
└── README.md    # Project documentation
```

## 🎯 Key Learning Outcomes

Through this project, I practiced:

- Building a SQL Server data warehouse.
- Implementing Bronze, Silver, and Gold data layers.
- Loading CSV data using SQL Server.
- Writing reusable SQL stored procedures.
- Applying data cleansing and transformation techniques.
- Handling errors and monitoring ETL execution.
- Designing fact and dimension tables using a star schema.
- Using SQL to prepare integrated data for analytics.

## 🚀 Future Improvements

- Automate scheduled ETL execution.
- Add more comprehensive data quality checks.
- Introduce automated testing for transformations.
- Connect the Gold layer to a BI tool for interactive dashboards.
- Improve pipeline monitoring and operational logging.

## 👨‍💻 About This Project

This is a hands-on portfolio project created to strengthen my practical SQL and Data Engineering skills, particularly in data ingestion, ETL processes, data quality, and dimensional modeling.
