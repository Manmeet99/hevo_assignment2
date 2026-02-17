SELECT
    o.order_id,
    date( o.created_at) AS order_date,
    o.amount,
    o.amount_usd,
    o.currency,

    -- Customer Handling
    CASE
        WHEN c.customer_id IS NULL THEN 'Orphan Customer'
        WHEN c.email IS NULL THEN 'Invalid Customer'
        ELSE c.email
    END AS email,

    COALESCE(c.phone, 'Unknown') AS phone,
    COALESCE(c.country_code, 'Unknown') AS country_code,

    -- Product Handling
    COALESCE(p.product_name, 'Unknown Product') AS product_name,
    COALESCE(p.category, 'Unknown') AS category,
    COALESCE(p.product_status, 'Unknown') AS product_status

FROM PUBLIC.orders_clean o   -- replace with your actual model name

LEFT JOIN PUBLIC.customer_clean c
    ON o.customer_id = c.customer_id

LEFT JOIN PUBLIC.products_clean p
    ON o.product_id = p.product_id