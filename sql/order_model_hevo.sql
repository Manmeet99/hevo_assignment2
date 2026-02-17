WITH deduped AS (
    SELECT DISTINCT *
    FROM SNOW1_PUBLIC.orders_raw
),

amount_fixed AS (
    SELECT
        order_id,
        customer_id,
        product_id,

        CASE
            WHEN amount < 0 THEN 0
            ELSE amount
        END AS amount,

        created_at,
        UPPER(currency) AS currency
    FROM deduped
),

median_calc AS (
    SELECT
        customer_id,
        MEDIAN(amount) AS median_amount
    FROM amount_fixed
    WHERE amount IS NOT NULL
    GROUP BY customer_id
)

SELECT
    o.order_id,
    o.customer_id,
    o.product_id,

    COALESCE(o.amount, m.median_amount, 0) AS amount,

    o.created_at,
    o.currency,

    CASE o.currency
        WHEN 'USD' THEN COALESCE(o.amount, m.median_amount, 0) * 1
        WHEN 'INR' THEN COALESCE(o.amount, m.median_amount, 0) * 0.012
        WHEN 'SGD' THEN COALESCE(o.amount, m.median_amount, 0) * 0.74
        WHEN 'EUR' THEN COALESCE(o.amount, m.median_amount, 0) * 1.1
        ELSE COALESCE(o.amount, m.median_amount, 0)
    END AS amount_usd

FROM amount_fixed o
LEFT JOIN median_calc m
    ON o.customer_id = m.customer_id