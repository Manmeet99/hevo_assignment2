SELECT
    o.order_id,
    DATE(o.created_at) AS order_date,
    o.amount,
    o.amount_usd,
    o.currency,

    /* Customer Handling */
    CASE
        WHEN c.customer_id IS NULL THEN 'Orphan Customer'
        WHEN c.email IS NULL 
             AND c.phone = 'Unknown'
             AND c.country_code = 'Unknown'
        THEN 'Invalid Customer'
        ELSE c.email
    END AS email,

    CASE
        WHEN c.customer_id IS NULL THEN 'Unknown'
        ELSE c.phone
    END AS phone,

    CASE
        WHEN c.customer_id IS NULL THEN 'Unknown'
        ELSE c.country_code
    END AS country_code,

    /* Product Handling */
    COALESCE(p.product_name, 'Unknown Product') AS product_name,
    COALESCE(p.category, 'Unknown') AS category,
    COALESCE(p.product_status, 'Unknown') AS product_status

FROM PUBLIC.orders_clean o

LEFT JOIN PUBLIC.customer_clean c
    ON o.customer_id = c.customer_id

LEFT JOIN PUBLIC.products_clean p
    ON o.product_id = p.product_id