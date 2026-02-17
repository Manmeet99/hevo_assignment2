SELECT
    product_id,

    INITCAP(product_name) AS product_name,

    INITCAP(category) AS category,

    CASE
        WHEN active_flag = 'N'
            THEN 'Discontinued Product'
        ELSE 'Active'
    END AS product_status

FROM SNOW1_PUBLIC.products_raw