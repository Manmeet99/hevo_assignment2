WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY updated_at DESC NULLS LAST
           ) AS rn
    FROM SNOW1_PUBLIC.customers_raw
)

SELECT
    r.customer_id,

    LOWER(r.email) AS email,

    CASE
        WHEN REGEXP_REPLACE(r.phone, '[^0-9]', '') RLIKE '^[0-9]{10}$'
        THEN REGEXP_REPLACE(r.phone, '[^0-9]', '')
        ELSE 'Unknown'
    END AS phone,

    COALESCE(cd.iso_code, 'Unknown') AS country_code,

    COALESCE(r.created_at, TO_TIMESTAMP('1900-01-01')) AS created_at,

    r.updated_at

FROM ranked r

LEFT JOIN SNOW1_PUBLIC.country_dim cd
    ON UPPER(r.country_code) IN (
        UPPER(cd.country_name),
        UPPER(cd.iso_code),
        'USA',
        'UNITEDSTATES',
        'IND',
        'SINGAPORE'
    )

WHERE rn = 1