# Hevo – Snowflake Data Cleaning Assessment

## Project Overview

This project demonstrates post-load data cleaning and transformation using Hevo Models on Snowflake.

Raw data was ingested from PostgreSQL into Snowflake using Logical Replication. After ingestion, SELECT-based transformation models were created in Hevo to clean, standardize, and prepare the data for analytics.

The raw data contained:

- Duplicate customer records  
- Inconsistent country formats  
- Invalid and negative order amounts  
- Mixed currency formats  
- Null values  
- Orphan foreign key references  
- Inactive products  

The objective was to clean this data and produce a single unified dataset ready for analytics.

---

## Architecture

PostgreSQL → Hevo Pipeline (Logical Replication) → Snowflake → Hevo Models

- Source: PostgreSQL  
- Destination: Snowflake (Trial Account)  
- Ingestion Mode: Logical Replication  
- Transformation Layer: Hevo Models (SELECT-only queries)

---

## Transformation Logic

### 1. Customers Model

Key transformations applied:

- Deduplicated customers using `ROW_NUMBER()` partitioned by `customer_id`
- Kept the most recent record using `updated_at DESC`
- Standardized email to lowercase
- Standardized phone numbers to 10-digit numeric format
- Invalid or missing phone numbers replaced with `"Unknown"`
- Replaced NULL `created_at` with `'1900-01-01'`
- Standardized `country_code` using `country_dim` table

---

### 2. Orders Model

Key transformations applied:

- Removed exact duplicate rows using `SELECT DISTINCT`
- Negative amounts replaced with `0`
- NULL amounts replaced with median value per customer
- Standardized currency codes to uppercase
- Created derived column `amount_usd` by converting all currencies to USD

#### Currency Conversion Assumptions

| Currency | Conversion Rate to USD |
|----------|-----------------------|
| USD      | 1.0 |
| INR      | 0.012 |
| SGD      | 0.74 |
| EUR      | 1.1 |

---

### 3. Products Model

Key transformations applied:

- Standardized product names using `INITCAP()`
- Standardized category names to Title Case
- Products with `active_flag = 'N'` marked as `"Discontinued Product"`

---

### 4. Final Unified Dataset

The final dataset was created by joining:

- Cleaned Orders  
- Cleaned Customers  
- Cleaned Products  

Design decisions:

- Used LEFT JOINs to ensure no orders were dropped
- Orders referencing missing customers labeled as `"Orphan Customer"`
- Customers with completely NULL values labeled as `"Invalid Customer"`
- Missing or invalid product references labeled as `"Unknown Product"`
- Currency handling standardized across all records

---

## Edge Cases Handled

- Duplicate customer records (latest retained)
- Duplicate orders removed
- Negative order amounts corrected
- NULL timestamps defaulted to `1900-01-01`
- Mixed-case country and currency values standardized
- Orphan foreign key references preserved
- Completely NULL customer records flagged as invalid
- Inactive products labeled clearly

---

## Final Dataset Characteristics

The final dataset:

- Preserves all transactional records
- Handles orphan references safely
- Standardizes financial metrics
- Is ready for analytical and reporting use

---

## Security & Best Practices

- No credentials or secrets stored in the repository
- No connection strings committed
- All transformations implemented using SELECT-only Hevo Models
- Modular transformation approach for clarity and maintainability

---

## Demonstration

A Loom recording was created demonstrating:

1. PostgreSQL setup  
2. Hevo pipeline configuration  
3. Snowflake raw data validation  
4. Model creation and deployment  
5. Final dataset verification  

---

## Deliverables

- GitHub Repository  
- Hevo Account Team Name  
- Pipeline ID  
- Model IDs  
- Loom Recording  

---

## Assumptions

- Fixed currency conversion rates were used.
- Median fallback is acceptable for NULL transaction values.
- Default timestamp `'1900-01-01'` used for missing `created_at`.
- Unknown or invalid values are explicitly labeled rather than dropped.
