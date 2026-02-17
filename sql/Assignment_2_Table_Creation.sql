-- Drop tables if they already exist
DROP TABLE IF EXISTS orders_raw;
DROP TABLE IF EXISTS customers_raw;
DROP TABLE IF EXISTS products_raw;
DROP TABLE IF EXISTS country_dim;


-- 1. customers_raw
CREATE TABLE customers_raw (
    customer_id INT,
    email TEXT,
    phone TEXT,
    country_code TEXT,
    updated_at TIMESTAMP,
    created_at TIMESTAMP
);


-- 2. orders_raw
CREATE TABLE orders_raw (
    order_id INT,
    customer_id INT,
    product_id TEXT,
    amount NUMERIC(10,2),
    created_at TIMESTAMP,
    currency TEXT
);


-- 3. products_raw
CREATE TABLE products_raw (
    product_id TEXT,
    product_name TEXT,
    category TEXT,
    active_flag CHAR(1)
);


-- 4. country_dim
CREATE TABLE country_dim (
    country_name TEXT,
    iso_code TEXT
);
